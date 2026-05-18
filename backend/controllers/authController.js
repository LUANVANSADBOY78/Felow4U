const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');

// Hàm tạo Token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET || 'secret', {
    expiresIn: '30d',
  });
};

// @desc    Đăng ký người dùng mới
// @route   POST /api/auth/register
const registerUser = async (req, res) => {
  const { firstName, lastName, email, password, country, role } = req.body;

  // Mock response if DB is not connected
  if (mongoose.connection.readyState !== 1) {
    console.log('Mocking registerUser because DB is not connected');
    return res.status(201).json({
      _id: 'mock_user_id_123',
      firstName,
      lastName,
      email,
      role: role || 'Traveler',
      token: generateToken('mock_user_id_123'),
    });
  }

  try {
    const userExists = await User.findOne({ email });

    if (userExists) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const user = await User.create({
      firstName,
      lastName,
      email,
      password,
      country,
      role,
    });

    if (user) {
      res.status(201).json({
        _id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        role: user.role,
        token: generateToken(user._id),
      });
    } else {
      res.status(400).json({ message: 'Invalid user data' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Đăng nhập người dùng
// @route   POST /api/auth/login
const authUser = async (req, res) => {
  const { email, password } = req.body;

  // Mock response if DB is not connected
  if (mongoose.connection.readyState !== 1) {
    console.log('Mocking authUser because DB is not connected');
    // For demo, accept any email/password
    if (email && password) {
       return res.json({
        _id: 'mock_user_id_123',
        firstName: 'Mock',
        lastName: 'User',
        email: email,
        role: 'Traveler',
        token: generateToken('mock_user_id_123'),
      });
    }
    return res.status(401).json({ message: 'Invalid email or password' });
  }

  try {
    const user = await User.findOne({ email });

    if (user && (await user.matchPassword(password))) {
      res.json({
        _id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        role: user.role,
        token: generateToken(user._id),
      });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Lấy thông tin profile người dùng
// @route   GET /api/auth/profile
const getUserProfile = async (req, res) => {
  const user = await User.findById(req.user._id);

  if (user) {
    res.json({
      _id: user._id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      role: user.role,
      country: user.country,
      avatar: user.avatar || 'https://picsum.photos/200/200'
    });
  } else {
    res.status(404).json({ message: 'User not found' });
  }
};

// @desc    Cập nhật profile người dùng
// @route   PUT /api/auth/profile
const updateUserProfile = async (req, res) => {
  const user = await User.findById(req.user._id);

  if (user) {
    user.firstName = req.body.firstName || user.firstName;
    user.lastName = req.body.lastName || user.lastName;
    user.country = req.body.country || user.country;
    if (req.body.password) {
      user.password = req.body.password;
    }

    const updatedUser = await user.save();

    res.json({
      _id: updatedUser._id,
      firstName: updatedUser.firstName,
      lastName: updatedUser.lastName,
      email: updatedUser.email,
      role: updatedUser.role,
      token: generateToken(updatedUser._id),
    });
  } else {
    res.status(404).json({ message: 'User not found' });
  }
};

module.exports = { registerUser, authUser, getUserProfile, updateUserProfile };
