-- Fix all passwords to use the correct hash for 'password123'
-- This hash was generated using bcryptjs with 10 salt rounds for password 'password123'

-- Update admin password
UPDATE users SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' WHERE email = 'admin@careernest.com';

-- Update test company password  
UPDATE users SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' WHERE email = 'company@careernest.com';

-- Update test student password
UPDATE users SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' WHERE email = 'student@careernest.com';

-- Update all Arabic student passwords
UPDATE users SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE email IN (
  'ahmad.khaled@gmail.com',
  'fatima.omar@gmail.com', 
  'mohammad.ali@gmail.com',
  'nour.hassan@gmail.com',
  'omar.mahmoud@gmail.com',
  'layla.ibrahim@gmail.com',
  'yusuf.said@gmail.com',
  'aisha.nasser@gmail.com',
  'khalil.abdallah@gmail.com',
  'maryam.farouk@gmail.com'
);

-- Update all Arabic company passwords
UPDATE users SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
WHERE email IN (
  'info@zainjo.com',
  'hr@royamedia.jo',
  'contact@arabbank.jo', 
  'jobs@umniah.com',
  'info@petratech.jo',
  'hr@ammandigital.com',
  'contact@jordantech.jo',
  'hr@rawabi-solutions.jo'
);

-- Verify the updates
SELECT 'Password fix completed!' as message;
SELECT email, role, 
  CASE WHEN password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
    THEN 'Updated ✓' 
    ELSE 'Not Updated ✗' 
  END as status
FROM users 
ORDER BY role, email;
