-- Insert Arabic Data for CareerNest (Arabic names in English letters)
-- Clear existing data first
DELETE FROM company_messages;
DELETE FROM applications;
DELETE FROM internships;
DELETE FROM student_profiles;
DELETE FROM company_profiles;
DELETE FROM users WHERE role != 'admin';

-- Reset sequences
ALTER SEQUENCE users_id_seq RESTART WITH 2;
ALTER SEQUENCE student_profiles_id_seq RESTART WITH 1;
ALTER SEQUENCE company_profiles_id_seq RESTART WITH 1;
ALTER SEQUENCE internships_id_seq RESTART WITH 1;
ALTER SEQUENCE applications_id_seq RESTART WITH 1;
ALTER SEQUENCE company_messages_id_seq RESTART WITH 1;

-- Insert Students (Arabic names in English)
INSERT INTO users (email, password, role, is_approved) VALUES
('ahmed.khaled@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('fatima.omar@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('mohammed.ali@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('nour.hassan@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('omar.mahmoud@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('layla.ibrahim@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('yusuf.said@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('aisha.nasser@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('khalil.abdallah@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true),
('maryam.farouk@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', true);

-- Insert Companies (Arabic company names in English)
INSERT INTO users (email, password, role, is_approved) VALUES
('info@zaintech.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('hr@roya-media.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('careers@arabbank.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('jobs@umniah.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('contact@jordantech.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('hr@petra-solutions.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('info@rawabi-tech.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true),
('careers@amman-digital.jo', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'company', true);

-- Insert Student Profiles
INSERT INTO student_profiles (user_id, first_name, last_name, university, major, graduation_year, gpa, education, skills, experience, phone, location, bio, date_of_birth, linkedin_url, github_url, portfolio_url) VALUES
(2, 'Ahmed', 'Khaled', 'University of Jordan', 'Computer Science', 2024, 3.75, 'Bachelor in Computer Science from University of Jordan', 'JavaScript, React, Node.js, Python, SQL', 'Internship at local software company', '+962-77-1234567', 'Amman, Jordan', 'Passionate computer science student interested in web development and AI.', '2001-03-15', 'https://linkedin.com/in/ahmed-khaled', 'https://github.com/ahmedkhaled', 'https://ahmed-portfolio.com'),
(3, 'Fatima', 'Omar', 'Jordan University of Science and Technology', 'Software Engineering', 2025, 3.90, 'Bachelor in Software Engineering from JUST', 'Java, Spring Boot, Angular, MySQL, Git', 'Part-time developer at startup', '+962-79-2345678', 'Irbid, Jordan', 'Software engineering student with focus on enterprise applications.', '2002-07-22', 'https://linkedin.com/in/fatima-omar', 'https://github.com/fatimaomar', 'https://fatima-dev.com'),
(4, 'Mohammed', 'Ali', 'German Jordanian University', 'Information Technology', 2024, 3.60, 'Bachelor in Information Technology from GJU', 'PHP, Laravel, Vue.js, PostgreSQL, Docker', 'Freelance web developer', '+962-78-3456789', 'Madaba, Jordan', 'IT student specializing in full-stack web development.', '2001-11-08', 'https://linkedin.com/in/mohammed-ali', 'https://github.com/mohammedali', 'https://mohammed-portfolio.jo'),
(5, 'Nour', 'Hassan', 'Yarmouk University', 'Computer Information Systems', 2025, 3.85, 'Bachelor in CIS from Yarmouk University', 'C#, .NET, ASP.NET, SQL Server, Azure', 'Intern at government IT department', '+962-77-4567890', 'Zarqa, Jordan', 'CIS student interested in enterprise software and cloud computing.', '2002-01-30', 'https://linkedin.com/in/nour-hassan', 'https://github.com/nourhassan', NULL),
(6, 'Omar', 'Mahmoud', 'Al-Zaytoonah University', 'Computer Science', 2024, 3.70, 'Bachelor in Computer Science from Al-Zaytoonah', 'Python, Django, React, MongoDB, AWS', 'Teaching assistant in university', '+962-79-5678901', 'Salt, Jordan', 'Computer science student with passion for machine learning and data science.', '2001-09-12', 'https://linkedin.com/in/omar-mahmoud', 'https://github.com/omarmahmoud', 'https://omar-data.com'),
(7, 'Layla', 'Ibrahim', 'Princess Sumaya University', 'Computer Graphics', 2025, 3.95, 'Bachelor in Computer Graphics from PSUT', 'Unity, C#, Blender, Maya, JavaScript', 'Game development intern', '+962-78-6789012', 'Amman, Jordan', 'Computer graphics student focused on game development and 3D modeling.', '2002-05-18', 'https://linkedin.com/in/layla-ibrahim', 'https://github.com/laylai', 'https://layla-games.com'),
(8, 'Yusuf', 'Said', 'Applied Science Private University', 'Information Technology', 2024, 3.65, 'Bachelor in IT from Applied Science University', 'HTML, CSS, JavaScript, Bootstrap, Figma', 'UI/UX design intern', '+962-77-7890123', 'Aqaba, Jordan', 'IT student specializing in user interface design and user experience.', '2001-12-03', 'https://linkedin.com/in/yusuf-said', 'https://github.com/yusufsaid', 'https://yusuf-design.jo'),
(9, 'Aisha', 'Nasser', 'Hashemite University', 'Software Engineering', 2025, 3.80, 'Bachelor in Software Engineering from Hashemite University', 'Java, Spring, Android, Kotlin, Firebase', 'Mobile app development intern', '+962-79-8901234', 'Karak, Jordan', 'Software engineering student focused on mobile application development.', '2002-04-25', 'https://linkedin.com/in/aisha-nasser', 'https://github.com/aishanasser', NULL),
(10, 'Khalil', 'Abdallah', 'Middle East University', 'Computer Science', 2024, 3.55, 'Bachelor in Computer Science from MEU', 'Python, Flask, React, PostgreSQL, Linux', 'Backend developer intern', '+962-78-9012345', 'Mafraq, Jordan', 'Computer science student interested in backend development and system administration.', '2001-08-14', 'https://linkedin.com/in/khalil-abdallah', 'https://github.com/khalilabdallah', 'https://khalil-backend.com'),
(11, 'Maryam', 'Farouk', 'Philadelphia University', 'Information Technology', 2025, 3.88, 'Bachelor in IT from Philadelphia University', 'HTML, CSS, JavaScript, React, Node.js', 'Web development intern', '+962-77-0123456', 'Jerash, Jordan', 'IT student passionate about modern web technologies and responsive design.', '2002-06-09', 'https://linkedin.com/in/maryam-farouk', 'https://github.com/maryamfarouk', 'https://maryam-web.jo');

-- Insert Company Profiles
INSERT INTO company_profiles (user_id, company_name, contact_person, industry, location, website, description, phone, contact_email) VALUES
(12, 'Zain Technology Solutions', 'Rami Al-Zahra', 'Telecommunications & Technology', 'Amman, Jordan', 'https://zaintech.jo', 'Leading telecommunications and technology solutions provider in Jordan, offering innovative digital services and infrastructure.', '+962-6-5555000', 'rami.alzahra@zaintech.jo'),
(13, 'Roya Media Group', 'Sara Al-Khatib', 'Media & Broadcasting', 'Amman, Jordan', 'https://roya-media.jo', 'Premier media and broadcasting company in Jordan, producing quality content for television, radio, and digital platforms.', '+962-6-4444000', 'sara.khatib@roya-media.jo'),
(14, 'Arab Bank Technology', 'Mahmoud Al-Rashid', 'Banking & Financial Technology', 'Amman, Jordan', 'https://arabbank.jo/tech', 'Technology division of Arab Bank, developing cutting-edge fintech solutions and digital banking services.', '+962-6-6666000', 'mahmoud.rashid@arabbank.jo'),
(15, 'Umniah Digital', 'Lina Al-Masri', 'Telecommunications & Digital Services', 'Amman, Jordan', 'https://umniah.jo', 'Innovative telecommunications company providing mobile, internet, and digital transformation services across Jordan.', '+962-6-3333000', 'lina.masri@umniah.jo'),
(16, 'Jordan Tech Hub', 'Fadi Al-Nouri', 'Software Development', 'Amman, Jordan', 'https://jordantech.jo', 'Software development company specializing in enterprise solutions, mobile apps, and web applications for regional clients.', '+962-6-7777000', 'fadi.nouri@jordantech.jo'),
(17, 'Petra Solutions', 'Dina Al-Khouri', 'IT Consulting & Solutions', 'Amman, Jordan', 'https://petra-solutions.jo', 'IT consulting firm providing enterprise software solutions, system integration, and digital transformation services.', '+962-6-8888000', 'dina.khouri@petra-solutions.jo'),
(18, 'Rawabi Technology', 'Tareq Al-Saeed', 'Software & Web Development', 'Irbid, Jordan', 'https://rawabi-tech.jo', 'Technology company focused on web development, e-commerce solutions, and digital marketing services for businesses.', '+962-2-7272000', 'tareq.saeed@rawabi-tech.jo'),
(19, 'Amman Digital Agency', 'Nadia Al-Qasemi', 'Digital Marketing & Development', 'Amman, Jordan', 'https://amman-digital.jo', 'Full-service digital agency offering web development, mobile apps, digital marketing, and branding services.', '+962-6-9999000', 'nadia.qasemi@amman-digital.jo');

-- Insert Internships
INSERT INTO internships (company_id, title, description, requirements, responsibilities, location, type, duration, stipend, deadline, is_approved, posted_date) VALUES
(12, 'Frontend Developer Intern', 'Join our development team to work on modern web applications using React and TypeScript.', 'Computer Science or related field, Knowledge of React, HTML, CSS, JavaScript', 'Develop user interfaces, Write clean and maintainable code, Collaborate with design team, Participate in code reviews', 'Amman, Jordan', 'Remote', '3 months', 400.00, '2024-02-15', true, '2024-01-01'),
(13, 'Media Production Intern', 'Work with our production team on creating engaging content for television and digital platforms.', 'Media or Communications major, Basic video editing skills, Creative mindset', 'Assist in video production, Edit promotional content, Support live broadcasting, Research content ideas', 'Amman, Jordan', 'On-site', '4 months', 350.00, '2024-02-20', true, '2024-01-02'),
(14, 'Fintech Developer Intern', 'Develop innovative banking solutions and payment systems using modern technologies.', 'Software Engineering background, Java or C# knowledge, Understanding of financial systems', 'Develop banking applications, Implement security features, Test financial transactions, Document technical specifications', 'Amman, Jordan', 'Hybrid', '6 months', 500.00, '2024-02-25', true, '2024-01-03'),
(15, 'Mobile App Developer Intern', 'Create mobile applications for iOS and Android platforms using React Native.', 'Mobile development experience, React Native knowledge, JavaScript proficiency', 'Develop mobile applications, Integrate APIs, Optimize app performance, Conduct user testing', 'Amman, Jordan', 'On-site', '4 months', 450.00, '2024-03-01', true, '2024-01-04'),
(16, 'Full Stack Developer Intern', 'Work on end-to-end web applications using modern JavaScript frameworks and databases.', 'Web development skills, Node.js and React experience, Database knowledge', 'Build web applications, Design databases, Create RESTful APIs, Deploy applications', 'Amman, Jordan', 'Remote', '5 months', 400.00, '2024-03-05', true, '2024-01-05'),
(17, 'IT Consultant Intern', 'Assist in providing IT solutions and consulting services to enterprise clients.', 'IT or Business background, Problem-solving skills, Client communication abilities', 'Analyze client requirements, Prepare technical proposals, Support system implementations, Conduct user training', 'Amman, Jordan', 'Hybrid', '3 months', 300.00, '2024-03-10', true, '2024-01-06'),
(18, 'Web Developer Intern', 'Develop responsive websites and e-commerce platforms for various clients.', 'Web development knowledge, PHP and MySQL experience, Understanding of e-commerce', 'Create responsive websites, Develop e-commerce features, Optimize website performance, Maintain existing projects', 'Irbid, Jordan', 'On-site', '4 months', 350.00, '2024-03-15', true, '2024-01-07'),
(19, 'Digital Marketing Intern', 'Support digital marketing campaigns and social media management for client projects.', 'Marketing or related field, Social media knowledge, Content creation skills', 'Manage social media accounts, Create marketing content, Analyze campaign performance, Support SEO activities', 'Amman, Jordan', 'Hybrid', '3 months', 250.00, '2024-03-20', true, '2024-01-08'),
(12, 'Backend Developer Intern', 'Work on server-side applications and API development using Node.js and databases.', 'Backend development knowledge, Node.js experience, Database management skills', 'Develop RESTful APIs, Optimize database queries, Implement authentication systems, Monitor application performance', 'Amman, Jordan', 'Remote', '4 months', 450.00, '2024-03-25', true, '2024-01-09'),
(13, 'Content Creator Intern', 'Create engaging content for social media and digital platforms in Arabic and English.', 'Content creation skills, Bilingual (Arabic/English), Creative writing abilities', 'Write social media content, Create video scripts, Develop marketing materials, Manage content calendar', 'Amman, Jordan', 'On-site', '3 months', 300.00, '2024-03-30', true, '2024-01-10'),
(14, 'Data Analyst Intern', 'Analyze financial data and create reports to support business decision making.', 'Data analysis skills, SQL knowledge, Excel proficiency, Statistical understanding', 'Analyze financial data, Create automated reports, Develop data visualizations, Support business intelligence initiatives', 'Amman, Jordan', 'Hybrid', '5 months', 400.00, '2024-04-05', true, '2024-01-11'),
(15, 'Network Engineer Intern', 'Support network infrastructure and telecommunications systems maintenance.', 'Network engineering background, CCNA certification preferred, Hardware troubleshooting skills', 'Monitor network performance, Troubleshoot connectivity issues, Support infrastructure upgrades, Document network configurations', 'Amman, Jordan', 'On-site', '6 months', 500.00, '2024-04-10', true, '2024-01-12');

-- Insert Sample Applications
INSERT INTO applications (student_id, internship_id, cover_letter, status, applied_date) VALUES
(2, 1, 'I am very interested in the Frontend Developer position at Zain Technology. My experience with React and passion for creating user-friendly interfaces make me a great fit for this role.', 'Applied', '2024-01-15'),
(3, 3, 'The Fintech Developer internship aligns perfectly with my software engineering background and interest in financial technology. I am eager to contribute to innovative banking solutions.', 'Applied', '2024-01-16'),
(4, 7, 'As an IT student with PHP and MySQL experience, I am excited about the Web Developer internship at Rawabi Technology. I look forward to working on e-commerce solutions.', 'Under Review', '2024-01-17'),
(5, 4, 'I am passionate about mobile development and would love to join Umniah Digital as a Mobile App Developer intern. My React Native skills would be valuable to your team.', 'Under Review', '2024-01-18'),
(6, 11, 'The Data Analyst internship at Arab Bank Technology is perfect for my skills in SQL and data analysis. I am excited to work with financial data and business intelligence.', 'Applied', '2024-01-19'),
(7, 2, 'With my background in computer graphics and creative skills, I believe I would be an excellent fit for the Media Production internship at Roya Media Group.', 'Applied', '2024-01-20'),
(8, 8, 'I am very interested in the Digital Marketing internship at Amman Digital Agency. My creativity and understanding of social media make me a strong candidate.', 'Under Review', '2024-01-21'),
(9, 4, 'As a software engineering student with mobile development experience, I am excited about the opportunity to work on mobile applications at Umniah Digital.', 'Applied', '2024-01-22'),
(10, 9, 'The Backend Developer internship at Zain Technology is perfect for my skills in Node.js and database management. I am eager to work on server-side applications.', 'Under Review', '2024-01-23'),
(11, 5, 'I am passionate about full-stack development and would love to join Jordan Tech Hub. My experience with modern JavaScript frameworks makes me a great fit.', 'Applied', '2024-01-24');

-- Insert Sample Company Messages
INSERT INTO company_messages (application_id, company_id, student_id, message_type, message, contact_email, created_at) VALUES
(3, 18, 4, 'hired', 'Congratulations! We are pleased to offer you the Web Developer internship position at Rawabi Technology. Your skills in PHP and web development impressed our team. Please contact us to discuss the next steps.', 'tareq.saeed@rawabi-tech.jo', '2024-01-25 10:00:00'),
(5, 14, 6, 'rejected', 'Thank you for your interest in the Data Analyst internship at Arab Bank Technology. While your qualifications are impressive, we have decided to move forward with another candidate. We encourage you to apply for future opportunities.', 'mahmoud.rashid@arabbank.jo', '2024-01-26 14:30:00');
