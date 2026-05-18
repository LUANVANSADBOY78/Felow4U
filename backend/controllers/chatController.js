let chatMessages = {};

// Get messages for a trip
exports.getMessages = (req, res) => {
  const { tripId } = req.params;
  const msgs = chatMessages[tripId] || [];
  res.json(msgs);
};

// Post a new message to a trip
exports.postMessage = (req, res) => {
  const { tripId } = req.params;
  const { userId, content } = req.body;
  if (!userId || !content) {
    return res.status(400).json({ msg: 'Missing userId or content' });
  }
  const newMsg = {
    id: (chatMessages[tripId]?.length || 0) + 1,
    userId,
    content,
    createdAt: new Date().toISOString(),
  };
  if (!chatMessages[tripId]) chatMessages[tripId] = [];
  chatMessages[tripId].push(newMsg);
  res.status(201).json(newMsg);
};
