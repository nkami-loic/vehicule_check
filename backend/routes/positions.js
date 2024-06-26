import express from 'express';
import { body, validationResult } from 'express-validator';
import Position from '../models/Position.js';

const router = express.Router();

router.post('/', [
  body('truckId').notEmpty(),
  body('latitude').isNumeric(),
  body('longitude').isNumeric(),
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { truckId, latitude, longitude } = req.body;

  try {
    const newPosition = new Position({
      truckId,
      latitude,
      longitude,
    });

    await newPosition.save();

    res.status(201).json(newPosition);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur Serveur');
  }
});

export default router;
