const express = require("express");
const cors = require("cors");
const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

let users = ["Alice", "Bob", "Charlie"];

app.get("/users", (req, res) => {
  res.json(users);
});

app.post("/login", (req, res) => {
  const { username } = req.body;
  if (!username || username.trim() === "") return res.status(400).json({ error: "Username required" });
  if (!users.includes(username)) users.push(username);
  res.json({ message: "Login successful", users });
});

app.listen(PORT, () => console.log(`Backend running on port ${PORT} 🚀`));
