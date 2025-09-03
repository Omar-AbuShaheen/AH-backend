
const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { authenticateToken, requireStudent, requireAdmin } = require('../middleware/auth');

// Get student profile (student only)
router.get('/profile', authenticateToken, requireStudent, async (req, res) => {
  try {
    const student_id = req.user.id;
    
    const result = await db.query(
      'SELECT u.id, u.email, u.role, sp.first_name, sp.last_name, sp.major, sp.university, sp.graduation_year, sp.phone, sp.skills, sp.experience, sp.location, sp.bio, sp.resume_url, sp.created_at FROM users u JOIN student_profiles sp ON u.id = sp.user_id WHERE u.id = $1 AND u.role = $2',
      [student_id, 'student']
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student profile not found' });
    }
    
    const user = result.rows[0];
    res.json({
      ...user,
      name: `${user.first_name} ${user.last_name}`
    });
  } catch (err) {
    console.error('Error fetching profile:', err);
    res.status(500).json({ message: 'Failed to fetch profile', error: err.message });
  }
});

// Update student profile (student only)
router.put('/profile', authenticateToken, requireStudent, async (req, res) => {
  try {
    const student_id = req.user.id;
    const { 
      name, 
      first_name, 
      last_name, 
      major, 
      university, 
      graduation_year, 
      phone, 
      skills, 
      experience, 
      location, 
      bio,
      gpa,
      education,
      date_of_birth,
      linkedin_url,
      github_url,
      portfolio_url
    } = req.body;

    // Handle name field - split into first_name and last_name if provided
    let fname = first_name;
    let lname = last_name;
    
    if (name && !first_name && !last_name) {
      const nameParts = name.trim().split(' ');
      fname = nameParts[0] || '';
      lname = nameParts.slice(1).join(' ') || '';
    }
    
    const result = await db.query(
      `UPDATE student_profiles SET 
        first_name = $1, 
        last_name = $2, 
        major = $3, 
        university = $4, 
        graduation_year = $5, 
        phone = $6, 
        skills = $7, 
        experience = $8, 
        location = $9, 
        bio = $10,
        gpa = $11,
        education = $12,
        date_of_birth = $13,
        linkedin_url = $14,
        github_url = $15,
        portfolio_url = $16,
        updated_at = CURRENT_TIMESTAMP 
      WHERE user_id = $17 RETURNING *`,
      [
        fname, 
        lname, 
        major, 
        university, 
        graduation_year, 
        phone, 
        skills || '', 
        experience || '', 
        location || '', 
        bio || '',
        gpa || null,
        education || '',
        date_of_birth || null,
        linkedin_url || '',
        github_url || '',
        portfolio_url || '',
        student_id
      ]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student profile not found' });
    }
    
    const profile = result.rows[0];
    res.json({ 
      user: {
        ...profile,
        name: `${profile.first_name} ${profile.last_name}`,
        id: student_id
      }, 
      message: 'Profile updated successfully' 
    });
  } catch (err) {
    console.error('Error updating profile:', err);
    res.status(500).json({ message: 'Failed to update profile', error: err.message });
  }
});

// Update student password (student only)
router.put('/password', authenticateToken, requireStudent, async (req, res) => {
  try {
    const student_id = req.user.id;
    const { currentPassword, newPassword } = req.body;
    
    // Verify current password
    const currentUser = await db.query('SELECT password_hash FROM users WHERE id = $1 AND role = $2', [student_id, 'student']);
    if (currentUser.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }
    
    const bcrypt = require('bcryptjs');
    const isValidPassword = await bcrypt.compare(currentPassword, currentUser.rows[0].password_hash);
    
    if (!isValidPassword) {
      return res.status(400).json({ message: 'Current password is incorrect' });
    }
    
    // Hash new password and update
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await db.query('UPDATE users SET password_hash = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2', [hashedPassword, student_id]);
    
    res.json({ message: 'Password updated successfully' });
  } catch (err) {
    console.error('Error updating password:', err);
    res.status(500).json({ message: 'Failed to update password', error: err.message });
  }
});

// Get student by ID (admin only)
router.get('/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await db.query(
      'SELECT u.id, u.email, u.role, sp.first_name, sp.last_name, sp.major, sp.university, sp.graduation_year, sp.phone, sp.skills, sp.experience, sp.location, sp.bio, sp.created_at FROM users u JOIN student_profiles sp ON u.id = sp.user_id WHERE u.id = $1 AND u.role = $2',
      [id, 'student']
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }
    
    const user = result.rows[0];
    res.json({
      ...user,
      name: `${user.first_name} ${user.last_name}`
    });
  } catch (err) {
    console.error('Error fetching student:', err);
    res.status(500).json({ message: 'Failed to fetch student', error: err.message });
  }
});

module.exports = router;
