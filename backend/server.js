// backend/server.js

// 1. Import required modules
const express = require("express");
const cors = require("cors");

// 2. Create the Express app
const app = express();

// 3. Middleware
app.use(cors());          // allow requests from any origin
app.use(express.json());  // parse JSON request bodies

// 4. Home route
app.get("/", (req, res) => {
  res.json({ message: "Backend is running securely 🚀" });
});

// 5. Sample API route
app.get("/api/users", (req, res) => {
  const users = [
    { id: 1, name: "Alice" },
    { id: 2, name: "Bob" },
    { id: 3, name: "Charlie" }
  ];
  res.json(users);
});

// 6. Start server on port 3001
const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
