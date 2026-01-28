import { useState } from 'react'
import { Zap, User, Lock, Loader2, ArrowRight } from 'lucide-react'
import api from '../services/api'
import './Login.css'

function Login({ onLogin }) {
    const [username, setUsername] = useState('')
    const [password, setPassword] = useState('')
    const [isLoading, setIsLoading] = useState(false)
    const [error, setError] = useState('')

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (!username || !password) return

        setIsLoading(true)
        setError('')

        try {
            const formData = new FormData()
            formData.append('username', username)
            formData.append('password', password)

            const response = await api.post('/auth/login', formData)

            const { access_token } = response.data
            localStorage.setItem('token', access_token)
            api.defaults.headers.common['Authorization'] = `Bearer ${access_token}`

            onLogin()
        } catch (err) {
            console.error("Login failed:", err)
            setError(err.response?.data?.detail || "Invalid username or password")
        } finally {
            setIsLoading(false)
        }
    }

    return (
        <div className="login-container">
            <div className="login-blob"></div>
            <div className="login-blob blob-2"></div>

            <div className="login-card glass fade-in">
                <div className="login-header">
                    <div className="login-logo">
                        <Zap size={32} fill="currentColor" />
                    </div>
                    <h1>Welcome Back</h1>
                    <p>Login to access your AI workspace</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                    {error && <div className="login-error">{error}</div>}

                    <div className="input-group">
                        <User size={20} className="input-icon" />
                        <input
                            type="text"
                            placeholder="Username"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            disabled={isLoading}
                            required
                        />
                    </div>

                    <div className="input-group">
                        <Lock size={20} className="input-icon" />
                        <input
                            type="password"
                            placeholder="Password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            disabled={isLoading}
                            required
                        />
                    </div>

                    <button type="submit" className="login-submit-btn" disabled={isLoading}>
                        {isLoading ? (
                            <Loader2 className="animate-spin" size={20} />
                        ) : (
                            <>
                                <span>Sign In</span>
                                <ArrowRight size={20} />
                            </>
                        )}
                    </button>
                </form>

                <div className="login-footer">
                    <p>Don't have an account? <span>Contact Administrator</span></p>
                </div>
            </div>
        </div>
    )
}

export default Login
