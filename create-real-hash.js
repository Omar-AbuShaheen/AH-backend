const bcrypt = require('bcryptjs');

async function createCorrectHash() {
    try {
        console.log('Creating hash for password: password123');
        
        // Use exact same method as auth.js
        const password = 'password123';
        const hash = await bcrypt.hash(password, 10);
        
        console.log('\n=== CORRECT HASH FOR password123 ===');
        console.log(hash);
        console.log('=====================================\n');
        
        // Test verification
        const isValid = await bcrypt.compare('password123', hash);
        console.log('Hash verification test:', isValid ? 'PASS ✓' : 'FAIL ✗');
        
        // Test the hashes in your database files
        const oldHash1 = '$2b$10$rQZ8K9mN2pL3sX7vB6cE1aF4gH5iJ6kL7mN8oP9qR0sT1uV2wX3yZ4';
        const oldHash2 = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';
        
        const test1 = await bcrypt.compare('password123', oldHash1);
        const test2 = await bcrypt.compare('password123', oldHash2);
        
        console.log('\nTesting existing hashes:');
        console.log('Old hash 1 ($2b...):', test1 ? 'VALID ✓' : 'INVALID ✗');
        console.log('Old hash 2 ($2a...):', test2 ? 'VALID ✓' : 'INVALID ✗');
        
        // Generate SQL update statement
        console.log('\n=== SQL TO FIX ALL PASSWORDS ===');
        console.log(`UPDATE users SET password_hash = '${hash}';`);
        console.log('================================\n');
        
    } catch (error) {
        console.error('Error:', error);
    }
}

createCorrectHash();
