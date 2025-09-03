-- Add company messages table and update applications for messaging system

-- Create company_messages table for hired/rejected messages
CREATE TABLE IF NOT EXISTS company_messages (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    company_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    student_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_type VARCHAR(20) NOT NULL CHECK (message_type IN ('hired', 'rejected')),
    message TEXT NOT NULL,
    contact_email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_company_messages_application_id ON company_messages(application_id);
CREATE INDEX IF NOT EXISTS idx_company_messages_student_id ON company_messages(student_id);
CREATE INDEX IF NOT EXISTS idx_company_messages_company_id ON company_messages(company_id);
CREATE INDEX IF NOT EXISTS idx_company_messages_type ON company_messages(message_type);

-- Add additional profile fields to student_profiles if they don't exist
ALTER TABLE student_profiles 
ADD COLUMN IF NOT EXISTS date_of_birth DATE,
ADD COLUMN IF NOT EXISTS linkedin_url VARCHAR(500),
ADD COLUMN IF NOT EXISTS github_url VARCHAR(500),
ADD COLUMN IF NOT EXISTS portfolio_url VARCHAR(500);

SELECT 'Database schema updated successfully for messaging system!' as message;
