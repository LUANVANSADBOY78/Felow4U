const Notification = require('../models/notificationModel');

// @desc    Lấy danh sách thông báo
// @route   GET /api/notifications
const getNotifications = async (req, res) => {
  // const notifications = await Notification.find({ user: req.user._id });
  const notifications = [
    { id: 'n1', title: 'Booking Confirmed', message: 'Your trip to Da Nang is confirmed!', time: '2 hours ago', type: 'Trip' },
    { id: 'n2', title: 'New Message', message: 'You have a new message from Tuan Tran.', time: '5 hours ago', type: 'Message' },
  ];
  res.json(notifications);
};

module.exports = { getNotifications };
