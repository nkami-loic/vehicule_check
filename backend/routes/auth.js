import express from 'express';
import { check, validationResult } from 'express-validator';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/User.js';
const router = express.Router();

// Enregistrement d'un nouvel utilisateur
router.post('/register', [
  check('username').not().isEmpty().withMessage('Username requise'),
  check('password')
    .isLength({ min: 6 }).withMessage('Le mot de passe doit avoir au moins 6 caracteres')
    .matches(/[A-Z]/).withMessage('Le mot de passe doit contenir au moins une lettre majuscule')
    .matches(/[!@#$%^&*(),.?":{}|<>]/).withMessage('Le mot de passe doit contenir au moins un caractère spécial'),
  check('role').not().isEmpty().withMessage('Role requise').isIn(['admin', 'user']).withMessage('role Invalide')
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { username, password, role } = req.body;
  
  try {
    let user = await User.findOne({ username });
    if (user) {
      return res.status(400).json({ msg: 'Utilisateur existe deja ' });
    }

    user = new User({ username, password: await bcrypt.hash(password, 10), role });
    await user.save();

    const payload = { user: { id: user.id, role: user.role } };
    jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' }, (err, token) => {
      if (err) throw err;
      res.json({ token, sessionId: req.sessionID });
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

// Route de logout
router.post('/logout', (req, res) => {
  if (req.session) {
    req.session.destroy((err) => {
      if (err) {
        return res.status(500).send('Impossible de se déconnecter');
      }
      res.clearCookie('connect.sid');
      return res.send('Deconnexion');
    });
  } else {
    res.status(200).send('Aucune session à déconnecter');
  }
});

// Authentification de l'utilisateur
router.post('/login', [
  check('username').not().isEmpty().withMessage('Username requise'),
  check('password').exists().withMessage('Mot de passe requise'),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { username, password } = req.body;

  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ msg: 'Credentials invalides' });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: 'Credentials invalides' });
    }

    const payload = { user: { id: user.id, role: user.role } };
    jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' }, (err, token) => {
      if (err) throw err;
      res.json({ token, sessionId: req.sessionID });
    });
  } catch (err) {
    console.error('Erreur complète:', err);
    res.status(500).send('Erreur Serveur');
  }
});

export default router;