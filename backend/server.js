import express from "express";
import cors from "cors";

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

let users = [];

app.get("/users", (req, res) => {
  res.json(users);
});

app.post("/login", (req, res) => {
  const { username } = req.body;
  if (!username) return res.status(400).json({ error: "Username required" });

  if (!users.includes(username)) users.push(username);
  res.json({ users });
});

app.listen(PORT, () => {
  console.log(`Backend running securely 🚀 on port ${PORT}`);
});
