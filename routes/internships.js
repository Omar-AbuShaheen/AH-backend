const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { authenticateToken, requireStudent } = require('../middleware/auth');

// Get all active internships (public - for students)
router.get('/', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT i.*, cp.company_name, cp.industry 
      FROM internships i 
      JOIN company_profiles cp ON i.company_id = cp.user_id 
      WHERE i.is_active = true AND cp.is_approved = true AND i.is_approved = true
      ORDER BY i.created_at DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching internships:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// Company creates a new internship
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { id: userId } = req.user;
    const { title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_active } = req.body;
    
    // Verify user is a company
    const userCheck = await db.query('SELECT role FROM users WHERE id = $1', [userId]);
    if (userCheck.rows.length === 0 || userCheck.rows[0].role !== 'company') {
      return res.status(403).json({ message: 'Only companies can create internships' });
    }
    
    // Insert internship
    const result = await db.query(`
      INSERT INTO internships (company_id, title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_active, is_approved) 
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, false) 
      RETURNING *
    `, [userId, title, description, requirements || '', responsibilities || '', location, type, duration || '', stipend || '', deadline, is_active]);
    
    res.status(201).json({ 
      internship: result.rows[0], 
      message: 'Internship created successfully and pending admin approval' 
    });
  } catch (err) {
    console.error('Error creating internship:', err);
    res.status(500).json({ message: 'Failed to create internship', error: err.message });
  }
});

// Company updates their internship
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const { id: userId } = req.user;
    const internshipId = req.params.id;
    const { title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_active } = req.body;
    
    // Verify user owns this internship
    const ownershipCheck = await db.query(
      'SELECT id FROM internships WHERE id = $1 AND company_id = $2',
      [internshipId, userId]
    );
    
    if (ownershipCheck.rows.length === 0) {
      return res.status(403).json({ message: 'You can only update your own internships' });
    }
    
    // Update internship
    const result = await db.query(`
      UPDATE internships 
      SET title = $1, description = $2, requirements = $3, responsibilities = $4, 
          location = $5, type = $6, duration = $7, stipend = $8, deadline = $9, 
          is_active = $10, is_approved = false, updated_at = NOW()
      WHERE id = $11 
      RETURNING *
    `, [title, description, requirements || '', responsibilities || '', location, type, duration || '', stipend || '', deadline, is_active, internshipId]);
    
    res.json({ 
      internship: result.rows[0], 
      message: 'Internship updated successfully and pending admin approval' 
    });
  } catch (err) {
    console.error('Error updating internship:', err);
    res.status(500).json({ message: 'Failed to update internship', error: err.message });
  }
});

// Company deletes their internship
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const { id: userId } = req.user;
    const internshipId = req.params.id;
    
    // Verify user owns this internship
    const ownershipCheck = await db.query(
      'SELECT id FROM internships WHERE id = $1 AND company_id = $2',
      [internshipId, userId]
    );
    
    if (ownershipCheck.rows.length === 0) {
      return res.status(403).json({ message: 'You can only delete your own internships' });
    }
    
    // Delete internship
    await db.query('DELETE FROM internships WHERE id = $1', [internshipId]);
    
    res.json({ message: 'Internship deleted successfully' });
  } catch (err) {
    console.error('Error deleting internship:', err);
    res.status(500).json({ message: 'Failed to delete internship', error: err.message });
  }
});

// Company gets their own internships
router.get('/company/my-internships', authenticateToken, async (req, res) => {
  try {
    const { id: userId } = req.user;
    
    // Verify user is a company
    const userCheck = await db.query('SELECT role FROM users WHERE id = $1', [userId]);
    if (userCheck.rows.length === 0 || userCheck.rows[0].role !== 'company') {
      return res.status(403).json({ message: 'Only companies can access this endpoint' });
    }
    
    const result = await db.query(`
      SELECT * FROM internships 
      WHERE company_id = $1 
      ORDER BY created_at DESC
    `, [userId]);
    
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching company internships:', err);
    res.status(500).json({ message: 'Failed to fetch internships', error: err.message });
  }
});

// Search internships
router.get('/search', async (req, res) => {
  try {
    const { q, location, company } = req.query;
    let query = `
      SELECT i.*, cp.company_name, cp.industry 
      FROM internships i 
      JOIN company_profiles cp ON i.company_id = cp.user_id 
      WHERE i.is_active = true AND cp.is_approved = true
    `;
    const params = [];
    let paramCount = 0;
    
    if (q) {
      paramCount++;
      query += ` AND (i.title ILIKE $${paramCount} OR i.description ILIKE $${paramCount})`;
      params.push(`%${q}%`);
    }
    
    if (location) {
      paramCount++;
      query += ` AND i.location ILIKE $${paramCount}`;
      params.push(`%${location}%`);
    }
    
    if (company) {
      paramCount++;
      query += ` AND cp.company_name ILIKE $${paramCount}`;
      params.push(`%${company}%`);
    }
    
    query += ' ORDER BY i.created_at DESC';
    
    const result = await db.query(query, params);
    res.json(result.rows);
  } catch (err) {
    console.error('Error searching internships:', err);
    res.status(500).json({ message: 'Search failed', error: err.message });
  }
});

// Get internship by id
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(`
      SELECT i.*, cp.company_name, cp.industry 
      FROM internships i 
      JOIN company_profiles cp ON i.company_id = cp.user_id 
      WHERE i.id = $1 AND i.is_active = true AND cp.is_approved = true
    `, [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Internship not found' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error fetching internship:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// Student applies to an internship
router.post('/:id/apply', authenticateToken, requireStudent, async (req, res) => {
  try {
    const { id: userId } = req.user;
    const internshipId = req.params.id;
    const { cover_letter } = req.body;
    
    // Check if already applied
    const existingApp = await db.query(
      'SELECT id FROM applications WHERE student_id = $1 AND internship_id = $2',
      [userId, internshipId]
    );
    
    if (existingApp.rows.length > 0) {
      return res.status(400).json({ message: 'Already applied to this internship' });
    }
    
    // Insert application
    const result = await db.query(
      'INSERT INTO applications (student_id, internship_id, cover_letter, status) VALUES ($1, $2, $3, $4) RETURNING *',
      [userId, internshipId, cover_letter || null, 'Applied']
    );
    
    res.status(201).json({ 
      application: result.rows[0], 
      message: 'Application submitted successfully' 
    });
  } catch (err) {
    console.error('Application error:', err);
    res.status(500).json({ message: 'Application failed', error: err.message });
  }
});

module.exports = router;
