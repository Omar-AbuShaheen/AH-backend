-- Arabic Sample Data for CareerNest Application
-- Run this after setting up the main database schema

-- Clear existing data (except admin)
DELETE FROM company_messages;
DELETE FROM applications;
DELETE FROM internships;
DELETE FROM student_profiles;
DELETE FROM company_profiles;
DELETE FROM users WHERE role != 'admin';

-- Reset sequences to start from 1
ALTER SEQUENCE users_id_seq RESTART WITH 2;
ALTER SEQUENCE student_profiles_id_seq RESTART WITH 1;
ALTER SEQUENCE company_profiles_id_seq RESTART WITH 1;
ALTER SEQUENCE internships_id_seq RESTART WITH 1;
ALTER SEQUENCE applications_id_seq RESTART WITH 1;
ALTER SEQUENCE company_messages_id_seq RESTART WITH 1;

-- Insert Student Users (Arabic names in English letters)
INSERT INTO users (email, password, role, is_approved) VALUES
('ahmad.khaled@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('fatima.omar@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('mohammad.ali@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('nour.hassan@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('omar.mahmoud@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('layla.ibrahim@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('yusuf.said@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('aisha.nasser@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true);

-- Insert Company Users (Arabic company names in English)
INSERT INTO users (email, password, role, is_approved) VALUES
('info@zainjo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('hr@royamedia.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('contact@arabbank.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('jobs@umniah.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('info@petratech.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('hr@ammandigital.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true);

-- Insert Student Profiles
INSERT INTO student_profiles (user_id, first_name, last_name, university, major, graduation_year, gpa, skills, phone, location, bio) VALUES
(2, 'Ahmad', 'Khaled', 'University of Jordan', 'Computer Science', 2024, 3.8, 'JavaScript, React, Node.js', '+962771234567', 'Amman, Jordan', 'Computer science student passionate about web development'),
(3, 'Fatima', 'Omar', 'Jordan University of Science and Technology', 'Software Engineering', 2024, 3.9, 'Java, Spring, MySQL', '+962791234567', 'Irbid, Jordan', 'Software engineering student interested in backend development'),
(4, 'Mohammad', 'Ali', 'German Jordanian University', 'Information Technology', 2025, 3.7, 'PHP, Laravel, Vue.js', '+962781234567', 'Madaba, Jordan', 'IT student specializing in web applications'),
(5, 'Nour', 'Hassan', 'Yarmouk University', 'Computer Information Systems', 2024, 3.6, 'Python, Django, PostgreSQL', '+962771234568', 'Zarqa, Jordan', 'CIS student focused on database management'),
(6, 'Omar', 'Mahmoud', 'Princess Sumaya University', 'Computer Science', 2025, 3.85, 'C#, .NET, SQL Server', '+962791234568', 'Salt, Jordan', 'Computer science student interested in enterprise software'),
(7, 'Layla', 'Ibrahim', 'Applied Science University', 'Information Technology', 2024, 3.75, 'HTML, CSS, JavaScript, React', '+962781234568', 'Aqaba, Jordan', 'IT student passionate about frontend development'),
(8, 'Yusuf', 'Said', 'Hashemite University', 'Software Engineering', 2025, 3.65, 'Java, Android, Kotlin', '+962771234569', 'Karak, Jordan', 'Software engineering student focused on mobile development'),
(9, 'Aisha', 'Nasser', 'Middle East University', 'Computer Science', 2024, 3.8, 'Python, Machine Learning, Data Science', '+962791234569', 'Jerash, Jordan', 'Computer science student interested in AI and data analysis');

-- Insert Company Profiles
INSERT INTO company_profiles (user_id, company_name, contact_person, industry, location, website, description, phone) VALUES
(10, 'Zain Jordan', 'Rami Al-Zahra', 'Telecommunications', 'Amman, Jordan', 'https://jo.zain.com', 'Leading telecommunications company in Jordan', '+96265000000'),
(11, 'Roya Media', 'Sara Al-Khatib', 'Media and Broadcasting', 'Amman, Jordan', 'https://roya.tv', 'Premier media company in Jordan', '+96264000000'),
(12, 'Arab Bank', 'Mahmoud Al-Rashid', 'Banking and Finance', 'Amman, Jordan', 'https://arabbank.jo', 'Leading bank in the Middle East', '+96266000000'),
(13, 'Umniah', 'Lina Al-Masri', 'Telecommunications', 'Amman, Jordan', 'https://umniah.com', 'Innovative telecom services provider', '+96263000000'),
(14, 'Petra Technology', 'Fadi Al-Nouri', 'Information Technology', 'Amman, Jordan', 'https://petratech.jo', 'Software development and IT solutions', '+96267000000'),
(15, 'Amman Digital', 'Nadia Al-Qasemi', 'Digital Marketing', 'Amman, Jordan', 'https://ammandigital.com', 'Digital marketing and web development agency', '+96269000000');

-- Insert Internship Opportunities
INSERT INTO internships (company_id, title, description, requirements, location, type, duration, stipend, deadline, is_approved) VALUES
(10, 'Frontend Developer Intern', 'Work on modern web applications using React and JavaScript', 'Knowledge of React, HTML, CSS, JavaScript', 'Amman, Jordan', 'Remote', '3 months', 400.00, '2024-03-15', true),
(11, 'Media Production Intern', 'Assist in video production and content creation', 'Media studies background, video editing skills', 'Amman, Jordan', 'On-site', '4 months', 350.00, '2024-03-20', true),
(12, 'Software Developer Intern', 'Develop banking applications and financial software', 'Java or C# knowledge, understanding of databases', 'Amman, Jordan', 'Hybrid', '6 months', 500.00, '2024-03-25', true),
(13, 'Mobile App Developer Intern', 'Create mobile applications for Android and iOS', 'Mobile development experience, Java or Kotlin', 'Amman, Jordan', 'On-site', '4 months', 450.00, '2024-04-01', true),
(14, 'Full Stack Developer Intern', 'Work on complete web applications from frontend to backend', 'Knowledge of modern web technologies', 'Amman, Jordan', 'Remote', '5 months', 420.00, '2024-04-05', true),
(15, 'Digital Marketing Intern', 'Support social media campaigns and content creation', 'Marketing knowledge, social media skills', 'Amman, Jordan', 'Hybrid', '3 months', 300.00, '2024-04-10', true),
(10, 'Backend Developer Intern', 'Develop server-side applications and APIs', 'Node.js or Python experience, database knowledge', 'Amman, Jordan', 'Remote', '4 months', 430.00, '2024-04-15', true),
(11, 'Content Creator Intern', 'Create engaging content for digital platforms', 'Creative writing, content creation skills', 'Amman, Jordan', 'On-site', '3 months', 320.00, '2024-04-20', true);

-- Insert Sample Applications
INSERT INTO applications (student_id, internship_id, cover_letter, status) VALUES
(2, 1, 'I am very interested in the Frontend Developer position. My React skills and passion for web development make me a great candidate.', 'Applied'),
(3, 3, 'The Software Developer internship aligns with my software engineering background and career goals.', 'Under Review'),
(4, 5, 'I am excited about the Full Stack Developer role and believe my web development skills would be valuable.', 'Applied'),
(5, 7, 'The Backend Developer position matches my experience with databases and server-side development.', 'Under Review'),
(6, 3, 'I am interested in working on banking applications and contributing to financial software development.', 'Applied'),
(7, 1, 'My frontend development skills and UI/UX knowledge make me suitable for this position.', 'Applied'),
(8, 4, 'I am passionate about mobile development and would love to create innovative mobile applications.', 'Under Review'),
(9, 6, 'The Digital Marketing internship would help me combine my technical skills with marketing knowledge.', 'Applied');

-- Insert Sample Messages
INSERT INTO company_messages (application_id, company_id, student_id, message_type, message, contact_email) VALUES
(2, 12, 3, 'hired', 'Congratulations! We are pleased to offer you the Software Developer internship at Arab Bank. Please contact us to discuss next steps.', 'mahmoud.rashid@arabbank.jo'),
(8, 15, 9, 'rejected', 'Thank you for your application. While your qualifications are impressive, we have selected another candidate for this position.', 'nadia.qasemi@ammandigital.com');
