const db = require('./config/db');
const bcrypt = require('bcryptjs');

async function setupDatabase() {
  try {
    console.log('🔧 Setting up database...');
    
    // Create admin table if it doesn't exist
    await db.query(`
      CREATE TABLE IF NOT EXISTS admins (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('✅ Admin table created/verified');
    
    // Check if admin already exists
    const existingAdmin = await db.query('SELECT * FROM admins WHERE email = $1', ['admin@careernest.com']);
    
    if (existingAdmin.rows.length === 0) {
      // Create admin user
      const passwordHash = await bcrypt.hash('admin123', 10);
      await db.query(
        'INSERT INTO admins (name, email, password_hash) VALUES ($1, $2, $3)',
        ['Admin User', 'admin@careernest.com', passwordHash]
      );
      console.log('✅ Admin user created: admin@careernest.com / admin123');
    } else {
      console.log('ℹ️ Admin user already exists');
    }
    
    // Check if students table exists
    const studentsTable = await db.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'students'
      )
    `);
    
    if (!studentsTable.rows[0].exists) {
      console.log('❌ Students table does not exist. Please create it first.');
      return;
    }
    
    console.log('✅ Database setup completed successfully!');
    
  } catch (error) {
    console.error('❌ Database setup error:', error);
  } finally {
    process.exit(0);
  }
}

setupDatabase();
