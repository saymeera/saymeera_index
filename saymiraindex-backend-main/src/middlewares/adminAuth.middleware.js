const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization;
  const token = authHeader.split([' '])[1]
  if (!token) {
    return res.status(401).json({ message: 'Token missing' });
  }

  jwt.verify(token, process.env.ADMIN_JWT_ACCESS_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({
        message: 'Access token expired or invalid'
      });
    }

    req.user = {
      id: decoded.id
    };

    next();
  });
};
