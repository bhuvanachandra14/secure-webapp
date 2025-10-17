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
