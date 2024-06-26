// routes/admin.js

const express = require('express');
const router = express.Router();
const isAdmin = require('../middleware/isadmin');
const User = require('../models/User');

// GET /api/admin/users
// Route protégée pour récupérer tous les utilisateurs (réservée aux admins)
router.get('/users', async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
