const express = require('express');
const router = express.Router();
const db = require('../config/db');

// Get all companies
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM companies ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching companies:', error);
    res.status(500).json({ error: 'Failed to fetch companies' });
  }
});

// Get company by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('SELECT * FROM companies WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Company not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching company:', error);
    res.status(500).json({ error: 'Failed to fetch company' });
  }
});

// Create new company
router.post('/', async (req, res) => {
  try {
    const { name, industry, location, description, website, contact_email, contact_phone } = req.body;
    
    const result = await db.query(
      `INSERT INTO companies (name, industry, location, description, website, contact_email, contact_phone, created_at) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, CURRENT_TIMESTAMP) 
       RETURNING *`,
      [name, industry, location, description, website, contact_email, contact_phone]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error creating company:', error);
    res.status(500).json({ error: 'Failed to create company' });
  }
});

// Update company
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, industry, location, description, website, contact_email, contact_phone } = req.body;
    
    const result = await db.query(
      `UPDATE companies 
       SET name = $1, industry = $2, location = $3, description = $4, website = $5, contact_email = $6, contact_phone = $7, updated_at = CURRENT_TIMESTAMP
       WHERE id = $8 
       RETURNING *`,
      [name, industry, location, description, website, contact_email, contact_phone, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Company not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating company:', error);
    res.status(500).json({ error: 'Failed to update company' });
  }
});

// Delete company
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check if company has internships
    const internshipsResult = await db.query('SELECT COUNT(*) FROM internships WHERE company_id = $1', [id]);
    if (parseInt(internshipsResult.rows[0].count) > 0) {
      return res.status(400).json({ error: 'Cannot delete company with existing internships' });
    }
    
    const result = await db.query('DELETE FROM companies WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Company not found' });
    }
    
    res.json({ message: 'Company deleted successfully' });
  } catch (error) {
    console.error('Error deleting company:', error);
    res.status(500).json({ error: 'Failed to delete company' });
  }
});

module.exports = router;
