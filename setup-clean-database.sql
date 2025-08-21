-- Clean Database Setup Script
-- This script will drop all existing tables and create a clean, unified structure

-- Drop all existing tables (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS applications CASCADE;
DROP TABLE IF EXISTS internships CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS admins CASCADE;
DROP TABLE IF EXISTS company_users CASCADE;

-- Create the unified users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('student', 'company', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create student_profiles table
CREATE TABLE student_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    university VARCHAR(255),
    major VARCHAR(255),
    graduation_year INTEGER,
    skills TEXT,
    experience TEXT,
    phone VARCHAR(20),
    location VARCHAR(255),
    bio TEXT,
    resume_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create company_profiles table
CREATE TABLE company_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    industry VARCHAR(255),
    location VARCHAR(255),
    website VARCHAR(500),
    description TEXT,
    phone VARCHAR(20),
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create internships table
CREATE TABLE internships (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    duration VARCHAR(100),
    location VARCHAR(255),
    salary VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create applications table
CREATE TABLE applications (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    internship_id INTEGER NOT NULL REFERENCES internships(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'withdrawn')),
    cover_letter TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, internship_id)
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_student_profiles_user_id ON student_profiles(user_id);
CREATE INDEX idx_company_profiles_user_id ON company_profiles(user_id);
CREATE INDEX idx_internships_company_id ON internships(company_id);
CREATE INDEX idx_applications_student_id ON applications(student_id);
CREATE INDEX idx_applications_internship_id ON applications(internship_id);
CREATE INDEX idx_applications_status ON applications(status);

-- Insert initial admin user
INSERT INTO users (email, password_hash, role) VALUES 
('admin@careernest.com', '$2b$10$rQZ8K9mN2pL3sX7vB6cE1aF4gH5iJ6kL7mN8oP9qR0sT1uV2wX3yZ4', 'admin');

-- Insert test company user
INSERT INTO users (email, password_hash, role) VALUES 
('company@careernest.com', '$2b$10$rQZ8K9mN2pL3sX7vB6cE1aF4gH5iJ6kL7mN8oP9qR0sT1uV2wX3yZ4', 'company');

-- Insert test student user
INSERT INTO users (email, password_hash, role) VALUES 
('student@careernest.com', '$2b$10$rQZ8K9mN2pL3sX7vB6cE1aF4gH5iJ6kL7mN8oP9qR0sT1uV2wX3yZ4', 'student');

-- Insert corresponding profiles
INSERT INTO company_profiles (user_id, company_name, contact_person, industry, location, description, is_approved) VALUES 
(2, 'Test Company', 'John Doe', 'Technology', 'New York', 'A test company for development purposes', true);

INSERT INTO student_profiles (user_id, first_name, last_name, university, major, graduation_year, skills, experience) VALUES 
(3, 'Test', 'Student', 'Test University', 'Computer Science', 2025, 'JavaScript, React, Node.js', '2 years of web development');

-- Insert sample internship
INSERT INTO internships (company_id, title, description, requirements, duration, location, salary, is_approved) VALUES 
(2, 'Frontend Developer Intern', 'Join our team to build amazing web applications', 'React, JavaScript, HTML, CSS', '3 months', 'New York', '$2000/month', true);

-- Insert sample application
INSERT INTO applications (student_id, internship_id, status, cover_letter) VALUES 
(3, 1, 'pending', 'I am excited to apply for this position...');

-- Display the created structure
SELECT 'Database setup completed successfully!' as message;
SELECT 'Tables created:' as info;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;
