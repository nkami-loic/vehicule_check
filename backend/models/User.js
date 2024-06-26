import mongoose from 'mongoose';

const { Schema } = mongoose;

const userSchema = new Schema({
  username: String,
  email: String,
  password: String,
  role: { type: String, enum: ['admin', 'user'], default: 'user' }
});

const User = mongoose.model('User', userSchema);

export default User;
