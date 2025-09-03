# CareerNest Backend API

A comprehensive Express.js backend for the CareerNest internship portal with enhanced profiles, and role-based access control.

## 🏗️ Project Structure

```
backend/
├── config/
│   └── db.js              # Database connection configuration
├── middleware/
│   └── auth.js            # JWT authentication middleware
├── routes/
│   ├── auth.js            # Authentication routes (login, register, profile)
│   ├── internships.js     # Internship management routes
│   ├── applications.js    # Application management routes
│   ├── admin.js           # Admin panel routes
│   ├── students.js        # Student profile routes
│   └── companies.js       # Company profile routes
├── app.js                 # Main application file
├── package.json           # Dependencies and scripts
├── setup-clean-database.sql # Database schema and initial data
├── database-update-messages.sql # Message system schema update
└── .env                   # Environment variables (create from .env.example)
```

## 🚀 Getting Started

### 1. Environment Setup
Create a `.env` file with your database credentials:
```env
DATABASE_URL=postgresql://postgres:your_password@localhost:5432/careernest
JWT_SECRET=your-super-secret-jwt-key
```

### 2. Database Setup
Run the database setup scripts:
```bash
# Initial database setup
psql -U postgres -d careernest -f setup-clean-database.sql

# Add messaging system (if upgrading from older version)
psql -U postgres -d careernest -f database-update-messages.sql
```

### 3. Install Dependencies
```bash
npm install
```

### 4. Start the Server
```bash
# Development mode with auto-restart
npm run dev

# Production mode
npm start
```

## 🔐 Authentication

The API uses **JWT (JSON Web Tokens)** for authentication with unified login:

- **User Registration**: `POST /api/auth/register` (student/company)
- **User Login**: `POST /api/auth/login` (unified login)
- **Get Current User**: `GET /api/auth/me`
- **Update Profile**: `PUT /api/auth/profile`

Include the JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration (student/company)
- `POST /api/auth/login` - Unified login
- `GET /api/auth/me` - Get current user info
- `PUT /api/auth/profile` - Update user profile

### Internships
- `GET /api/internships` - Get all active internships
- `POST /api/internships` - Create internship (company)
- `PUT /api/internships/:id` - Update internship (company)
- `DELETE /api/internships/:id` - Delete internship (company)
- `POST /api/internships/:id/apply` - Apply to internship (student)

### Applications
- `GET /api/applications/my-applications` - Get student's applications with messages
- `GET /api/applications/my-messages` - Get student's messages from companies
- `GET /api/applications` - Get all applications (admin)
- `GET /api/applications/company` - Get company's applications
- `PATCH /api/applications/company/:id/status` - Update application status with message (company)
- `PUT /api/applications/:id/status` - Update application status (admin)

### Admin Panel
- `GET /api/admin/companies` - Manage companies
- `GET /api/admin/internships` - Manage internships
- `GET /api/admin/applications` - Manage applications
- `GET /api/admin/students` - View all students
- `PATCH /api/admin/companies/:id/approval` - Approve/reject companies
- `PATCH /api/admin/internships/:id/approval` - Approve/reject internships

### Student Profile
- `GET /api/students/profile` - Get enhanced student profile
- `PUT /api/students/profile` - Update enhanced student profile with additional fields
- `PUT /api/students/password` - Update student password

### Company Profile
- `GET /api/companies/profile` - Get company profile
- `PUT /api/companies/profile` - Update company profile

## 🗄️ Database Schema

The API uses a unified user system with these main tables:

### Core Tables
- `users` - Unified user accounts (students, companies, admins)
- `student_profiles` - Enhanced student information with education, skills, social links
- `company_profiles` - Company-specific information with contact details
- `internships` - Internship listings with approval system
- `applications` - Student applications to internships
- `company_messages` - Message system for company-to-student communication

### Enhanced Student Profile Fields
- **Personal Info**: name, email, phone, location, date_of_birth
- **Education**: university, major, graduation_year, gpa, additional education
- **Professional**: skills, experience, bio
- **Social Links**: linkedin_url, github_url, portfolio_url

### Key Features
- **Role-based access control** (student, company, admin)
- **Company approval system** for admin oversight
- **Internship approval system** for quality control
- **Messaging system** for company-to-student communication (hire/reject letters)
- **Enhanced profile management** with comprehensive fields
- **Real-time application tracking** with status updates
- **Advanced filtering and search** capabilities

## 💬 Messaging System

The platform includes a comprehensive messaging system for company-to-student communication:

### Message Types
- **Hired**: Congratulatory messages with contact information for next steps
- **Rejected**: Professional rejection notices with optional feedback

### Message Flow
1. **Company Action**: Company updates application status to "Hired" or "Rejected"
2. **Message Creation**: System prompts for custom message and contact email
3. **Database Storage**: Message stored in `company_messages` table
4. **Student Notification**: Message appears in student's application view

### Message Features
- **Custom Templates**: Pre-filled professional templates
- **Contact Information**: Optional email for hired candidates
- **Timestamp Tracking**: Message creation date and time
- **Professional Display**: Styled alerts in student dashboard
- **Application Integration**: Messages appear with application details

### API Endpoints for Messaging
```bash
# Send message with status update (company)
PATCH /api/applications/company/:id/status
{
  "status": "Hired|Rejected",
  "message": "Custom message text",
  "contact_email": "hr@company.com"  // Optional for hired
}

# Get student messages
GET /api/applications/my-messages

# Get applications with messages
GET /api/applications/my-applications
```

## 🔒 Security Features

- JWT-based authentication
- Password hashing with bcrypt
- Role-based authorization middleware
- Input validation and sanitization
- CORS configuration for frontend integration

## 🚀 Production Deployment

1. Set `NODE_ENV=production` in your environment
2. Use a production database (PostgreSQL)
3. Configure proper CORS settings
4. Set strong JWT secrets
5. Use HTTPS in production
6. Implement rate limiting for production use
