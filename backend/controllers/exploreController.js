const Trip = require('../models/tripModel');
const User = require('../models/userModel');

// @desc    Lấy dữ liệu cho màn hình Explore
// @route   GET /api/explore
const getExploreData = async (req, res) => {
  // Trong thực tế sẽ Query DB:
  // const featuredTrips = await Trip.find({}).limit(5);
  // const topGuides = await User.find({ role: 'Guide' }).limit(5);

  // Trả về dữ liệu mẫu khớp với UI của bạn
  res.json({
    categories: [
      { id: 'c1', name: 'Beach', icon: 'beach_access' },
      { id: 'c2', name: 'Mountain', icon: 'terrain' },
      { id: 'c3', name: 'Food', icon: 'restaurant' },
      { id: 'c4', name: 'Adventure', icon: 'directions_run' },
    ],
    topJourneys: [
      { id: '1', title: 'Da Nang - Ba Na - Hoi An', image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=400&h=250&fit=crop', location: 'Vietnam', price: '\$400.00', duration: '3 days', date: 'Jan 30, 2020' },
      { id: '2', title: 'Thailand', image: 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=400&h=250&fit=crop', location: 'Thailand', price: '\$600.00', duration: '3 days', date: 'Jan 30, 2020' },
    ],
    featuredTours: [
      { id: '1', title: 'Da Nang - Ba Na - Hoi An', image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=900&h=500&fit=crop', location: 'Vietnam', price: '\$400.00', duration: '3 days', date: 'Jan 30, 2020' },
      { id: '2', title: 'Melbourne - Sydney', image: 'https://images.unsplash.com/photo-1528072164453-f4e8ef0d475a?w=900&h=500&fit=crop', location: 'Australia', price: '\$600.00', duration: '3 days', date: 'Jan 30, 2020' },
      { id: '3', title: 'Hanoi - Ha Long Bay', image: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=900&h=500&fit=crop', location: 'Vietnam', price: '\$300.00', duration: '3 days', date: 'Jan 30, 2020' },
    ],
    topGuides: [
      { id: 'g1', name: 'Tuan Tran', avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop', rating: 4.8, location: 'Danang, Vietnam' },
      { id: 'g2', name: 'Emmy', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop', rating: 4.9, location: 'Hanoi, Vietnam' },
      { id: 'g3', name: 'Linh Hana', avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop', rating: 4.8, location: 'Danang, Vietnam' },
      { id: 'g4', name: 'Khai Ho', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop', rating: 4.9, location: 'Ho Chi Minh, Vietnam' },
    ],
    recentExperiences: [
      { id: 'e1', title: '2 Hour Bicycle Tour exploring Hoian', guide: 'Tuan Tran', image: 'https://images.unsplash.com/photo-1538332576228-eb5b4c4de6f5?w=200&h=300&fit=crop', avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop', location: 'Hoian, Vietnam' },
      { id: 'e2', title: '1 day at Bana Hill', guide: 'Linh Hana', image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=200&h=300&fit=crop', avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop', location: 'Bana, Vietnam' },
    ],
    travelNews: [
      { id: 'n1', title: 'New Destination in Danang City', date: 'Feb 5, 2020', image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=400&h=200&fit=crop' },
      { id: 'n2', title: '\$1 Flight Ticket', date: 'Feb 5, 2020', image: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400&h=200&fit=crop' },
      { id: 'n3', title: 'Visit Korea in this Tet Holiday', date: 'Jan 26, 2020', image: 'https://images.unsplash.com/photo-1517154421773-0529f29ea451?w=400&h=200&fit=crop' },
    ]
  });
};

// @desc    Tìm kiếm chuyến đi hoặc hướng dẫn viên
// @route   GET /api/explore/search?q=...
const searchExplore = async (req, res) => {
  const query = (req.query.q || '').toLowerCase();
  
  // Toàn bộ data mẫu để search
  const allTrips = [
    { id: '1', title: 'Da Nang - Ba Na - Hoi An', price: '$400.00', image: 'https://picsum.photos/seed/featured-danang/900/520', location: 'Danang, Vietnam', date: 'Jan 30, 2026' },
    { id: '2', title: 'Melbourne - Sydney', price: '$600.00', image: 'https://picsum.photos/seed/featured-melbourne/900/520', location: 'Australia', date: 'Feb 15, 2026' },
    { id: '3', title: 'Hanoi - Ha Long Bay', price: '$300.00', image: 'https://picsum.photos/seed/featured-halong/900/520', location: 'Hanoi, Vietnam', date: 'Mar 10, 2026' },
  ];

  const allGuides = [
    { id: 'g1', name: 'Tuan Tran', location: 'Danang, Vietnam', avatar: 'https://picsum.photos/seed/guide-tuan/300/300' },
    { id: 'g2', name: 'Linh Hana', location: 'Danang, Vietnam', avatar: 'https://picsum.photos/seed/guide-linh/300/300' },
    { id: 'g3', name: 'Emmy Nguyen', location: 'Ho Chi Minh, Vietnam', avatar: 'https://picsum.photos/seed/guide-emmy/300/300' },
  ];

  // Lọc theo query
  const filteredTrips = allTrips.filter(t => t.title.toLowerCase().includes(query) || t.location.toLowerCase().includes(query));
  const filteredGuides = allGuides.filter(g => g.name.toLowerCase().includes(query) || g.location.toLowerCase().includes(query));

  res.json({
    trips: filteredTrips,
    guides: filteredGuides
  });
};

module.exports = { getExploreData, searchExplore };
