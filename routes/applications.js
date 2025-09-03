const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { authenticateToken, requireStudent, requireAdmin } = require('../middleware/auth');

// Get all applications for the logged-in student
router.get('/my-applications', authenticateToken, requireStudent, async (req, res) => {
  try {
    const student_id = req.user.id;
    
    const result = await db.query(`
      SELECT a.*, 
             i.title as internship_title, 
             cp.company_name, 
             i.location,
             i.type,
             cm.id as message_id,
             cm.message_type,
             cm.message as company_message,
             cm.contact_email as company_contact_email,
             cm.created_at as message_date
      FROM applications a
      JOIN internships i ON a.internship_id = i.id
      JOIN company_profiles cp ON i.company_id = cp.user_id
      LEFT JOIN (
        SELECT DISTINCT ON (application_id) *
        FROM company_messages 
        ORDER BY application_id, created_at DESC
      ) cm ON a.id = cm.application_id
      WHERE a.student_id = $1
      ORDER BY a.applied_date DESC
    `, [student_id]);
    
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching applications:', err);
    res.status(500).json({ message: 'Failed to fetch applications', error: err.message });
  }
});

// Get all applications (admin only)
router.get('/', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const result = await db.query(`
      SELECT a.*, 
             sp.first_name, sp.last_name, 
             CONCAT(sp.first_name, ' ', sp.last_name) as student_name,
             u.email as student_email, 
             i.title as internship_title, 
             cp.company_name
      FROM applications a
      JOIN users u ON a.student_id = u.id
      JOIN student_profiles sp ON u.id = sp.user_id
      JOIN internships i ON a.internship_id = i.id
      JOIN company_profiles cp ON i.company_id = cp.user_id
      ORDER BY a.applied_date DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching applications:', err);
    res.status(500).json({ message: 'Failed to fetch applications', error: err.message });
  }
});

// Get applications for a specific company
router.get('/company', authenticateToken, async (req, res) => {
  try {
    // Check if user is a company
    if (req.user.role !== 'company') {
      return res.status(403).json({ message: 'Access denied. Company role required.' });
    }
    
    const result = await db.query(`
      SELECT a.*, 
             sp.first_name, sp.last_name, 
             CONCAT(sp.first_name, ' ', sp.last_name) as student_name,
             u.email as student_email, 
             i.title as internship_title,
             i.company_id
      FROM applications a
      JOIN users u ON a.student_id = u.id
      JOIN student_profiles sp ON u.id = sp.user_id
      JOIN internships i ON a.internship_id = i.id
      WHERE i.company_id = $1
      ORDER BY a.applied_date DESC
    `, [req.user.id]);
    
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching company applications:', err);
    res.status(500).json({ message: 'Failed to fetch applications', error: err.message });
  }
});

// Company updates application status for their internships with optional message
router.patch('/company/:id/status', authenticateToken, async (req, res) => {
  try {
    // Check if user is a company
    if (req.user.role !== 'company') {
      return res.status(403).json({ message: 'Access denied. Company role required.' });
    }
    
    const { id } = req.params;
    const { status, message, contact_email } = req.body;
    
    // Verify the application belongs to this company's internship
    const application = await db.query(`
      SELECT a.id, a.student_id FROM applications a
      JOIN internships i ON a.internship_id = i.id
      WHERE a.id = $1 AND i.company_id = $2
    `, [id, req.user.id]);
    
    if (application.rows.length === 0) {
      return res.status(404).json({ message: 'Application not found or access denied' });
    }
    
    const student_id = application.rows[0].student_id;
    
    try {
      // Begin transaction
      await db.query('BEGIN');
      
      // Update application status
      const result = await db.query(
        'UPDATE applications SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *',
        [status, id]
      );
      
      if (result.rows.length === 0) {
        await db.query('ROLLBACK');
        return res.status(404).json({ message: 'Application not found' });
      }
      
      // If status is hired or rejected and message is provided, create a company message
      if ((status === 'Hired' || status === 'Rejected') && message && message.trim()) {
        await db.query(`
          INSERT INTO company_messages (application_id, company_id, student_id, message_type, message, contact_email)
          VALUES ($1, $2, $3, $4, $5, $6)
        `, [
          id, 
          req.user.id, 
          student_id, 
          status.toLowerCase(), 
          message.trim(),
          contact_email || null
        ]);
      }
      
      // Commit transaction
      await db.query('COMMIT');
      
      res.json({ 
        application: result.rows[0], 
        message: 'Application status updated successfully' 
      });
    } catch (transactionError) {
      await db.query('ROLLBACK');
      throw transactionError;
    }
  } catch (err) {
    console.error('Error updating application status:', err);
    res.status(500).json({ message: 'Failed to update application status', error: err.message });
  }
});

// Update application status (admin only)
router.put('/:id/status', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
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

// Get application statistics (admin only)
router.get('/stats', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const stats = await db.query(`
      SELECT 
        COUNT(*) as total_applications,
        COUNT(CASE WHEN status = 'Applied' THEN 1 END) as pending,
        COUNT(CASE WHEN status = 'Hired' THEN 1 END) as accepted,
        COUNT(CASE WHEN status = 'Rejected' THEN 1 END) as rejected,
        COUNT(CASE WHEN status = 'Withdrawn' THEN 1 END) as withdrawn
      FROM applications
    `);
    
    res.json(stats.rows[0]);
  } catch (err) {
    console.error('Error fetching application stats:', err);
    res.status(500).json({ message: 'Failed to fetch stats', error: err.message });
  }
});

// Get application statistics for company
router.get('/company/stats', authenticateToken, async (req, res) => {
  try {
    // Check if user is a company
    if (req.user.role !== 'company') {
      return res.status(403).json({ message: 'Access denied. Company role required.' });
    }
    
    const stats = await db.query(`
      SELECT 
        COUNT(*) as total_applications,
        COUNT(CASE WHEN a.status = 'Applied' THEN 1 END) as pending_applications,
        COUNT(CASE WHEN a.status = 'Hired' THEN 1 END) as accepted_applications,
        COUNT(CASE WHEN a.status = 'Rejected' THEN 1 END) as rejected_applications
      FROM applications a
      JOIN internships i ON a.internship_id = i.id
      WHERE i.company_id = $1
    `, [req.user.id]);
    
    res.json(stats.rows[0]);
  } catch (err) {
    console.error('Error fetching company application stats:', err);
    res.status(500).json({ message: 'Failed to fetch application stats', error: err.message });
  }
});

// Get messages for student applications
router.get('/my-messages', authenticateToken, requireStudent, async (req, res) => {
  try {
    const student_id = req.user.id;
    
    const result = await db.query(`
      SELECT cm.*, 
             a.id as application_id,
             i.title as internship_title, 
             cp.company_name,
             a.status as application_status
      FROM company_messages cm
      JOIN applications a ON cm.application_id = a.id
      JOIN internships i ON a.internship_id = i.id
      JOIN company_profiles cp ON i.company_id = cp.user_id
      WHERE cm.student_id = $1
      ORDER BY cm.created_at DESC
    `, [student_id]);
    
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching messages:', err);
    res.status(500).json({ message: 'Failed to fetch messages', error: err.message });
  }
});

module.exports = router;
