import { useEffect, useState } from "react";

function App() {
  const [message, setMessage] = useState("Loading...");
  const [users, setUsers] = useState([]);

  // Fetch backend message
  useEffect(() => {
    fetch("http://localhost:3001/")
      .then(res => res.json())
      .then(data => setMessage(data.message))
      .catch(() => setMessage("Backend not reachable"));
  }, []);

  // Fetch backend users
  useEffect(() => {
    fetch("http://localhost:3001/api/users")
      .then(res => res.json())
      .then(data => setUsers(data))
      .catch(() => setUsers([]));
  }, []);

  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>{message}</h1>
      <h2>Users:</h2>
      <ul>
        {users.map(u => (
          <li key={u.id}>{u.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
