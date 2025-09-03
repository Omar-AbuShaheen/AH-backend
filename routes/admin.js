const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

// ===== COMPANIES MANAGEMENT =====

// Get all companies
router.get('/companies', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const result = await db.query(`
      SELECT u.id, u.email, u.created_at, cp.company_name, cp.contact_person, cp.industry, cp.location, cp.website, cp.description, cp.phone, cp.is_approved
      FROM users u 
      JOIN company_profiles cp ON u.id = cp.user_id 
      WHERE u.role = 'company'
      ORDER BY cp.company_name
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching companies:', err);
    res.status(500).json({ message: 'Failed to fetch companies', error: err.message });
  }
});

// Update company details
router.put('/companies/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { company_name, contact_person, industry, location, website, description, phone, contact_email } = req.body;
    
    // Start transaction
    const client = await db.connect();
    try {
      await client.query('BEGIN');
      
      // Update company profile
      const companyResult = await client.query(
        'UPDATE company_profiles SET company_name = $1, contact_person = $2, industry = $3, location = $4, website = $5, description = $6, phone = $7, updated_at = CURRENT_TIMESTAMP WHERE user_id = $8 RETURNING *',
        [company_name, contact_person, industry, location, website, description, phone, id]
      );
      
      if (companyResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ message: 'Company not found' });
      }
      
      // Update user email if provided
      if (contact_email) {
        await client.query(
          'UPDATE users SET email = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
          [contact_email, id]
        );
      }
      
      await client.query('COMMIT');
      
      res.json({
        company: companyResult.rows[0],
        message: 'Company updated successfully'
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('Error updating company:', err);
    res.status(500).json({ message: 'Failed to update company', error: err.message });
  }
});

// Approve/Reject company
router.patch('/companies/:id/approval', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { is_approved } = req.body;
    
    const result = await db.query(
      'UPDATE company_profiles SET is_approved = $1, updated_at = CURRENT_TIMESTAMP WHERE user_id = $2 RETURNING *',
      [is_approved, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Company not found' });
    }
    
    res.json({ 
      company: result.rows[0], 
      message: `Company ${is_approved ? 'approved' : 'rejected'} successfully` 
    });
  } catch (err) {
    console.error('Error updating company approval:', err);
    res.status(500).json({ message: 'Failed to update company approval', error: err.message });
  }
});

// Delete company
router.delete('/companies/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Start a transaction
    const client = await db.connect();
    try {
      await client.query('BEGIN');
      
      // Delete company profile first
      await client.query('DELETE FROM company_profiles WHERE user_id = $1', [id]);
      
      // Delete user
      const result = await client.query('DELETE FROM users WHERE id = $1 AND role = $2 RETURNING *', [id, 'company']);
      
      if (result.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ message: 'Company not found' });
      }
      
      await client.query('COMMIT');
      res.json({ message: 'Company deleted successfully' });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('Error deleting company:', err);
    res.status(500).json({ message: 'Failed to delete company', error: err.message });
  }
});

// ===== INTERNSHIPS MANAGEMENT =====

// Get all internships (admin only)
router.get('/internships', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const result = await db.query(`
      SELECT i.*, cp.company_name, u.email as company_email
      FROM internships i 
      JOIN company_profiles cp ON i.company_id = cp.user_id 
      JOIN users u ON i.company_id = u.id
      ORDER BY i.created_at DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching internships:', err);
    res.status(500).json({ message: 'Failed to fetch internships', error: err.message });
  }
});

// Create new internship
router.post('/internships', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { company_id, title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_active } = req.body;
    
    const result = await db.query(
      'INSERT INTO internships (company_id, title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_active, is_approved) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING *',
      [company_id, title, description, requirements || '', responsibilities || '', location, type || 'Full-time', duration || '', stipend || '', deadline, is_active, true]
    );
    
    res.status(201).json({ 
      internship: result.rows[0], 
      message: 'Internship created successfully' 
    });
  } catch (err) {
    console.error('Error creating internship:', err);
    res.status(500).json({ message: 'Failed to create internship', error: err.message });
  }
});

// Update internship
router.put('/internships/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_active } = req.body;
    
    const result = await db.query(
      'UPDATE internships SET title = $1, description = $2, requirements = $3, responsibilities = $4, location = $5, type = $6, duration = $7, stipend = $8, deadline = $9, is_active = $10, updated_at = CURRENT_TIMESTAMP WHERE id = $11 RETURNING *',
      [title, description, requirements || '', responsibilities || '', location, type || 'Full-time', duration || '', stipend || '', deadline, is_active, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Internship not found' });
    }
    
    res.json({ 
      internship: result.rows[0], 
      message: 'Internship updated successfully' 
    });
  } catch (err) {
    console.error('Error updating internship:', err);
    res.status(500).json({ message: 'Failed to update internship', error: err.message });
  }
});

// Approve/Reject internship
router.patch('/internships/:id/approval', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { is_approved } = req.body;
    
    const result = await db.query(
      'UPDATE internships SET is_approved = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *',
      [is_approved, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Internship not found' });
    }
    
    res.json({ 
      internship: result.rows[0], 
      message: `Internship ${is_approved ? 'approved' : 'rejected'} successfully` 
    });
  } catch (err) {
    console.error('Error updating internship approval:', err);
    res.status(500).json({ message: 'Failed to update internship approval', error: err.message });
  }
});

