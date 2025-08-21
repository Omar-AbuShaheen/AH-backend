const fs = require('fs');
const path = require('path');
const db = require('./config/db');

async function updateSchema() {
  try {
    console.log('🔄 Updating database schema...');
    
    // Read the SQL file
    const sqlPath = path.join(__dirname, 'update-database-schema.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    // Execute the SQL
    await db.query(sql);
    
    console.log('✅ Database schema updated successfully!');
    
    // Test the connection
    const result = await db.query('SELECT NOW() as current_time');
    console.log('📊 Database connection test:', result.rows[0]);
    
  } catch (error) {
    console.error('❌ Error updating schema:', error);
  } finally {
    process.exit(0);
  }
}

updateSchema();
