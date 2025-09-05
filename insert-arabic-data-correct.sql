-- Arabic Sample Data for CareerNest (Matching setup-clean-database.sql schema)
-- Run this AFTER running setup-clean-database.sql

-- Clear existing data (keep admin, company, student test accounts)
DELETE FROM applications WHERE id > 1;
DELETE FROM internships WHERE id > 1;
DELETE FROM student_profiles WHERE id > 1;
DELETE FROM company_profiles WHERE id > 1;
DELETE FROM users WHERE id > 3;

-- Reset sequences
ALTER SEQUENCE users_id_seq RESTART WITH 4;
ALTER SEQUENCE student_profiles_id_seq RESTART WITH 2;
ALTER SEQUENCE company_profiles_id_seq RESTART WITH 2;
ALTER SEQUENCE internships_id_seq RESTART WITH 2;
ALTER SEQUENCE applications_id_seq RESTART WITH 2;

-- Insert Student Users (Arabic names in English letters)
INSERT INTO users (email, password_hash, role) VALUES
('ahmad.khaled@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('fatima.omar@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('mohammad.ali@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('nour.hassan@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('omar.mahmoud@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('layla.ibrahim@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('yusuf.said@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('aisha.nasser@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('khalil.abdallah@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student'),
('maryam.farouk@gmail.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'student');

-- Insert Company Users (Arabic company names in English)
INSERT INTO users (email, password_hash, role) VALUES
('info@zainjo.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('hr@royamedia.jo', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('contact@arabbank.jo', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('jobs@umniah.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('info@petratech.jo', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('hr@ammandigital.com', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('contact@jordantech.jo', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company'),
('hr@rawabi-solutions.jo', '$2a$10$xxWhBuJUIlcVCxP9PUANQeIZqrsEwP9rEJt.yC1XEZ9yQtt0Wg71y', 'company');

-- Insert Student Profiles
INSERT INTO student_profiles (user_id, first_name, last_name, university, major, graduation_year, gpa, education, skills, experience, phone, location, bio, resume_url) VALUES
(4, 'Ahmad', 'Khaled', 'University of Jordan', 'Computer Science', 2024, 3.80, 'Bachelor in Computer Science from University of Jordan', 'JavaScript, React, Node.js, Python, SQL', 'Internship at local tech startup', '+962-77-1234567', 'Amman, Jordan', 'Passionate computer science student interested in web development and software engineering', 'https://resume.ahmad-khaled.com'),
(5, 'Fatima', 'Omar', 'Jordan University of Science and Technology', 'Software Engineering', 2024, 3.90, 'Bachelor in Software Engineering from JUST', 'Java, Spring Boot, Angular, MySQL, Git', 'Part-time developer at software company', '+962-79-2345678', 'Irbid, Jordan', 'Software engineering student with focus on enterprise applications and backend development', 'https://resume.fatima-omar.com'),
(6, 'Mohammad', 'Ali', 'German Jordanian University', 'Information Technology', 2025, 3.70, 'Bachelor in Information Technology from GJU', 'PHP, Laravel, Vue.js, PostgreSQL, Docker', 'Freelance web developer for 1 year', '+962-78-3456789', 'Madaba, Jordan', 'IT student specializing in full-stack web development and database management', 'https://resume.mohammad-ali.com'),
(7, 'Nour', 'Hassan', 'Yarmouk University', 'Computer Information Systems', 2024, 3.85, 'Bachelor in CIS from Yarmouk University', 'C#, .NET, ASP.NET, SQL Server, Azure', 'Intern at government IT department', '+962-77-4567890', 'Zarqa, Jordan', 'CIS student interested in enterprise software development and cloud computing', 'https://resume.nour-hassan.com'),
(8, 'Omar', 'Mahmoud', 'Al-Zaytoonah University', 'Computer Science', 2025, 3.75, 'Bachelor in Computer Science from Al-Zaytoonah', 'Python, Django, React, MongoDB, AWS', 'Teaching assistant in university', '+962-79-5678901', 'Salt, Jordan', 'Computer science student with passion for machine learning and data science', 'https://resume.omar-mahmoud.com'),
(9, 'Layla', 'Ibrahim', 'Princess Sumaya University', 'Computer Graphics', 2024, 3.95, 'Bachelor in Computer Graphics from PSUT', 'Unity, C#, Blender, Maya, JavaScript', 'Game development intern at local studio', '+962-78-6789012', 'Amman, Jordan', 'Computer graphics student focused on game development and 3D modeling', 'https://resume.layla-ibrahim.com'),
(10, 'Yusuf', 'Said', 'Applied Science Private University', 'Information Technology', 2025, 3.65, 'Bachelor in IT from Applied Science University', 'HTML, CSS, JavaScript, Bootstrap, Figma', 'UI/UX design intern at agency', '+962-77-7890123', 'Aqaba, Jordan', 'IT student specializing in user interface design and user experience', 'https://resume.yusuf-said.com'),
(11, 'Aisha', 'Nasser', 'Hashemite University', 'Software Engineering', 2024, 3.80, 'Bachelor in Software Engineering from Hashemite University', 'Java, Spring, Android, Kotlin, Firebase', 'Mobile app development intern', '+962-79-8901234', 'Karak, Jordan', 'Software engineering student focused on mobile application development', 'https://resume.aisha-nasser.com'),
(12, 'Khalil', 'Abdallah', 'Middle East University', 'Computer Science', 2025, 3.60, 'Bachelor in Computer Science from MEU', 'Python, Flask, React, PostgreSQL, Linux', 'Backend developer intern', '+962-78-9012345', 'Mafraq, Jordan', 'Computer science student interested in backend development and system administration', 'https://resume.khalil-abdallah.com'),
(13, 'Maryam', 'Farouk', 'Philadelphia University', 'Information Technology', 2024, 3.88, 'Bachelor in IT from Philadelphia University', 'HTML, CSS, JavaScript, React, Node.js', 'Web development intern', '+962-77-0123456', 'Jerash, Jordan', 'IT student passionate about modern web technologies and responsive design', 'https://resume.maryam-farouk.com');

-- Insert Company Profiles
INSERT INTO company_profiles (user_id, company_name, contact_person, industry, location, website, description, phone, contact_email, is_approved) VALUES
(14, 'Zain Jordan', 'Rami Al-Zahra', 'Telecommunications & Technology', 'Amman, Jordan', 'https://jo.zain.com', 'Leading telecommunications and technology solutions provider in Jordan', '+962-6-5555000', 'rami.alzahra@zainjo.com', true),
(15, 'Roya Media Group', 'Sara Al-Khatib', 'Media & Broadcasting', 'Amman, Jordan', 'https://roya.tv', 'Premier media and broadcasting company producing quality content', '+962-6-4444000', 'sara.khatib@royamedia.jo', true),
(16, 'Arab Bank Technology', 'Mahmoud Al-Rashid', 'Banking & Financial Technology', 'Amman, Jordan', 'https://arabbank.jo', 'Technology division of Arab Bank developing fintech solutions', '+962-6-6666000', 'mahmoud.rashid@arabbank.jo', true),
(17, 'Umniah Digital', 'Lina Al-Masri', 'Telecommunications & Digital Services', 'Amman, Jordan', 'https://umniah.com', 'Innovative telecommunications company providing digital services', '+962-6-3333000', 'lina.masri@umniah.com', true),
(18, 'Petra Technology Solutions', 'Fadi Al-Nouri', 'Software Development & IT Consulting', 'Amman, Jordan', 'https://petratech.jo', 'Software development company specializing in enterprise solutions', '+962-6-7777000', 'fadi.nouri@petratech.jo', true),
(19, 'Amman Digital Agency', 'Nadia Al-Qasemi', 'Digital Marketing & Web Development', 'Amman, Jordan', 'https://ammandigital.com', 'Full-service digital agency offering comprehensive digital solutions', '+962-6-9999000', 'nadia.qasemi@ammandigital.com', true),
(20, 'Jordan Tech Hub', 'Tareq Al-Saeed', 'Software Development & Innovation', 'Amman, Jordan', 'https://jordantech.jo', 'Technology hub fostering innovation and software development', '+962-6-8888000', 'tareq.saeed@jordantech.jo', true),
(21, 'Rawabi Solutions', 'Dina Al-Khouri', 'IT Solutions & Consulting', 'Irbid, Jordan', 'https://rawabi-solutions.jo', 'Comprehensive IT solutions and consulting services provider', '+962-2-7272000', 'dina.khouri@rawabi-solutions.jo', true);

-- Insert Internship Opportunities
INSERT INTO internships (company_id, title, description, requirements, responsibilities, duration, location, type, salary, stipend, deadline, is_approved) VALUES
(14, 'Frontend Developer Intern', 'Join our development team to work on modern web applications using React and TypeScript for telecom solutions.', 'Computer Science or related field, Knowledge of React, HTML, CSS, JavaScript, Experience with responsive design', 'Develop user interfaces for telecom applications, Write clean and maintainable code, Collaborate with design and backend teams, Participate in code reviews and testing', '3 months', 'Amman, Jordan', 'Remote', '', '$400/month', '2024-03-15', true),
(15, 'Media Production Intern', 'Work with our production team on creating engaging content for television and digital platforms in Arabic and English.', 'Media Studies or Communications major, Basic video editing skills, Creative mindset, Bilingual (Arabic/English)', 'Assist in video production and editing, Create promotional content, Support live broadcasting, Research and develop content ideas', '4 months', 'Amman, Jordan', 'On-site', '', '$350/month', '2024-03-20', true),
(16, 'Fintech Developer Intern', 'Develop innovative banking solutions and payment systems using modern technologies in a secure environment.', 'Software Engineering background, Java or C# knowledge, Understanding of financial systems, Database experience', 'Develop banking applications and payment systems, Implement security features, Test financial transactions, Document technical specifications', '6 months', 'Amman, Jordan', 'Hybrid', '', '$500/month', '2024-03-25', true),
(17, 'Mobile App Developer Intern', 'Create mobile applications for iOS and Android platforms using React Native for telecom services.', 'Mobile development experience, React Native knowledge, JavaScript proficiency, UI/UX understanding', 'Develop mobile applications for telecom services, Integrate APIs and backend services, Optimize app performance, Conduct user testing and debugging', '4 months', 'Amman, Jordan', 'On-site', '', '$450/month', '2024-04-01', true),
(18, 'Full Stack Developer Intern', 'Work on end-to-end web applications using modern JavaScript frameworks and databases for enterprise clients.', 'Web development skills, Node.js and React experience, Database knowledge, Version control (Git)', 'Build complete web applications, Design and implement databases, Create RESTful APIs, Deploy and maintain applications', '5 months', 'Amman, Jordan', 'Remote', '', '$420/month', '2024-04-05', true),
(19, 'Digital Marketing Intern', 'Support digital marketing campaigns and social media management for various client projects across Jordan.', 'Marketing or related field, Social media knowledge, Content creation skills, Arabic and English proficiency', 'Manage social media accounts, Create engaging marketing content, Analyze campaign performance, Support SEO and SEM activities', '3 months', 'Amman, Jordan', 'Hybrid', '', '$300/month', '2024-04-10', true),
(14, 'Backend Developer Intern', 'Work on server-side applications and API development using Node.js and databases for telecom infrastructure.', 'Backend development knowledge, Node.js experience, Database management skills, RESTful API design', 'Develop and maintain RESTful APIs, Optimize database queries and performance, Implement authentication and security systems, Monitor application performance', '4 months', 'Amman, Jordan', 'Remote', '', '$430/month', '2024-04-15', true),
(15, 'Content Creator Intern', 'Create engaging content for social media and digital platforms in Arabic and English for media campaigns.', 'Content creation skills, Bilingual (Arabic/English), Creative writing abilities, Social media knowledge', 'Write engaging social media content, Create video scripts and storylines, Develop marketing materials, Manage content calendar and publishing', '3 months', 'Amman, Jordan', 'On-site', '', '$320/month', '2024-04-20', true),
(16, 'Data Analyst Intern', 'Analyze financial data and create reports to support business decision making in banking sector.', 'Data analysis skills, SQL knowledge, Excel proficiency, Statistical understanding, Python or R knowledge', 'Analyze financial data and trends, Create automated reports and dashboards, Develop data visualizations, Support business intelligence initiatives', '5 months', 'Amman, Jordan', 'Hybrid', '', '$400/month', '2024-04-25', true),
(17, 'Network Engineer Intern', 'Support network infrastructure and telecommunications systems maintenance and optimization.', 'Network engineering background, CCNA certification preferred, Hardware troubleshooting skills, Network protocols knowledge', 'Monitor network performance and reliability, Troubleshoot connectivity issues, Support infrastructure upgrades, Document network configurations and procedures', '6 months', 'Amman, Jordan', 'On-site', '', '$480/month', '2024-05-01', true),
(20, 'Software Engineer Intern', 'Develop innovative software solutions and applications using modern programming languages and frameworks.', 'Computer Science degree, Programming skills in Java/Python/C#, Problem-solving abilities, Team collaboration skills', 'Design and develop software applications, Write clean and efficient code, Participate in software testing, Collaborate with development teams', '4 months', 'Amman, Jordan', 'Hybrid', '', '$450/month', '2024-05-05', true),
(21, 'IT Support Intern', 'Provide technical support and IT solutions to clients while gaining hands-on experience in IT consulting.', 'IT background, Technical troubleshooting skills, Customer service abilities, Network and hardware knowledge', 'Provide technical support to clients, Install and configure software/hardware, Troubleshoot IT issues, Document solutions and procedures', '3 months', 'Irbid, Jordan', 'On-site', '', '$350/month', '2024-05-10', true);

-- Insert Sample Applications
INSERT INTO applications (student_id, internship_id, status, cover_letter) VALUES
(4, 2, 'Applied', 'I am very interested in the Frontend Developer position at Zain Jordan. My experience with React and passion for creating user-friendly interfaces make me a great fit for developing telecom applications.'),
(5, 4, 'Shortlisted', 'The Fintech Developer internship at Arab Bank Technology aligns perfectly with my software engineering background and interest in financial technology. I am eager to contribute to innovative banking solutions.'),
(6, 6, 'Applied', 'As an IT student with PHP and full-stack experience, I am excited about the Full Stack Developer internship at Petra Technology. I look forward to working on enterprise solutions.'),
(7, 5, 'Shortlisted', 'I am passionate about mobile development and would love to join Umniah Digital as a Mobile App Developer intern. My React Native skills would be valuable for telecom mobile applications.'),
(8, 10, 'Applied', 'The Data Analyst internship at Arab Bank Technology is perfect for my skills in Python and data analysis. I am excited to work with financial data and contribute to business intelligence.'),
(9, 3, 'Applied', 'With my background in computer graphics and creative skills, I believe I would be an excellent fit for the Media Production internship at Roya Media Group.'),
(10, 7, 'Shortlisted', 'I am very interested in the Digital Marketing internship at Amman Digital Agency. My creativity and understanding of social media make me a strong candidate for this role.'),
(11, 5, 'Applied', 'As a software engineering student with mobile development experience, I am excited about the opportunity to work on mobile applications at Umniah Digital.'),
(12, 8, 'Shortlisted', 'The Backend Developer internship at Zain Jordan is perfect for my skills in Node.js and database management. I am eager to work on telecom server-side applications.'),
(13, 6, 'Applied', 'I am passionate about full-stack development and would love to join Petra Technology Solutions. My experience with modern JavaScript frameworks makes me a great fit.');

-- Display completion message
SELECT 'Arabic sample data inserted successfully!' as message;
SELECT 'Total users: ' || COUNT(*) || ' (including admin)' as user_count FROM users;
SELECT 'Total students: ' || COUNT(*) as student_count FROM student_profiles;
SELECT 'Total companies: ' || COUNT(*) as company_count FROM company_profiles;
SELECT 'Total internships: ' || COUNT(*) as internship_count FROM internships;
SELECT 'Total applications: ' || COUNT(*) as application_count FROM applications;
