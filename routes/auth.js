const express = require('express');
const router = express.Router();
const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { authenticateToken, requireCompany, requireStudent } = require('../middleware/auth');

// Student registration
router.post('/student/register', async (req, res) => {
  try {
    const { first_name, last_name, email, major, university, graduation_year, phone, skills, experience, password } = req.body;
    
    // Check if user already exists
    const existingUser = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash the password
    const passwordHash = await bcrypt.hash(password, 10);
    
    // Start a transaction
    const client = await db.connect();
    try {
      await client.query('BEGIN');
      
      // Insert new user
      const userResult = await client.query(
        'INSERT INTO users (email, password_hash, role) VALUES ($1, $2, $3) RETURNING id, email, role, created_at',
        [email, passwordHash, 'student']
      );
      
      const userId = userResult.rows[0].id;
      
      // Insert student profile
      const profileResult = await client.query(
        'INSERT INTO student_profiles (user_id, first_name, last_name, university, major, graduation_year, phone, skills, experience) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *',
        [userId, first_name, last_name, university, major, graduation_year, phone, skills || '', experience || '']
      );
      
      await client.query('COMMIT');
      
      const user = userResult.rows[0];
      const profile = profileResult.rows[0];
      
      // Generate JWT token
      const token = jwt.sign(
        { id: user.id, email: user.email, role: 'student' },
        process.env.JWT_SECRET,
        { expiresIn: '24h' }
      );

      res.status(201).json({
        message: 'Student registered successfully',
        token,
        user: {
          id: user.id,
          email: user.email,
          role: 'student',
          first_name: profile.first_name,
          last_name: profile.last_name,
          name: `${profile.first_name} ${profile.last_name}`,
          major: profile.major,
          university: profile.university,
          graduation_year: profile.graduation_year,
          phone: profile.phone,
          skills: profile.skills,
          experience: profile.experience
        }
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Company registration
router.post('/company/register', async (req, res) => {
  try {
    const { company_name, contact_person, email, industry, location, website, description, phone, password } = req.body;
    
    // Check if user already exists
    const existingUser = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash the password
    const passwordHash = await bcrypt.hash(password, 10);
    
    // Start a transaction
    const client = await db.connect();
    try {
      await client.query('BEGIN');
      
      // Insert new user
      const userResult = await client.query(
        'INSERT INTO users (email, password_hash, role) VALUES ($1, $2, $3) RETURNING id, email, role, created_at',
        [email, passwordHash, 'company']
      );
      
      const userId = userResult.rows[0].id;
      
      // Insert company profile
      const profileResult = await client.query(
        'INSERT INTO company_profiles (user_id, company_name, contact_person, industry, location, website, description, phone, is_approved) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *',
        [userId, company_name, contact_person, industry || '', location || '', website || '', description || '', phone, false]
      );
      
      await client.query('COMMIT');
      
      const user = userResult.rows[0];
      const profile = profileResult.rows[0];
      
      // Generate JWT token
      const token = jwt.sign(
        { id: user.id, email: user.email, role: 'company' },
        process.env.JWT_SECRET,
        { expiresIn: '24h' }
      );

      res.status(201).json({
        message: 'Company registered successfully',
        token,
        user: {
          id: user.id,
          email: user.email,
          role: 'company',
          company_name: profile.company_name,
          contact_person: profile.contact_person,
          industry: profile.industry,
          location: profile.location,
          website: profile.website,
          description: profile.description,
          phone: profile.phone,
          is_approved: profile.is_approved
        }
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('Company registration error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Unified login endpoint (automatically detects role)
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Find user by email
    const userResult = await db.query(
      'SELECT id, email, password_hash, role FROM users WHERE email = $1',
      [email]
    );
    
    if (userResult.rows.length === 0) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    const user = userResult.rows[0];
    
    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    // Get role-specific data
    let userData = { id: user.id, email: user.email, role: user.role };
    
    if (user.role === 'student') {
      const profileResult = await db.query(
        'SELECT first_name, last_name, major, university, graduation_year, phone, skills, experience FROM student_profiles WHERE user_id = $1',
        [user.id]
      );
      if (profileResult.rows.length > 0) {
        const profile = profileResult.rows[0];
        userData = {
          ...userData,
          ...profile,
          name: `${profile.first_name} ${profile.last_name}`
        };
      }
    } else if (user.role === 'company') {
      const profileResult = await db.query(
        'SELECT company_name, contact_person, industry, location, website, description, phone, is_approved FROM company_profiles WHERE user_id = $1',
        [user.id]
      );
      if (profileResult.rows.length > 0) {
        const profile = profileResult.rows[0];
        
        // Check if company is approved
        if (!profile.is_approved) {
          return res.status(403).json({ message: 'Company account not yet approved. Please wait for admin approval.' });
        }
        
        userData = {
          ...userData,
          ...profile
        };
      }
    } else if (user.role === 'admin') {
      // Admin doesn't need additional profile data
      userData = {
        ...userData,
        name: 'Administrator'
      };
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login successful',
      token,
      user: userData
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Update student profile
router.put('/students/profile', authenticateToken, requireStudent, async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, phone, university, major, graduation_year, skills, experience } = req.body;
    
    // Split name into first_name and last_name
    const nameParts = (name || '').trim().split(' ');
    const first_name = nameParts[0] || '';
    const last_name = nameParts.slice(1).join(' ') || '';
    
    const result = await db.query(`
      UPDATE student_profiles 
      SET first_name = $1, last_name = $2, phone = $3, university = $4, major = $5, 
          graduation_year = $6, skills = $7, experience = $8, updated_at = CURRENT_TIMESTAMP
      WHERE user_id = $9 
      RETURNING *
    `, [first_name, last_name, phone, university, major, graduation_year, skills, experience, userId]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student profile not found' });
    }
    
    res.json({ 
      message: 'Student profile updated successfully',
      profile: result.rows[0]
    });
  } catch (err) {
    console.error('Error updating student profile:', err);
    res.status(500).json({ message: 'Failed to update student profile', error: err.message });
  }
});

// Upload student resume
router.post('/students/resume', authenticateToken, requireStudent, async (req, res) => {
  try {
    const userId = req.user.id;
    
    // For now, we'll just acknowledge the upload
    // In a real application, you would handle file upload with multer
    // and store the file path in the database
    
    res.json({ 
      message: 'Resume uploaded successfully',
      note: 'File upload functionality would be implemented with multer in production'
    });
  } catch (err) {
    console.error('Error uploading resume:', err);
    res.status(500).json({ message: 'Failed to upload resume', error: err.message });
  }
});

// Update company profile
router.put('/company/profile', authenticateToken, requireCompany, async (req, res) => {
  try {
    const userId = req.user.id;
    const { company_name, contact_person, industry, location, website, description, phone } = req.body;
    
    const result = await db.query(`
      UPDATE company_profiles 
      SET company_name = $1, contact_person = $2, industry = $3, location = $4, 
          website = $5, description = $6, phone = $7, updated_at = CURRENT_TIMESTAMP
      WHERE user_id = $8 
      RETURNING *
    `, [company_name, contact_person, industry, location, website, description, phone, userId]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Company profile not found' });
    }
    
    res.json({ 
      message: 'Company profile updated successfully',
      profile: result.rows[0]
    });
  } catch (err) {
    console.error('Error updating company profile:', err);
    res.status(500).json({ message: 'Failed to update company profile', error: err.message });
  }
});

// Get current user info
router.get('/me', async (req, res) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({ message: 'No token provided' });
    }
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role === 'student') {
      const result = await db.query(
        'SELECT u.id, u.email, u.role, sp.first_name, sp.last_name, sp.major, sp.university, sp.graduation_year, sp.phone, sp.skills, sp.experience FROM users u JOIN student_profiles sp ON u.id = sp.user_id WHERE u.id = $1',
        [decoded.id]
      );
      if (result.rows.length > 0) {
        const user = result.rows[0];
        res.json({ 
          user: {
            id: user.id,
            email: user.email,
            role: user.role,
            name: `${user.first_name} ${user.last_name}`.trim(),
            first_name: user.first_name,
            last_name: user.last_name,
            major: user.major,
            university: user.university,
            graduation_year: user.graduation_year,
            phone: user.phone,
            skills: user.skills,
            experience: user.experience
          }
        });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    } else if (decoded.role === 'company') {
      const result = await db.query(
        'SELECT u.id, u.email, u.role, cp.company_name, cp.contact_person, cp.industry, cp.location, cp.website, cp.description, cp.phone, cp.is_approved FROM users u JOIN company_profiles cp ON u.id = cp.user_id WHERE u.id = $1',
        [decoded.id]
      );
      if (result.rows.length > 0) {
        const user = result.rows[0];
        res.json({ 
          user: {
            id: user.id,
            email: user.email,
            role: user.role,
            company_name: user.company_name,
            contact_person: user.contact_person,
            industry: user.industry,
            location: user.location,
            website: user.website,
            description: user.description,
            phone: user.phone,
            is_approved: user.is_approved
          }
        });
      } else {
        res.status(404).json({ message: 'Company not found' });
      }
    } else if (decoded.role === 'admin') {
      const result = await db.query(
        'SELECT id, email, role FROM users WHERE id = $1 AND role = $2',
        [decoded.id, 'admin']
      );
      if (result.rows.length > 0) {
        const user = result.rows[0];
        res.json({ 
          user: {
            id: user.id,
            email: user.email,
            role: user.role
          }
        });
      } else {
        res.status(404).json({ message: 'Admin not found' });
      }
    } else {
      res.status(400).json({ message: 'Invalid user role' });
    }
  } catch (error) {
    console.error('Get user error:', error);
    res.status(401).json({ message: 'Invalid token' });
  }
});

module.exports = router;
