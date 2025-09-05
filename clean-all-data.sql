-- Clean All Data from CareerNest Database
-- This will delete all data but keep table structure

-- Delete all data (order matters due to foreign keys)
DELETE FROM company_messages;
DELETE FROM applications;
DELETE FROM internships;
DELETE FROM student_profiles;
DELETE FROM company_profiles;
DELETE FROM users;

-- Reset all sequences to start from 1
ALTER SEQUENCE users_id_seq RESTART WITH 1;
ALTER SEQUENCE student_profiles_id_seq RESTART WITH 1;
ALTER SEQUENCE company_profiles_id_seq RESTART WITH 1;
ALTER SEQUENCE internships_id_seq RESTART WITH 1;
ALTER SEQUENCE applications_id_seq RESTART WITH 1;
ALTER SEQUENCE company_messages_id_seq RESTART WITH 1;

-- Verify everything is clean
SELECT 'All data deleted successfully!' as message;
SELECT 'Users: ' || COUNT(*) as count FROM users;
SELECT 'Student Profiles: ' || COUNT(*) as count FROM student_profiles;
SELECT 'Company Profiles: ' || COUNT(*) as count FROM company_profiles;
SELECT 'Internships: ' || COUNT(*) as count FROM internships;
SELECT 'Applications: ' || COUNT(*) as count FROM applications;
SELECT 'Company Messages: ' || COUNT(*) as count FROM company_messages;
