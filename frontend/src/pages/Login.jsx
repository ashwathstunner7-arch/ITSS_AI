import { useState } from 'react'
import { User, Lock, Loader2, ArrowRight, Eye, EyeOff } from 'lucide-react'
import api from '../services/api'
import logo from '../assets/logo.png'
import './Login.css'

function Login({ onLogin, isPluginMode }) {
    const [username, setUsername] = useState('')
    const [password, setPassword] = useState('')
    const [isLoading, setIsLoading] = useState(false)
    const [error, setError] = useState('')
    const [showPassword, setShowPassword] = useState(false)

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
            try {
                localStorage.setItem('token', access_token)
            } catch (e) {
                console.warn('LocalStorage write blocked in Login:', e)
            }
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
        <div className={`login-container ${isPluginMode ? 'is-plugin' : ''}`} style={isPluginMode ? { background: '#0a0a0c', minHeight: '100vh' } : {}}>
            <div className="login-blob"></div>
            <div className="login-blob blob-2"></div>

            <div className="login-card glass fade-in" style={isPluginMode ? { background: '#1c1c1e', opacity: 1, visibility: 'visible' } : {}}>
                <div className="login-header">
                    <div className="login-logo">
                        <img src={logo} alt="Logo" className="login-logo-img" />
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
                            type={showPassword ? "text" : "password"}
                            placeholder="Password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            disabled={isLoading}
                            required
                        />
                        <button
                            type="button"
                            className="password-toggle"
                            onClick={() => setShowPassword(!showPassword)}
                            disabled={isLoading}
                        >
                            {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                        </button>
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
