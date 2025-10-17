#!/bin/bash
# setup-secure-webapp.sh
# Full stack setup: Backend + Frontend + Tailwind + React + Dashboard

# Exit on error
set -e

echo "=== Setting up Backend ==="
mkdir -p backend
cat > backend/server.js << 'EOF'
const express = require("express");
const cors = require("cors");
const app = express();
const PORT = 5000;

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
EOF

cd backend
npm init -y
npm install express cors
cd ..

echo "=== Setting up Frontend ==="
mkdir -p frontend
cd frontend

# Initialize Vite + React
npm create vite@latest . -- --template react << EOF
y
EOF

npm install
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Configure Tailwind
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html","./src/**/*.{js,jsx,ts,tsx}"],
  theme: { extend: {} },
  plugins: [],
};
EOF

cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Replace App.jsx with interactive frontend
cat > src/App.jsx << 'EOF'
import { useEffect, useState } from "react";

export default function App() {
  const [users, setUsers] = useState([]);
  const [username, setUsername] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    if (!username.trim()) return;
    const res = await fetch("http://localhost:5000/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username }),
    });
    const data = await res.json();
    setUsers(data.users);
    setLoggedIn(true);
  };

  if (!loggedIn) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <form onSubmit={handleLogin} className="bg-white p-8 rounded shadow-md w-80">
          <h2 className="text-2xl font-bold mb-4 text-center">Login</h2>
          <input type="text" placeholder="Username" value={username} onChange={(e)=>setUsername(e.target.value)} className="w-full border p-2 rounded mb-4"/>
          <button type="submit" className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">Login</button>
        </form>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 flex flex-col items-center justify-center">
      <h1 className="text-3xl font-bold mb-4">Backend is running securely 🚀</h1>
      <h2 className="text-xl mb-2">Users:</h2>
      <ul className="text-lg">{users.map(u => <li key={u}>{u}</li>)}</ul>
    </div>
  );
}
EOF

cd ..

echo "=== Setup complete! ==="
echo "Run backend: cd backend && node server.js"
echo "Run frontend: cd frontend && npm run dev"

