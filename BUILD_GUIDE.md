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

---

## 🛠️ Troubleshooting & Manual Fixes

### ModuleNotFoundError or ImportError (e.g., `pydantic_core`, `cygrpc`)
These errors often occur if the Python version is incompatible (like Python 3.14) or the virtual environment is corrupted.

**Manual Fix Steps:**
1.  **Stop all running processes** (Ctrl+C in your terminals).
2.  **Delete the existing virtual environment**:
    ```powershell
    # Inside the backend directory
    rm -Recurse -Force venv
    ```
3.  **Recreate using a stable Python version (3.11 or 3.12)**:
    ```powershell
    # If you have multiple versions, specify 3.12
    py -3.12 -m venv venv
    ```
4.  **Activate and re-install dependencies**:
    ```powershell
    .\venv\Scripts\activate
    pip install -r requirements.txt
    ```
5.  **Restart the server**:
    ```powershell
    uvicorn main:app --host 0.0.0.0 --port 8000 --reload
    ```

### Database Schema Mismatch
If you see errors related to column types or missing columns after an update:
1.  **Backup your data** (if important).
2.  **Delete the local database file** (e.g., `itss_ai.db`).
3.  **Run the migration or seed script**:
    ```powershell
    python migrate.py  # or seed_db.py
    ```
