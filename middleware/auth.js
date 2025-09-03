const jwt = require('jsonwebtoken');

// Middleware to extract user from JWT
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ message: 'Access token required' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ message: 'Invalid or expired token' });
    }
    req.user = user; // user.id, user.role, etc.
    next();
  });
}

// Middleware to check if user is admin
function requireAdmin(req, res, next) {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    res.status(403).json({ message: 'Admin access required' });
  }
}

// Middleware to check if user is student
function requireStudent(req, res, next) {
  if (req.user && req.user.role === 'student') {
    next();
  } else {
    res.status(403).json({ message: 'Student access required' });
  }
}

// Middleware to check if user is company
function requireCompany(req, res, next) {
  if (req.user && req.user.role === 'company') {
    next();
  } else {
    res.status(403).json({ message: 'Company access required' });
  }
}

module.exports = {
  authenticateToken,
  requireAdmin,
  requireStudent,
  requireCompany
};
