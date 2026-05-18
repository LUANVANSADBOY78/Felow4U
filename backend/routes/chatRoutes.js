const express = require('express');
const { getChats } = require('../controllers/chatController');
const { protect } = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/', protect, getChats);

module.exports = router;
