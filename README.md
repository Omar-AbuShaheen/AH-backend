# CareerNest Backend API

A clean, router-based Express.js backend for the CareerNest internship portal.

## 🏗️ Project Structure

```
backend/
├── config/
│   └── db.js              # Database connection configuration
├── middleware/
│   └── auth.js            # JWT authentication middleware
├── routes/
│   ├── auth.js            # Authentication routes (login, register, admin)
│   ├── internships.js     # Internship management routes
│   ├── applications.js    # Application management routes
│   ├── admin.js           # Admin panel routes
│   └── students.js        # Student profile routes
├── app.js                 # Main application file
├── package.json           # Dependencies and scripts
└── env.example            # Environment variables template
```

## 🚀 Getting Started

### 1. Environment Setup
Copy `env.example` to `.env` and configure:
```bash
cp env.example .env
```

Update the `.env` file with your database credentials:
```env
DATABASE_URL=postgresql://postgres:your_password@localhost:5432/careernest
JWT_SECRET=your-super-secret-jwt-key
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Start the Server
```bash
# Development mode with auto-restart
npm run dev

# Production mode
npm start
```

## 🔐 Authentication

The API uses **JWT (JSON Web Tokens)** for authentication:

- **Student Registration**: `POST /api/auth/register`
- **Student Login**: `POST /api/auth/login`
- **Admin Login**: `POST /api/auth/admin/login`
- **Get Current User**: `GET /api/auth/me`

Include the JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - Student registration
- `POST /api/auth/login` - Student login
- `POST /api/auth/admin/login` - Admin login
- `GET /api/auth/me` - Get current user info

### Internships
- `GET /api/internships` - Get all active internships
- `GET /api/internships/search` - Search internships
- `GET /api/internships/:id` - Get internship details
- `POST /api/internships/:id/apply` - Apply to internship

### Applications
- `GET /api/applications/my-applications` - Get student's applications
- `GET /api/applications` - Get all applications (admin)
- `PUT /api/applications/:id/status` - Update application status (admin)

### Admin Panel
- `GET /api/admin/dashboard` - Admin dashboard stats
- `GET /api/admin/companies` - Manage companies
- `GET /api/admin/internships` - Manage internships
- `GET /api/admin/students` - View all students

### Student Profile
- `GET /api/students/profile` - Get student profile
- `PUT /api/students/profile` - Update student profile
- `PUT /api/students/password` - Change password

## 🗄️ Database Schema

The API expects these main tables:
- `students` - Student user accounts
- `admins` - Admin user accounts  
- `companies` - Company information
- `internships` - Internship postings
- `applications` - Student applications

## 🔧 Middleware

- **CORS** - Cross-origin resource sharing
- **JSON Parser** - Parse JSON request bodies
- **JWT Authentication** - Verify JWT tokens
- **Role-based Access** - Admin and student role checks

## 📊 Health Check

Test if the API is running:
```bash
GET /api/health
```

## 🛠️ Development

The backend uses:
- **Express.js** - Web framework
- **PostgreSQL** - Database
- **JWT** - Authentication
- **bcryptjs** - Password hashing
- **CORS** - Cross-origin support

## 📝 Notes

- All routes are organized in separate files under `/routes`
- Authentication middleware protects private endpoints
- Database queries use parameterized statements for security
- Error handling is centralized in the main app.js
