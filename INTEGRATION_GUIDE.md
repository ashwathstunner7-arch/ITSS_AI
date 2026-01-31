# ITSS AI Integration Guide: Sign-in Logic & Rule Fetching

This guide explains how to implement user authentication (Sign-in) and fetch/manage rule data from a database in the ITSS AI application.

## 1. Which Database to Use?

Depending on your requirements, you can choose from the following:

- **SQLite (Currently used):** Best for development and small-scale local applications. It's a file-based database that requires no separate server setup.
- **Firebase:** An excellent choice for rapid development. **Firebase Auth** handles sign-in (Google, Email, etc.) effortlessly, and **Firestore** provides a flexible NoSQL database for rules and chats. It also handles real-time updates and hosting.
- **PostgreSQL:** The industry standard for production web applications. It offers advanced features, strong data integrity, and excellent scalability.
- **MySQL/MariaDB:** A popular alternative to PostgreSQL, known for its performance and ease of use.
- **MongoDB:** A NoSQL database, useful if your "rule" data is highly dynamic or doesn't fit well into a tabular structure.

**Recommendation:** Stick with **PostgreSQL** for production deployment. Use **SQLite** for local development to keep things simple.

---

## 2. Sign-in Logic Implementation

### Backend (FastAPI)
The backend should provide an `/auth/login` endpoint that:
1. Receives `username` and `password`.
2. Validates credentials against the `users` table.
3. Returns a JWT (JSON Web Token) upon success.

### Frontend (React/Vite)
1. **Login Form:** Capture `username` and `password` from the user.
2. **API Call:** Use `fetch` or `axios` to POST the data to `http://localhost:8000/auth/login`.
3. **Token Management:**
   - On success, store the JWT in `localStorage` or a Secure Cookie.
   - Attach this token to the `Authorization` header for all subsequent API requests: `Authorization: Bearer <your_token>`.
4. **Redirection:** Redirect the user to the dashboard or main chat interface.

---

## 3. Rule File Data Fetching

### Database Schema
A `rules` table should store your configuration rules:
- `id`: Unique identifier.
- `title`: Short name of the rule.
- `description`: Detailed explanation.
- `enabled`: Boolean flag.
- `type`: Category (e.g., 'logic', 'style').

### Logic Flow
1. **Backend Endpoint:** Create a `GET /rules/` endpoint that queries the database and returns a list of active rules.
2. **Frontend Fetching:**
   - In your main application component (e.g., `App.jsx` or a specialized `RulesManager.jsx`), fetch the rules on mount using a `useEffect` hook.
   - Use these rules to guide the AI's behavior or display them in the UI for user management.
3. **AI Integration:** When sending a prompt to the AI, include the *enabled* rules as part of the system instructions to ensure the AI follows your project's guidelines.

---

## 5. Current Implementation Status

Good news! Most of the logic for sign-in and rules fetching is already implemented in your codebase, but it is currently bypassed for development convenience.

### Activation Steps:

1. **In `App.jsx`:**
   - Change `const [isAuthenticated, setIsAuthenticated] = useState(true)` to `useState(!!localStorage.getItem('token'))`.
   - This will force the user to log in if no token is found.
2. **In the Backend:**
   - Ensure you have a user in the `users` table. You can use the `diag_db.py` or a seed script to add one.
3. **Rules Fetching:**
   - The `fetchRules` function in `App.jsx` is already set up to call `api.get('/rules')`. Make sure your backend allows this request (CORS and Auth).

---

## 6. What Needs to be Done (Next Steps)

1. **Database Migration:** Ensure the `rules` and `users` tables are created in your chosen DB.
2. **Seed Data:** Add initial rules and at least one admin user to the database.
3. **Activate Login:** Remove the hardcoded `true` value for `isAuthenticated` in `App.jsx`.
4. **Test:** Verify that logging in correctly sets the token and fetches the rules.
