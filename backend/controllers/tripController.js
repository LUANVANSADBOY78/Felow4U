const Trip = require('../models/tripModel');

// @desc    Lấy tất cả các chuyến đi
// @route   GET /api/trips
const getTrips = async (req, res) => {
  // Trong thực tế sẽ lấy từ DB: const trips = await Trip.find({}).populate('guide', 'firstName lastName');
  // Ở đây tôi trả về dữ liệu mẫu để bạn test ngay lập tức
  const trips = [
    { _id: '1', title: 'Da Nang Discovery', location: 'Da Nang, Vietnam', price: 150, image: 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b' },
    { _id: '2', title: 'Thailand Discovery', location: 'Bangkok, Thailand', price: 300, image: 'https://images.unsplash.com/photo-1528127269322-539801943592' },
    { _id: '3', title: 'Sapa Trekking', location: 'Lao Cai, Vietnam', price: 120, image: 'https://images.unsplash.com/photo-1506701908216-882ec818f24e' },
    { _id: '4', title: 'Hue Heritage', location: 'Hue, Vietnam', price: 100, image: 'https://images.unsplash.com/photo-1571210862729-78a52d3779a2' },
    { _id: '5', title: 'Phu Quoc Sunset', location: 'Kien Giang, Vietnam', price: 200, image: 'https://images.unsplash.com/photo-1589394815804-964ed962eb33' },
    { _id: '6', title: 'Bali Escape', location: 'Bali, Indonesia', price: 500, image: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4' },
    { _id: '7', title: 'Singapore Modern', location: 'Singapore', price: 450, image: 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd' },
    { _id: '8', title: 'Tokyo Autumn', location: 'Tokyo, Japan', price: 800, image: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e' },
    { _id: '9', title: 'Seoul K-Wave', location: 'Seoul, Korea', price: 600, image: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc' },
    { _id: '10', title: 'Ha Long Cruise', location: 'Quang Ninh, Vietnam', price: 250, image: 'https://images.unsplash.com/photo-1554034483-04fda0d3507b' },
  ];

  res.json(trips);
};

// @desc    Lấy danh sách chuyến đi của tôi (Phân loại)
// @route   GET /api/trips/my
const getMyTrips = async (req, res) => {
  res.json({
    current: [
      { id: 't1', title: 'Dragon Bridge Trip', date: 'Jan 30, 2026', time: '13:00 - 15:00', guideName: 'Tuan Tran', location: 'Da Nang, Vietnam', image: 'https://picsum.photos/seed/dragon/400/200', avatars: ['https://picsum.photos/seed/g1/50/50'], status: 'Mark Finished' }
    ],
    next: [
      { id: 't2', title: 'Ho Guom Trip', date: 'Feb 2, 2026', time: '8:00 - 10:00', guideName: 'Emmy Nguyen', location: 'Hanoi, Vietnam', image: 'https://picsum.photos/seed/hoguom/400/200', avatars: ['https://picsum.photos/seed/g2/50/50'], status: 'Pay' },
      { id: 't3', title: 'Duc Ba Church', date: 'Feb 15, 2026', time: '9:00 - 11:00', guideName: 'Waiting for offers', location: 'Ho Chi Minh, Vietnam', image: 'https://picsum.photos/seed/ducba/400/200', avatars: ['https://picsum.photos/seed/g3/50/50', 'https://picsum.photos/seed/g4/50/50'], extraAvatars: 3, status: 'Bidding' }
    ],
    past: [
      { id: 't4', title: 'Quoc Tu Giam Temple', date: 'Dec 20, 2025', time: '10:00 - 12:00', guideName: 'Linh Hana', location: 'Hanoi, Vietnam', image: 'https://picsum.photos/seed/quoctugiam/400/200', avatars: ['https://picsum.photos/seed/g5/50/50'], status: 'Completed' }
    ],
    wishlist: [
      { id: 't5', title: 'Melbourne - Sydney', price: '$600.00', image: 'https://picsum.photos/seed/melbourne/400/200' }
    ]
  });
};

// @desc    Tạo chuyến đi mới
// @route   POST /api/trips
const createTrip = async (req, res) => {
  const tripData = req.body;
  // Thực tế: const newTrip = await Trip.create(tripData);
  res.status(201).json({ message: 'Trip created successfully', trip: tripData });
};

// @desc    Lấy chi tiết một chuyến đi
// @route   GET /api/trips/:id
const getTripById = async (req, res) => {
  res.json({ id: req.params.id, title: 'Trip Detail', description: 'Mock detail' });
};

module.exports = { getTrips, getTripById, getMyTrips, createTrip };

