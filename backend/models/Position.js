import mongoose from 'mongoose';

const PositionSchema = new mongoose.Schema({
  truckId: {
    type: String, 
    required: true,
  },
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
});

const Position = mongoose.model('Position', PositionSchema);

export default Position;