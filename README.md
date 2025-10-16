# 🔒 Secure WebApp

A full-stack web application built with **React (frontend)** and **Node.js + Express (backend)**, featuring **automated CI/CD deployment** using **GitHub Actions** and **GitHub Pages**.

---

## 🚀 Features
- 🌐 Frontend: React + Vite
- ⚙️ Backend: Node.js + Express
- 🔄 CI/CD with GitHub Actions
- 📦 Automatic frontend deployment on GitHub Pages
- 🔑 Secure deployment using GitHub tokens or SSH keys

---

## 🏗️ Project Structure
2️⃣ Backend Setup
cd backend
npm install
node server.js


Backend runs by default on:
👉 http://localhost:5000

3️⃣ Frontend Setup

Open a new terminal window and run:

cd frontend
npm install
npm start


Frontend runs by default on:
👉 http://localhost:3000

If the backend is running, the frontend can make API calls to it.

🔄 CI/CD Deployment (GitHub Actions)

This project uses GitHub Actions for automatic frontend deployment to GitHub Pages.

✅ Deployment Workflow

Every time you push changes to the main branch, GitHub Actions:

Installs dependencies

Builds the React app (npm run build)

