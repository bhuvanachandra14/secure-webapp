#!/bin/bash
# Setup frontend with backend integration for secure-webapp (Mac)

set -e  # Stop on error

# Navigate to your project folder (adjust path)
cd /Users/bhuvan/Documents/secure-webapp || exit

echo "🚀 Removing old frontend..."
rm -rf frontend

echo "📦 Creating new Vite + React project..."
npm create vite@latest frontend -- --template react --yes

cd frontend || exit

echo "📥 Installing dependencies..."
npm install
npm install axios
npm install -D tailwindcss postcss autoprefixer

echo "🎨 Initializing Tailwind..."
npx tailwindcss init -p

echo "🗂️ Setting up project files..."

rm -rf src
mkdir -p src/components

# main.jsx
cat > src/main.jsx <<'EOF'
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
EOF

# App.jsx
cat > src/App.jsx <<'EOF'
import React, { useState } from "react";
import Login from "./components/Login";
import Dashboard from "./components/Dashboard";

export default function App() {
  const [user, setUser] = useState(null);
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      {user ? <Dashboard user={user} /> : <Login setUser={setUser} />}
    </div>
  );
}
EOF

# Login.jsx
cat > src/components/Login.jsx <<'EOF'
import React, { useState } from "react";

export default function Login({ setUser }) {
  const [username, setUsername] = useState("");

  const handleLogin = (e) => {
    e.preventDefault();
    if (!username) return;
    setUser(username);
  };

  return (
    <form
      onSubmit={handleLogin}
      className="bg-white p-6 rounded shadow-md w-80 flex flex-col gap-4"
    >
      <h2 className="text-xl font-bold text-center">Login</h2>
      <input
        type="text"
        placeholder="Enter username"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
        className="border p-2 rounded"
      />
      <button type="submit" className="bg-blue-500 text-white py-2 rounded">
        Login
      </button>
    </form>
  );
}
EOF

# Dashboard.jsx
cat > src/components/Dashboard.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import axios from "axios";

export default function Dashboard({ user }) {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios
      .get("http://localhost:5000/api/users")
      .then((res) => setUsers(res.data))
      .catch((err) => console.error("Backend not reachable", err))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="bg-white p-6 rounded shadow-md w-96">
      <h2 className="text-xl font-bold mb-4">Welcome, {user}!</h2>
      <h3 className="font-semibold mb-2">Users:</h3>
      {loading ? (
        <p>Loading...</p>
      ) : users.length > 0 ? (
        <ul className="list-disc list-inside">
          {users.map((u, idx) => (
            <li key={idx}>{u}</li>
          ))}
        </ul>
      ) : (
        <p>No users found.</p>
      )}
    </div>
  );
}
EOF

# index.css
echo "@tailwind base;
@tailwind components;
@tailwind utilities;" > src/index.css

echo "✅ Frontend setup complete. Make sure your backend is running at http://localhost:5000"
echo "Starting frontend dev server..."
npm run dev

