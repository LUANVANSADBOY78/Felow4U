const User = require('../models/userModel');

// @desc    Lấy danh sách hướng dẫn viên
// @route   GET /api/guides
const getGuides = async (req, res) => {
  // const guides = await User.find({ role: 'Guide' });
  const guides = [
    { id: 'g1', name: 'Tuan Tran', location: 'Da Nang', rating: 4.8, avatar: 'https://picsum.photos/seed/tuan/100/100' },
    { id: 'g2', name: 'Emmy Nguyen', location: 'Ho Chi Minh', rating: 4.9, avatar: 'https://picsum.photos/seed/emmy/100/100' },
  ];
  res.json(guides);
};

// @desc    Lấy chi tiết hướng dẫn viên
// @route   GET /api/guides/:id
const getGuideById = async (req, res) => {
  const guide = {
    id: req.params.id,
    name: 'Tuan Tran',
    location: 'Da Nang, Vietnam',
    rating: 4.8,
    reviews: 124,
    bio: 'Hi, I am Tuan. I have 5 years experience as a guide in Central Vietnam. I love sharing local culture and food with travelers.',
    languages: ['Vietnamese', 'English'],
    avatar: 'https://picsum.photos/seed/tuan/100/100'
  };
  res.json(guide);
};

module.exports = { getGuides, getGuideById };
