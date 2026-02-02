# ITSS AI Build Guide

This document provides instructions on how to build and run both the frontend and backend components of the ITSS AI application.

---

## 🚀 Backend (FastAPI)

The backend is built using FastAPI and Python.

### Prerequisites
- Python 3.11+
- Virtual environment (recommended)

### Set Up and Run
1.  **Navigate to backend directory:**
    ```bash
    cd backend
    ```
2.  **Create and activate virtual environment:**
    ```bash
    python -m venv venv
    # Windows:
    .\venv\Scripts\activate
    # Linux/Mac:
    source venv/bin/activate
    ```
3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
4.  **Configure Environment Variables:**
    Create a `.env` file in the `backend` directory with necessary configurations (DB URL, API Keys).
5.  **Run the application:**
    ```bash
    uvicorn main:app --host 0.0.0.0 --port 8000 --reload
    ```
    The API will be available at `http://localhost:8000`.

### Docker Build
```bash
docker build -t itss-ai-backend ./backend
docker run -p 8000:8000 itss-ai-backend
```

---

## 🎨 Frontend (React + Vite)

The frontend is a modern React application powered by Vite.

### Prerequisites
- Node.js (v20+ recommended)
- npm or yarn

### Set Up and Run
1.  **Navigate to frontend directory:**
    ```bash
    cd frontend
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    ```
3.  **Run development server:**
    ```bash
    npm run dev
    ```
    The app will be available at `http://localhost:5173`.

### Production Build
1.  **Build the project:**
    ```bash
    npm run build
    ```
    The production-ready files will be generated in the `dist` directory.
2.  **Preview the build:**
    ```bash
    npm run preview
    ```

### Docker Build
```bash
docker build -t itss-ai-frontend ./frontend
docker run -p 80:80 itss-ai-frontend
```

---

## 🛠️ Full Stack with Docker Compose
If you have Docker Compose installed, you can start the entire stack:
```bash
docker-compose up --build
```
