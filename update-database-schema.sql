-- Add missing columns to internships table
ALTER TABLE internships ADD COLUMN IF NOT EXISTS type VARCHAR(50) DEFAULT 'Full-time';
ALTER TABLE internships ADD COLUMN IF NOT EXISTS stipend VARCHAR(100);
ALTER TABLE internships ADD COLUMN IF NOT EXISTS deadline DATE;
ALTER TABLE internships ADD COLUMN IF NOT EXISTS is_approved BOOLEAN DEFAULT false;
ALTER TABLE internships ADD COLUMN IF NOT EXISTS responsibilities TEXT;

-- Add missing columns to applications table
ALTER TABLE applications ADD COLUMN IF NOT EXISTS applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE applications DROP CONSTRAINT IF EXISTS applications_status_check;
ALTER TABLE applications ADD CONSTRAINT applications_status_check 
  CHECK (status IN ('Applied', 'Shortlisted', 'Hired', 'Rejected', 'Withdrawn'));

-- Update existing applications to use new status values
UPDATE applications SET status = 'Applied' WHERE status = 'pending';

-- Add missing columns to student_profiles table
ALTER TABLE student_profiles ADD COLUMN IF NOT EXISTS gpa DECIMAL(3,2);
ALTER TABLE student_profiles ADD COLUMN IF NOT EXISTS education TEXT;

-- Add missing columns to company_profiles table
ALTER TABLE company_profiles ADD COLUMN IF NOT EXISTS contact_email VARCHAR(255);
