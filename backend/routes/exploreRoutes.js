const express = require('express');
const { getExploreData, searchExplore } = require('../controllers/exploreController');
const router = express.Router();

router.get('/', getExploreData);
router.get('/search', searchExplore);

module.exports = router;
