const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');

// Database configuration
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:0000@localhost:5432/careernest'
});

async function setupDatabase() {
  try {
    console.log('🚀 Starting database setup...');
    
    // Read the SQL file
    const sqlPath = path.join(__dirname, 'setup-clean-database.sql');
    const sqlContent = fs.readFileSync(sqlPath, 'utf8');
    
    // Split SQL into individual statements
    const statements = sqlContent
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'));
    
    console.log(`📝 Found ${statements.length} SQL statements to execute`);
    
    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      if (statement.trim()) {
        try {
          await pool.query(statement);
          console.log(`✅ Executed statement ${i + 1}`);
        } catch (error) {
          if (error.message.includes('does not exist')) {
            console.log(`⚠️  Statement ${i + 1} (table drop) - this is expected`);
          } else {
            console.error(`❌ Error in statement ${i + 1}:`, error.message);
          }
        }
      }
    }
    
    // Update test user passwords with proper hashes
    console.log('🔐 Updating test user passwords...');
    
    const testPassword = 'password123';
    const hashedPassword = await bcrypt.hash(testPassword, 10);
    
    // Update admin password
    await pool.query(
      'UPDATE users SET password_hash = $1 WHERE email = $2',
      [hashedPassword, 'admin@careernest.com']
    );
    
    // Update company password
    await pool.query(
      'UPDATE users SET password_hash = $1 WHERE email = $2',
      [hashedPassword, 'company@careernest.com']
    );
    
    // Update student password
    await pool.query(
      'UPDATE users SET password_hash = $1 WHERE email = $2',
      [hashedPassword, 'student@careernest.com']
    );
    
    console.log('✅ Test user passwords updated');
    console.log('📋 Test credentials:');
    console.log('   Admin: admin@careernest.com / password123');
    console.log('   Company: company@careernest.com / password123');
    console.log('   Student: student@careernest.com / password123');
    
    // Verify the structure
    const tables = await pool.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name
    `);
    
    console.log('\n📊 Database tables created:');
    tables.rows.forEach(row => {
      console.log(`   - ${row.table_name}`);
    });
    
    // Count records in each table
    const userCount = await pool.query('SELECT COUNT(*) FROM users');
    const studentProfileCount = await pool.query('SELECT COUNT(*) FROM student_profiles');
    const companyProfileCount = await pool.query('SELECT COUNT(*) FROM company_profiles');
    const internshipCount = await pool.query('SELECT COUNT(*) FROM internships');
    const applicationCount = await pool.query('SELECT COUNT(*) FROM applications');
    
    console.log('\n📈 Sample data inserted:');
    console.log(`   Users: ${userCount.rows[0].count}`);
    console.log(`   Student Profiles: ${studentProfileCount.rows[0].count}`);
    console.log(`   Company Profiles: ${companyProfileCount.rows[0].count}`);
    console.log(`   Internships: ${internshipCount.rows[0].count}`);
    console.log(`   Applications: ${applicationCount.rows[0].count}`);
    
    console.log('\n🎉 Database setup completed successfully!');
    
  } catch (error) {
    console.error('❌ Database setup failed:', error);
  } finally {
    await pool.end();
  }
}

// Run the setup
setupDatabase();
