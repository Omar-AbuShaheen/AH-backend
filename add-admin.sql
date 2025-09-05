-- Add Admin User with Correct Password Hash
-- Password: password123
-- Hash: $2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y

-- Insert admin user (or update if exists)
INSERT INTO users (email, password_hash, role) 
VALUES ('admin@careernest.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'admin')
ON CONFLICT (email) 
DO UPDATE SET 
  password_hash = '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y',
  role = 'admin',
  updated_at = CURRENT_TIMESTAMP;

-- Verify admin was added/updated
SELECT 'Admin user added/updated successfully!' as message;
SELECT id, email, role, created_at, updated_at 
FROM users 
WHERE email = 'admin@careernest.com';
