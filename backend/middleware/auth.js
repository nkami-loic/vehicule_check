import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    console.log('No auth header');
    return res.status(401).json({ msg: 'Pas de Token, autorisation refusée' });
  }

  const token = authHeader.split(' ')[1];
  if (!token) {
    console.log('Aucun jeton trouvé dans l en-tête d authentification');
    return res.status(401).json({ msg: 'Pas de Token, autorisation refusée' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log('Token es valide, user:', decoded.user);
    req.user = decoded.user;
    next();
  } catch (err) {
    console.error('Erruer de verification du Token:', err);
    res.status(401).json({ msg: 'Le Token n est pas valide' });
  }
};

export default authMiddleware;
