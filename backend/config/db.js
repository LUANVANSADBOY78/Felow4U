const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    // Không thoát process để server vẫn chạy được nếu không có MongoDB (demo mode)
    console.log('Running in demo mode without MongoDB...');
  }
};

module.exports = connectDB;
