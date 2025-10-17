#!/bin/bash
set -e

echo "💻 Setting up frontend (React + Tailwind + Axios)..."

# Go to project root
cd "$(dirname "$0")"

# Step 1: Remove old frontend if it exists
rm -rf frontend
mkdir frontend
cd frontend

# Step 2: Create Vite + React project
npm create vite@latest . -- --template react --force

# Step 3: Install dependencies
npm install
npm install axios
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Step 4: Remove default src folder
rm -rf src
mkdir -p src/components

# Step 5: Create source files

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

# Tailwind index.css
cat > src/index.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Step 6: Done
echo "✅ Frontend setup complete!"
echo "Run 'npm run dev' inside frontend folder to start the development server."

