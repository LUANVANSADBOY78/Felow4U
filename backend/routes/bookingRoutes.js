const express = require('express');
const { getMyTrips } = require('../controllers/bookingController');
const { protect } = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/', protect, getMyTrips);

module.exports = router;
