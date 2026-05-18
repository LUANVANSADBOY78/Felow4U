const mongoose = require('mongoose');

const tripSchema = mongoose.Schema(
  {
    title: { type: String, required: true },
    location: { type: String, required: true },
    description: { type: String },
    price: { type: Number, required: true },
    image: { type: String },
    guide: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  { timestamps: true }
);

const Trip = mongoose.model('Trip', tripSchema);
module.exports = Trip;
