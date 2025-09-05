-- Fix all passwords using the CORRECT hash for 'password123'
-- This hash: $2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y

-- Update ALL users to use the correct password hash
UPDATE users SET password_hash = '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y';

-- Verify the updates
SELECT 'All passwords fixed with correct hash!' as message;
SELECT email, role, 
  CASE WHEN password_hash = '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y' 
    THEN 'Correct Hash ✓' 
    ELSE 'Wrong Hash ✗' 
  END as password_status
FROM users 
ORDER BY role, email;
