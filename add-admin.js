const db = require('./config/db');
const bcrypt = require('bcryptjs');

async function addAdmin() {
  try {
    console.log('🔧 Adding new admin user...');
    
    // Admin details - CHANGE THESE AS NEEDED
    const adminData = {
      name: 'New Admin User',
      email: 'newadmin@careernest.com',
      password: 'newpassword123'
    };
    
    // Check if admin already exists
    const existingAdmin = await db.query('SELECT * FROM admins WHERE email = $1', [adminData.email]);
    
    if (existingAdmin.rows.length > 0) {
      console.log('❌ Admin with this email already exists!');
      return;
    }
    
    // Hash the password
    const passwordHash = await bcrypt.hash(adminData.password, 10);
    
    // Insert new admin
    const result = await db.query(
      'INSERT INTO admins (name, email, password_hash, created_at) VALUES ($1, $2, $3, $4) RETURNING id, name, email, created_at',
      [adminData.name, adminData.email, passwordHash, new Date()]
    );
    
    const newAdmin = result.rows[0];
    console.log('✅ New admin created successfully!');
    console.log('📋 Admin details:');
    console.log(`   ID: ${newAdmin.id}`);
    console.log(`   Name: ${newAdmin.name}`);
    console.log(`   Email: ${newAdmin.email}`);
    console.log(`   Password: ${adminData.password}`);
    console.log(`   Created: ${newAdmin.created_at}`);
    
  } catch (error) {
    console.error('❌ Error creating admin:', error);
  } finally {
    process.exit(0);
  }
}

addAdmin();
