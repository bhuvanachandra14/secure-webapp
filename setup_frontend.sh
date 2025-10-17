#!/bin/bash

# ================================
# Setup React + Tailwind Frontend
# with login/dashboard
# ================================

set -e  # Exit on any error

# 1. Install NVM if not installed
if ! command -v nvm &> /dev/null
then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.6/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# 2. Install Node 20 LTS
nvm install 20
nvm use 20
nvm alias default 20

# 3. Go to project folder
PROJECT_DIR="$HOME/Documents/secure-webapp"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# 4. Remove old frontend
rm -rf frontend

# 5. Create Vite + React frontend
npm create vite@latest frontend -- --template react
cd frontend

# 6. Install dependencies
npm install

# 7. Install Tailwind CSS and PostCSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# 8. Remove default src and replace with our login/dashboard
rm -rf src
mkdir src

# 9. Create main.jsx
cat << 'EOF' > src/main.jsx
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

# 10. Create App.jsx with interactive dashboard
cat << 'EOF' > src/App.jsx
import { useEffect, useState } from "react";

export default function App() {
  const [users, setUsers] = useState([]);
  const [username, setUsername] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);

  const handleLogin = (e) => {
    e.preventDefault();
    if(username.trim() !== "") setLoggedIn(true);
  };

  useEffect(() => {
    if (loggedIn) {
      // Simulate backend fetch
      setTimeout(() => {
        setUsers(["Alice", "Bob", "Charlie"]);
      }, 500);
    }
  }, [loggedIn]);

  if (!loggedIn) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <form onSubmit={handleLogin} className="bg-white p-8 rounded shadow-md w-80">
          <h2 className="text-2xl font-bold mb-4 text-center">Login</h2>
          <input
            type="text"
            placeholder="Enter username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            className="w-full border border-gray-300 p-2 rounded mb-4"
          />
          <button type="submit" className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
            Login
          </button>
        </form>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 flex flex-col items-center justify-center">
      <h1 className="text-3xl font-bold mb-4">Backend is running securely 🚀</h1>
      <h2 className="text-xl mb-2">Users:</h2>
      <ul className="text-lg">
        {users.map((user) => (
          <li key={user}>{user}</li>
        ))}
      </ul>
    </div>
  );
}
EOF

# 11. Create Tailwind CSS index file
cat << 'EOF' > src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  font-family: system-ui, sans-serif;
}
EOF

# 12. Start dev server
echo "Starting frontend dev server..."
npm run dev

