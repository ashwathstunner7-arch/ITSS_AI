# ITSS AI: Free Deployment Guide

This guide describes how to deploy your ITSS AI application using entirely free-tier cloud services.

## 🚀 Architecture Overview

| Layer | Service | Why? |
| :--- | :--- | :--- |
| **Frontend** | [Netlify](https://www.netlify.com/) | Easiest for React/Vite, great CDN. |
| **Backend** | [Render](https://render.com/) | Supports Dockerized FastAPI, free web services. |
| **Database** | [Neon](https://neon.tech/) | Modern serverless PostgreSQL with a generous free plan. |
| **AI Processing**| [Google AI Studio](https://aistudio.google.com/) | Gemini 1.5 Flash is currently free to use with high rate limits. |

---

## 🛠️ Step 1: Database Setup (Neon)

1. **Sign up**: Go to [Neon.tech](https://neon.tech/) and create a free account.
2. **Project**: Create a new project (e.g., `itss-ai-db`).
3. **Connection String**: Under the "Dashboard" or "Connection Details", copy the connection string.
   - It looks like: `postgresql://user:password@something.neon.tech/neondb?sslmode=require`
4. **Initialize**: You can use the `migrate.py` or `seed_db.py` in your backend (once configured) to create tables.

---

## 🏗️ Step 2: Backend Deployment (Render)

1. **GitHub**: Push your code to a GitHub repository.
2. **Render**: Sign up at [Render.com](https://render.com/).
3. **New Web Service**:
   - Connect your GitHub repo.
   - **Name**: `itss-ai-backend`
   - **Environment**: `Docker` (Render will detect the `Dockerfile` in `/backend`).
   - **Region**: Choose one closest to you (e.g., Singapore or Oregon).
4. **Environment Variables**: Add the following:
   - `DATABASE_URL`: Your Neon connection string.
   - `GOOGLE_API_KEY`: Your Gemini API key from [AI Studio](https://aistudio.google.com/).
   - `PORT`: `8000` (Render handles this, but good to be explicit).
5. **Deploy**: Render will build the Docker container and start your FastAPI server.
   - *Note: Free instances sleep after 15 mins of inactivity. It will take ~30s to wake up on the first hit.*

---

## 🎨 Step 3: Frontend Deployment (Netlify)

1. **Netlify**: Sign up at [Netlify.com](https://netlify.com/).
2. **Add New Site**: Import from GitHub.
3. **Site Settings**:
   - **Base directory**: `frontend`
   - **Build command**: `npm run build`
   - **Publish directory**: `dist`
4. **Environment Variables**:
   - `VITE_API_URL`: Use your Render backend URL (e.g., `https://itss-ai-backend.onrender.com`).
5. **Deploy**: Netlify will build and host your site. You'll get a URL like `itss-ai.netlify.app`.

---

## 🧪 Step 4: Final Configuration

1. **CORS**: Ensure your backend's `main.py` (or CORS config) allows your Netlify URL. Initially, you can use `["*"]` for testing.
2. **Auth**: Update `isAuthenticated` logic in `App.jsx` as mentioned in the [INTEGRATION_GUIDE.md](file:///f:/AI_TOOL/INTEGRATION_GUIDE.md) if you are ready to enable security.

---

## ⚠️ Important Notes
- **Cold Starts**: Render's free tier spins down. Use a tool like [Cron-job.org](https://cron-job.org/) to hit your `/health` endpoint every 10 minutes to keep it awake if needed.
- **Data Persistence**: Neon PostgreSQL persists data, so your chats and users will remain even if the backend restarts.
