import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import http from 'http';
import { Server } from 'socket.io';
import authRoutes from './routes/auth.js';
import positionRoutes from './routes/positions.js';
import VehicleSimulator from './utils/VehicleSimulator.js';
import session from 'express-session';
import connectMongo from 'connect-mongo';
import Position from './models/Position.js';
import userMiddleware from './middleware/userMiddleware.js';

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

app.use(express.json());

// Routes
app.use('/api/positions', positionRoutes);
app.use('/api/auth', authRoutes);


// Middleware pour authentifier l'utilisateur et ajouter req.user
app.use(userMiddleware);

// Connexion à MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('MongoDB connection error:', err));

// Configuration du store de session avec connectMongo
const MongoStore = connectMongo.create({
  mongoUrl: process.env.MONGODB_URI,
  ttl: 14 * 24 * 60 * 60, // 14 jours
});

// Middleware de session
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  store: MongoStore,
  cookie: {
    name: 'connect.sid',
    maxAge: 1800000 // 30 minutes
  }
}));


// Simulation des véhicules
const simulator = new VehicleSimulator();

simulator.on('position', async (data) => {
  const { vehicleId: truckId, position: { lat: latitude, lon: longitude } } = data;
  
  if (!truckId || !latitude || !longitude) {
    console.error('Missing required fields:', { truckId, latitude, longitude });
    return;
  }
  
  try {
    const newPosition = new Position({
      truckId,
      latitude,
      longitude,
    });
    await newPosition.save();
    io.emit('position', newPosition); 
  } catch (err) {
    console.error('Error saving position:', err.message);
  }
});

simulator.on('position', (data) => {
  io.emit('position', data);
});
simulator.on('alert', (data) => {
  io.emit('alert', data);
});
simulator.start();

// Lancement du serveur
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
