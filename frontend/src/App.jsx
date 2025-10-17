import { useState, useEffect } from "react";
import "./App.css";

function App() {
  const [username, setUsername] = useState("");
  const [users, setUsers] = useState([]);
  const [loggedIn, setLoggedIn] = useState(false);

  // Fetch users on page load
  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const res = await fetch("http://localhost:3001/users");
        const data = await res.json();
        setUsers(data);
      } catch (err) {
        console.error("Backend not reachable");
      }
    };
    fetchUsers();
  }, []);

  const handleLogin = async () => {
    if (!username.trim()) return alert("Enter a username");

    try {
      const res = await fetch("http://localhost:3001/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username }),
      });

      if (!res.ok) {
        const err = await res.json();
        return alert(err.error || "Login failed");
      }

      const data = await res.json();
      setUsers(data.users);
      setLoggedIn(true);
      setUsername("");
    } catch (err) {
      alert("Backend not reachable");
    }
  };

  const handleLogout = () => {
    setLoggedIn(false);
  };

  return (
    <div className="app-container">
      <h1>Secure Web App</h1>

      {!loggedIn ? (
        <div className="login-box">
          <input
            type="text"
            placeholder="Enter username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          <button onClick={handleLogin}>Login</button>
        </div>
      ) : (
        <div className="dashboard">
          <h2>Dashboard</h2>
          <p>Users currently logged in:</p>
          <ul>
            {users.map((user, idx) => (
              <li key={idx}>{user}</li>
            ))}
          </ul>
          <button onClick={handleLogout}>Logout</button>
        </div>
      )}
    </div>
  );
}

export default App;
