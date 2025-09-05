const bcrypt = require('bcryptjs');

async function generatePasswordHash() {
  try {
    const password = 'password123';
    const hash = await bcrypt.hash(password, 10);
    console.log('Password:', password);
    console.log('Hash:', hash);
    
    // Test the hash
    const isValid = await bcrypt.compare(password, hash);
    console.log('Hash verification:', isValid);
    
    // Also test against the current hash in database
    const currentHash = '$2b$10$rQZ8K9mN2pL3sX7vB6cE1aF4gH5iJ6kL7mN8oP9qR0sT1uV2wX3yZ4';
    const isCurrentValid = await bcrypt.compare(password, currentHash);
    console.log('Current database hash valid:', isCurrentValid);
    
  } catch (error) {
    console.error('Error:', error);
  }
}

generatePasswordHash();
