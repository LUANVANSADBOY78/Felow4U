const Booking = require('../models/bookingModel');

// @desc    Lấy danh sách các chuyến đi của tôi
// @route   GET /api/my-trips
const getMyTrips = async (req, res) => {
  // const bookings = await Booking.find({ user: req.user._id }).populate('trip');
  const bookings = [
    {
      id: 'b1',
      status: 'Confirmed',
      trip: {
        title: 'Da Nang Discovery',
        location: 'Da Nang',
        date: '2024-05-20',
        price: 150,
        image: 'https://picsum.photos/seed/danang/400/250'
      }
    }
  ];
  res.json(bookings);
};

module.exports = { getMyTrips };
