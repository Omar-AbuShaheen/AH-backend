const db = require('./config/db');

async function setupUnifiedUsers() {
  try {
    console.log('🔧 Setting up unified users table structure...');
    
    // Create users table
    await db.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(100) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'company', 'admin')),
        is_approved BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // Create student_profiles table
    await db.query(`
      CREATE TABLE IF NOT EXISTS student_profiles (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        university VARCHAR(200),
        major VARCHAR(100),
        graduation_year INTEGER,
        phone VARCHAR(20),
        skills TEXT[],
        experience TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // Create company_profiles table
    await db.query(`
      CREATE TABLE IF NOT EXISTS company_profiles (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        company_name VARCHAR(200) NOT NULL,
        industry VARCHAR(100),
        location VARCHAR(100),
        description TEXT,
        website VARCHAR(255),
        contact_person VARCHAR(100),
        contact_phone VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    console.log('✅ Unified users structure created successfully!');
    
  } catch (error) {
    console.error('❌ Setup error:', error);
  } finally {
    process.exit(0);
  }
}

setupUnifiedUsers();
