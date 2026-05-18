const express = require('express');
const { getGuides, getGuideById } = require('../controllers/guideController');
const router = express.Router();

router.get('/', getGuides);
router.get('/:id', getGuideById);

module.exports = router;
