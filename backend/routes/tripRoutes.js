const express = require('express');
const { getTrips, getTripById, getMyTrips, createTrip } = require('../controllers/tripController');

const router = express.Router();

router.get('/', getTrips);
router.get('/my', getMyTrips);
router.post('/', createTrip);
router.get('/:id', getTripById);

module.exports = router;

