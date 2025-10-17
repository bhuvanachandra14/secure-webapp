// backend/server.js
import express from 'express';
import cors from 'cors';

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.send('Backend is running securely 🚀');
});

// Users route
app.get('/users', (req, res) => {
  res.json(["Alice", "Bob", "Charlie"]);
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