// Delete internship
router.delete('/internships/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await db.query('DELETE FROM internships WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Internship not found' });
    }
    
    res.json({ message: 'Internship deleted successfully' });
  } catch (err) {
    console.error('Error deleting internship:', err);
    res.status(500).json({ message: 'Failed to delete internship', error: err.message });
  }
});

// ===== APPLICATIONS MANAGEMENT =====

// Get all applications (admin only)
router.get('/applications', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const result = await db.query(`
      SELECT a.*, 
             CONCAT(sp.first_name, ' ', sp.last_name) as student_name,
             u_student.email as student_email,
             i.title as internship_title,
             cp.company_name,
             u_company.email as company_email
      FROM applications a 
      JOIN student_profiles sp ON a.student_id = sp.user_id 
      JOIN users u_student ON a.student_id = u_student.id
      JOIN internships i ON a.internship_id = i.id
      JOIN company_profiles cp ON i.company_id = cp.user_id
      JOIN users u_company ON i.company_id = u_company.id
      ORDER BY a.applied_date DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching applications:', err);
    res.status(500).json({ message: 'Failed to fetch applications', error: err.message });
  }
});

// Update application status (admin only)
router.put('/applications/:id/status', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
    // Validate status
    const validStatuses = ['Applied', 'Shortlisted', 'Hired', 'Rejected', 'Withdrawn'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ message: 'Invalid status' });
    }
    
    const result = await db.query(
      'UPDATE applications SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *',
      [status, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Application not found' });
    }
    
    res.json({ 
      application: result.rows[0], 
      message: 'Application status updated successfully' 
    });
  } catch (err) {
    console.error('Error updating application status:', err);
    res.status(500).json({ message: 'Failed to update application status', error: err.message });
  }
});

// ===== STUDENTS MANAGEMENT =====

// Get all students
router.get('/students', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const result = await db.query(`
      SELECT u.id, u.email, u.created_at, sp.first_name, sp.last_name, sp.major, sp.university, sp.graduation_year, sp.phone, sp.skills, sp.experience
      FROM users u 
      JOIN student_profiles sp ON u.id = sp.user_id 
      WHERE u.role = 'student'
      ORDER BY sp.first_name, sp.last_name
    `);
    
    // Add name field for compatibility
    const students = result.rows.map(student => ({
      ...student,
      name: `${student.first_name} ${student.last_name}`
    }));
    
    res.json(students);
  } catch (err) {
    console.error('Error fetching students:', err);
    res.status(500).json({ message: 'Failed to fetch students', error: err.message });
  }
});

// Delete student
router.delete('/students/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Start a transaction
    const client = await db.connect();
    try {
      await client.query('BEGIN');
      
      // Delete student profile first
      await client.query('DELETE FROM student_profiles WHERE user_id = $1', [id]);
      
      // Delete user
      const result = await client.query('DELETE FROM users WHERE id = $1 AND role = $2 RETURNING *', [id, 'student']);
      
      if (result.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ message: 'Student not found' });
      }
      
      await client.query('COMMIT');
      res.json({ message: 'Student deleted successfully' });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('Error deleting student:', err);
    res.status(500).json({ message: 'Failed to delete student', error: err.message });
  }
});

// ===== DASHBOARD STATS =====

// Get admin dashboard statistics
router.get('/dashboard', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const [studentsCount, companiesCount, internshipsCount, applicationsCount] = await Promise.all([
      db.query('SELECT COUNT(*) FROM users WHERE role = $1', ['student']),
      db.query('SELECT COUNT(*) FROM users WHERE role = $1', ['company']),
      db.query('SELECT COUNT(*) FROM internships'),
      db.query('SELECT COUNT(*) FROM applications')
    ]);
    
    const stats = {
      total_students: parseInt(studentsCount.rows[0].count),
      total_companies: parseInt(companiesCount.rows[0].count),
      total_internships: parseInt(internshipsCount.rows[0].count),
      total_applications: parseInt(applicationsCount.rows[0].count)
    };
    
    res.json(stats);
  } catch (err) {
    console.error('Error fetching dashboard stats:', err);
    res.status(500).json({ message: 'Failed to fetch dashboard stats', error: err.message });
  }
});

// Update user status (admin only)
router.patch('/users/:userId/status', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { userId } = req.params;
    const { status } = req.body;
    
    // Get user role first
    const userResult = await db.query('SELECT role FROM users WHERE id = $1', [userId]);
    
    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    const user = userResult.rows[0];
    
    if (user.role === 'company') {
      // Update company approval status
      const result = await db.query(
        'UPDATE company_profiles SET is_approved = $1, updated_at = CURRENT_TIMESTAMP WHERE user_id = $2 RETURNING *',
        [status === 'approved', userId]
      );
      
      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Company profile not found' });
      }
      
      res.json({ 
        message: 'Company status updated successfully',
        userId,
        status: status === 'approved' ? 'approved' : 'rejected'
      });
    } else {
      res.status(400).json({ message: 'User type does not support status updates' });
    }
  } catch (err) {
    console.error('Error updating user status:', err);
    res.status(500).json({ message: 'Failed to update user status', error: err.message });
  }
});

module.exports = router;
