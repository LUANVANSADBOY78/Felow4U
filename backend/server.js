// backend/server.js - Full mock API for Fellow-4U
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// In-memory data stores
let users = [
  {
    id: '1',
    firstName: 'Luan',
    lastName: 'Van',
    email: 'vanluan78@gmail.com',
    password: '12345678',
    country: 'Vietnam',
    role: 'user',
    avatar: 'https://i.pravatar.cc/150?u=vanluan'
  }
];

let notifications = [];
let bookings = [];
let trips = [
  {
    id: '1',
    title: 'Da Nang - Ba Na - Hoi An',
    image: 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=400&h=300&fit=crop',
    price: '$400.00',
    location: 'Danang, Vietnam',
    duration: '3 days',
    date: 'Jan 30, 2020',
    guideId: 'g1',
    description: 'Explore Danang, Ba Na Hills and Hoi An in one trip.'
  },
  {
    id: '2',
    title: 'Melbourne - Sydney',
    image: 'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?w=400&h=300&fit=crop',
    price: '$600.00',
    location: 'Australia',
    duration: '3 days',
    date: 'Feb 15, 2020',
    guideId: 'g2',
    description: 'Tour khám phá Melbourne và Sydney trong 3 ngày.'
  }
];

let guides = [
  {
    id: 'g1',
    name: 'Tuan Tran',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop',
    rating: 5,
    location: 'Danang, Vietnam',
    reviews: '127 Reviews'
  },
  {
    id: 'g2',
    name: 'Emmy Nguyen',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
    rating: 4.9,
    location: 'Hanoi, Vietnam',
    reviews: '89 Reviews'
  },
  {
    id: 'g3',
    name: 'Linh Hana',
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop',
    rating: 4.8,
    location: 'Danang, Vietnam',
    reviews: '127 Reviews'
  }
];

// ---------- Auth ----------
app.post('/api/auth/register', (req, res) => {
  const { firstName, lastName, email, password, country, avatar } = req.body;
  if (!email || !password) return res.status(400).json({ msg: 'Missing email or password' });
  if (users.find(u => u.email === email)) return res.status(409).json({ msg: 'User already exists' });
  const newUser = {
    id: (users.length + 1).toString(),
    firstName: firstName || '',
    lastName: lastName || '',
    email,
    password,
    country: country || '',
    role: 'user',
    avatar: avatar || 'https://i.pravatar.cc/150'
  };
  users.push(newUser);
  res.status(201).json(newUser);
});

app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email && u.password === password);
  if (!user) return res.status(401).json({ msg: 'Invalid credentials' });
  res.json(user);
});

app.get('/api/users', (req, res) => res.json(users));

// ---------- Explore ----------
app.get('/api/explore', (req, res) => {
  const data = {
    categories: [
      { id: 'c1', name: 'Beach', icon: 'beach_access' },
      { id: 'c2', name: 'Mountain', icon: 'terrain' },
      { id: 'c3', name: 'Food', icon: 'restaurant' },
      { id: 'c4', name: 'Adventure', icon: 'directions_run' }
    ],
    topJourneys: trips.slice(0, 2),
    topGuides: guides,
    recentExperiences: [
      {
        id: 'e1',
        title: '2 Hour Bicycle Tour exploring Hoian',
        guide: 'Tuan Tran',
        image: 'https://images.unsplash.com/photo-1555217088-2d51bc3e1d93?w=400&h=600&fit=crop',
        avatar: guides[0].avatar,
        location: 'Hoian, Vietnam'
      },
      {
        id: 'e2',
        title: '1 day at Bana Hill',
        guide: 'Linh Hana',
        image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=400&h=600&fit=crop',
        avatar: guides[2].avatar,
        location: 'Bana, Vietnam'
      }
    ],
    featuredTours: [trips[0], trips[1]],
    travelNews: [
      { id: 'n1', title: 'New Destination in Danang City', date: 'Feb 5, 2020', image: 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800&q=80' },
      { id: 'n2', title: '$1 Flight Ticket', date: 'Feb 5, 2020', image: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80' }
    ]
  };
  res.json(data);
});

// ---------- Notifications ----------
app.get('/api/notifications', (req, res) => res.json(notifications));
app.post('/api/notifications', (req, res) => {
  const { type, title, content, tripId, guideId } = req.body;
  const newNoti = {
    id: (notifications.length + 1).toString(),
    type,
    title,
    content,
    tripId: tripId || '',
    guideId: guideId || '',
    createdAt: new Date().toISOString(),
    read: false
  };
  notifications.unshift(newNoti);
  res.status(201).json(newNoti);
});
app.patch('/api/notifications/:id', (req, res) => {
  const noti = notifications.find(n => n.id === req.params.id);
  if (!noti) return res.status(404).json({ msg: 'Notification not found' });
  Object.assign(noti, req.body);
  res.json(noti);
});

// ---------- Bookings ----------
app.get('/api/bookings', (req, res) => res.json(bookings));
app.post('/api/bookings', (req, res) => {
  const { userId, tripId, status } = req.body;
  const newBooking = {
    id: (bookings.length + 1).toString(),
    userId,
    tripId,
    status: status || 'pending',
    createdAt: new Date().toISOString()
  };
  bookings.push(newBooking);
  res.status(201).json(newBooking);
});

// ---------- Trips ----------
app.get('/api/trips', (req, res) => res.json(trips));
app.get('/api/trips/:id', (req, res) => {
  const trip = trips.find(t => t.id === req.params.id);
  if (!trip) return res.status(404).json({ msg: 'Trip not found' });
  res.json(trip);
});

// ---------- Guides ----------
app.get('/api/guides', (req, res) => res.json(guides));

// Fallback 404
app.use((req, res) => res.status(404).json({ msg: 'Endpoint not found' }));

app.listen(PORT, () => console.log(`⚡️ Mock API running on http://localhost:${PORT}`));
