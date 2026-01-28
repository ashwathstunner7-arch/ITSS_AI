import { useState, useRef, useEffect } from 'react'
import {
  Send,
  Plus,
  MessageSquare,
  Settings,
  User,
  Bot,
  Zap,
  Loader2,
  Cpu,
  Image as ImageIcon,
  Folder,
  Monitor,
  FileText,
  Trash2,
  Paperclip,
  X,
  ChevronLeft,
  ChevronRight,
  ChevronDown,
  Code,
  Layout,
  Tag,
  Edit2,
  Check,
  Copy,
  ExternalLink
} from 'lucide-react'
import Editor from '@monaco-editor/react'
import api from './services/api'
import './App.css'

import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Login from './pages/Login'

// Rename old App to Chatbot
function Chatbot() {
  const [messages, setMessages] = useState([])
  // ... existing state ...
  const [input, setInput] = useState('')
  const [isSidebarOpen, setIsSidebarOpen] = useState(true)
  const [isRulesPanelOpen, setIsRulesPanelOpen] = useState(false)
  const [isModelSelectorOpen, setIsModelSelectorOpen] = useState(false)
  const [isAttachmentMenuOpen, setIsAttachmentMenuOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [activeChatId, setActiveChatId] = useState(null)
  const [conversations, setConversations] = useState([])
  const [rules, setRules] = useState([])
  const [attachments, setAttachments] = useState([])
  const [editingChatId, setEditingChatId] = useState(null)
  const [editTitle, setEditTitle] = useState('')
  const [activeCode, setActiveCode] = useState(null)
  const [isCodePanelOpen, setIsCodePanelOpen] = useState(false)

  const fileInputRef = useRef(null)
  const folderInputRef = useRef(null)
  const imageInputRef = useRef(null)

  const [selectedModel, setSelectedModel] = useState({
    id: 'gemini-1.5-flash',
    name: 'Gemini 1.5 Flash',
    provider: 'gemini'
  })

  const availableModels = [
    { id: 'gemini-1.5-flash', name: 'Gemini 1.5 Flash', provider: 'gemini' },
    { id: 'gemini-1.5-pro', name: 'Gemini 1.5 Pro', provider: 'gemini' },
    { id: 'gpt-4o', name: 'GPT-4o', provider: 'openai' },
    { id: 'gpt-4o-mini', name: 'GPT-4o Mini', provider: 'openai' },
  ]

  const messagesEndRef = useRef(null)

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  // Initial Fetch
  useEffect(() => {
    fetchRules()
    fetchChats()
  }, [])

  const fetchRules = async () => {
    try {
      const response = await api.get('/rules')
      setRules(response.data)
    } catch (error) {
      console.error("Failed to fetch rules:", error)
      // if (error.response?.status === 401) {
      //   window.location.href = '/login'
      // }
    }
  }

  const fetchChats = async () => {
    try {
      const response = await api.get('/chats')
      setConversations(response.data)
    } catch (error) {
      console.error("Failed to fetch chats:", error)
    }
  }

  const handleFileUpload = async (e) => {
    const files = Array.from(e.target.files)
    const newAttachments = await Promise.all(files.map(async file => {
      return new Promise((resolve) => {
        const reader = new FileReader()
        reader.onload = (e) => {
          resolve({
            id: Math.random().toString(36).substr(2, 9),
            name: file.name,
            type: file.type.startsWith('image/') ? 'image' : 'file',
            content: e.target.result,
            fileObj: file
          })
        }
        if (file.type.startsWith('image/')) {
          reader.readAsDataURL(file)
        } else {
          reader.readAsText(file)
        }
      })
    }))
    setAttachments(prev => [...prev, ...newAttachments])
    setIsAttachmentMenuOpen(false)
  }

  const removeAttachment = (id) => {
    setAttachments(prev => prev.filter(a => a.id !== id))
  }

  const fetchChatMessages = async (chatId) => {
    try {
      const response = await api.get(`/chats/${chatId}`)
      setMessages(response.data.messages)
      setActiveChatId(chatId)
    } catch (error) {
      console.error("Failed to fetch chat messages:", error)
    }
  }

  const handleSend = async () => {
    if ((!input.trim() && attachments.length === 0) || isLoading) return

    const userMsgContent = input
    const attachmentsData = attachments.map(a => ({
      name: a.name,
      type: a.type,
      content: a.content
    }))

    // Build the prompt including file info if any
    let finalPrompt = userMsgContent
    if (attachmentsData.length > 0) {
      const fileInfo = attachmentsData.map(a => `[Attached ${a.type}: ${a.name}]`).join('\n')
      finalPrompt = `${fileInfo}\n\n${userMsgContent}`
    }

    const newMessage = {
      id: Date.now(),
      role: 'user',
      content: userMsgContent,
      attachments: attachmentsData,
      timestamp: new Date()
    }
    setMessages(prev => [...prev, newMessage])
    setInput('')
    setAttachments([])
    setIsLoading(true)

    try {
      const response = await api.post('/invoke', {
        message: finalPrompt,
        chat_id: activeChatId,
        rules_applied: rules.filter(r => r.enabled).map(r => r.id),
        provider: selectedModel.provider,
        model: selectedModel.id
      })

      const botMsg = {
        id: response.data.id,
        role: 'bot',
        content: response.data.content,
        timestamp: new Date(response.data.created_at)
      }

      setMessages(prev => [...prev, botMsg])

      // Auto-detect code in bot message for side panel
      const codeMatch = response.data.content.match(/```(?:\w+)?\n([\s\S]*?)```/)
      if (codeMatch) {
        setActiveCode(codeMatch[1])
        setIsCodePanelOpen(true)
      }

      if (!activeChatId) {
        fetchChats()
      }
    } catch (error) {
      console.error("AI Error:", error)
      const errorMsg = {
        id: Date.now(),
        role: 'bot',
        content: "Sorry, I encountered an error connecting to the AI backend.",
        timestamp: new Date()
      }
      setMessages(prev => [...prev, errorMsg])
    } finally {
      setIsLoading(false)
    }
  }

  const toggleRule = async (id, enabled) => {
    const ruleToUpdate = rules.find(r => r.id === id)
    if (!ruleToUpdate) return

    try {
      const response = await api.patch(`/rules/${id}`, {
        ...ruleToUpdate,
        enabled: !enabled
      })
      setRules(rules.map(rule => rule.id === id ? response.data : rule))
    } catch (error) {
      console.error("Failed to toggle rule:", error)
    }
  }

  const handleNewChat = () => {
    setMessages([])
    setActiveChatId(null)
  }

  const handleLogout = () => {
    localStorage.removeItem('token')
    delete api.defaults.headers.common['Authorization']
    // window.location.href = '/login'
    setIsRulesPanelOpen(false) // Just close panel for now since we skip login
  }

  const handleDeleteChat = async (e, chatId) => {
    e.stopPropagation()
    if (!window.confirm("Are you sure you want to delete this chat?")) return
    try {
      await api.delete(`/chats/${chatId}`)
      setConversations(conversations.filter(c => c.id !== chatId))
      if (activeChatId === chatId) handleNewChat()
    } catch (error) {
      console.error("Failed to delete chat:", error)
    }
  }

  const handleRenameChat = async (e, chatId) => {
    e.stopPropagation()
    if (!editTitle.trim()) {
      setEditingChatId(null)
      return
    }
    try {
      const response = await api.patch(`/chats/${chatId}`, { title: editTitle })
      setConversations(conversations.map(c => c.id === chatId ? response.data : c))
      setEditingChatId(null)
    } catch (error) {
      console.error("Failed to rename chat:", error)
    }
  }

  const startEditing = (e, chat) => {
    e.stopPropagation()
    setEditingChatId(chat.id)
    setEditTitle(chat.title)
  }

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text)
    alert("Copied to clipboard!")
  }

  const MessageContent = ({ content }) => {
    const parts = content.split(/(```[\s\S]*?```)/g)
    return (
      <div className="message-content">
        {parts.map((part, i) => {
          if (part.startsWith('```')) {
            const match = part.match(/```(\w+)?\n([\s\S]*?)```/)
            const lang = match ? match[1] || 'code' : 'code'
            const code = match ? match[2] : part.replace(/```/g, '')
            return (
              <div key={i} className="code-block-container" onClick={() => {
                setActiveCode(code)
                setIsCodePanelOpen(true)
              }}>
                <div className="code-header">
                  <span className="code-lang">{lang}</span>
                  <button className="copy-btn" onClick={(e) => {
                    e.stopPropagation()
                    copyToClipboard(code)
                  }}>
                    <Copy size={12} /> Copy
                  </button>
                </div>
                <pre className="code-content-pre">
                  <code>{code}</code>
                </pre>
              </div>
            )
          }
          return <span key={i}>{part}</span>
        })}
      </div>
    )
  }

  return (
    <div className="app-container">
      {/* Sidebar */}
      <aside className={`sidebar glass ${isSidebarOpen ? 'open' : 'closed'}`}>
        <div className="sidebar-header">
          <div className="logo-section">
            <Zap className="accent-icon" size={24} fill="currentColor" />
            {isSidebarOpen && <h2>ITSS AI</h2>}
          </div>
          <button
            className="toggle-sidebar"
            onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          >
            {isSidebarOpen ? <ChevronLeft size={20} /> : <ChevronRight size={20} />}
          </button>
        </div>

        <button className="new-chat-btn" onClick={handleNewChat}>
          <Plus size={18} />
          {isSidebarOpen && <span>New Chat</span>}
        </button>

        <div className="sidebar-content">
          <div className="section-label">{isSidebarOpen && 'Recent Chats'}</div>
          <div className="conversations-list">
            {conversations.map(conv => (
              <div
                key={conv.id}
                className={`conv-item ${activeChatId === conv.id ? 'active' : ''}`}
                onClick={() => fetchChatMessages(conv.id)}
              >
                <MessageSquare size={16} />
                {isSidebarOpen && (
                  editingChatId === conv.id ? (
                    <input
                      className="edit-input"
                      value={editTitle}
                      onChange={(e) => setEditTitle(e.target.value)}
                      onBlur={(e) => handleRenameChat(e, conv.id)}
                      onKeyDown={(e) => e.key === 'Enter' && handleRenameChat(e, conv.id)}
                      autoFocus
                      onClick={e => e.stopPropagation()}
                    />
                  ) : (
                    <>
                      <span>{conv.title}</span>
                      <div className="chat-actions">
                        <button className="action-btn" onClick={(e) => startEditing(e, conv)}>
                          <Edit2 size={12} />
                        </button>
                        <button className="action-btn delete" onClick={(e) => handleDeleteChat(e, conv.id)}>
                          <Trash2 size={12} />
                        </button>
                      </div>
                    </>
                  )
                )}
              </div>
            ))}
          </div>

          <div className="section-label">{isSidebarOpen && 'Tools'}</div>
          <div className="conversations-list">
            <div className={`conv-item ${isRulesPanelOpen ? 'active' : ''}`} onClick={() => setIsRulesPanelOpen(true)}>
              <Layout size={16} />
              {isSidebarOpen && <span>Rule Management</span>}
            </div>
            <div className="conv-item" onClick={handleLogout}>
              <Settings size={16} />
              {isSidebarOpen && <span>Logout</span>}
            </div>
          </div>
        </div>

        <div className="sidebar-footer">
          <div className="user-profile">
            <div className="avatar">
              <User size={20} />
            </div>
            {isSidebarOpen && (
              <div className="user-info">
                <span className="user-name">Ashwanth</span>
                <span className="user-status">Online</span>
              </div>
            )}
            {isSidebarOpen && <Settings size={18} className="settings-icon" />}
          </div>
        </div>
      </aside>

      {/* Main Chat Area */}
      <main className="main-content">
        <header className="chat-header glass">
          <div className="header-info">
            <h3>{activeChatId ? conversations.find(c => c.id === activeChatId)?.title : 'New Conversation'}</h3>
            <div className="model-selector-wrapper">
              <button
                className="model-badge selector"
                onClick={() => setIsModelSelectorOpen(!isModelSelectorOpen)}
              >
                <Cpu size={14} />
                <span>{selectedModel.name}</span>
                <ChevronDown size={14} className={isModelSelectorOpen ? 'rotate' : ''} />
              </button>

              {isModelSelectorOpen && (
                <div className="model-dropdown glass fade-in">
                  {availableModels.map(model => (
                    <div
                      key={model.id}
                      className={`model-option ${selectedModel.id === model.id ? 'active' : ''}`}
                      onClick={() => {
                        setSelectedModel(model)
                        setIsModelSelectorOpen(false)
                      }}
                    >
                      <div className="option-info">
                        <span className="option-name">{model.name}</span>
                        <span className="option-provider">{model.provider}</span>
                      </div>
                      {selectedModel.id === model.id && <Zap size={14} className="accent-icon" />}
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
          <div className="header-actions">
            <Tag size={20} />
            <Settings size={20} onClick={() => setIsRulesPanelOpen(true)} />
          </div>
        </header>

        <div className="messages-container">
          {messages.length === 0 && !isLoading && (
            <div className="welcome-screen fade-in">
              <div className="welcome-logo">
                <Zap size={48} className="accent-icon" fill="currentColor" />
              </div>
              <h1>How can I help you today?</h1>
              <p>ITSS AI is ready to assist with code, design, and logic.</p>
            </div>
          )}
          {messages.map((msg) => (
            <div key={msg.id} className={`message-wrapper ${msg.role}`}>
              <div className="message-icon">
                {msg.role === 'bot' ? <Bot size={20} /> : <User size={20} />}
              </div>
              <div className="message-bubble glass fade-in">
                <MessageContent content={msg.content} />
                <div className="message-time">
                  <button className="copy-btn" onClick={() => copyToClipboard(msg.content)}>
                    <Copy size={12} /> Copy
                  </button>
                  {new Date(msg.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                </div>
              </div>
            </div>
          ))}
          {isLoading && (
            <div className="message-wrapper bot">
              <div className="message-icon">
                <Bot size={20} />
              </div>
              <div className="message-bubble glass loading">
                <Loader2 className="animate-spin" size={20} />
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        <footer className="chat-input-container">
          {attachments.length > 0 && (
            <div className="attachments-preview-bar glass fade-in">
              {attachments.map(file => (
                <div key={file.id} className="attachment-preview-item glass">
                  {file.type === 'image' ? (
                    <img src={file.content} alt={file.name} />
                  ) : (
                    <FileText size={16} />
                  )}
                  <span className="file-name">{file.name}</span>
                  <button className="remove-btn" onClick={() => removeAttachment(file.id)}>
                    <X size={12} />
                  </button>
                </div>
              ))}
            </div>
          )}
          <div className="input-wrapper glass">
            <div className="input-actions-left">
              <button
                className="input-action-btn"
                title="Attach Image"
                onClick={() => imageInputRef.current?.click()}
              >
                <ImageIcon size={20} />
              </button>

              <div className="attachment-menu-wrapper">
                <button
                  className={`input-action-btn ${isAttachmentMenuOpen ? 'active' : ''}`}
                  onClick={() => setIsAttachmentMenuOpen(!isAttachmentMenuOpen)}
                  title="Attach Files"
                >
                  <Paperclip size={20} />
                </button>

                {isAttachmentMenuOpen && (
                  <div className="attachment-dropdown glass fade-in">
                    <button className="menu-item" onClick={() => fileInputRef.current?.click()}>
                      <FileText size={18} />
                      <span>Select Files</span>
                    </button>
                    <button className="menu-item" onClick={() => folderInputRef.current?.click()}>
                      <Monitor size={18} />
                      <span>Select Workspace Folder</span>
                    </button>
                  </div>
                )}
              </div>
            </div>

            <input
              type="file"
              ref={fileInputRef}
              style={{ display: 'none' }}
              multiple
              onChange={(e) => handleFileUpload(e)}
            />
            <input
              type="file"
              ref={folderInputRef}
              style={{ display: 'none' }}
              webkitdirectory="true"
              directory="true"
              onChange={(e) => handleFileUpload(e)}
            />
            <input
              type="file"
              ref={imageInputRef}
              style={{ display: 'none' }}
              accept="image/*"
              multiple
              onChange={(e) => handleFileUpload(e)}
            />

            <textarea
              placeholder="Ask anything..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault()
                  handleSend()
                }
              }}
              rows={1}
              disabled={isLoading}
            />
            <button
              className={`send-btn ${(input.trim() || attachments.length > 0) && !isLoading ? 'active' : ''}`}
              onClick={handleSend}
              disabled={(!input.trim() && attachments.length === 0) || isLoading}
            >
              {isLoading ? <Loader2 className="animate-spin" size={20} /> : <Send size={20} />}
            </button>
          </div>
        </footer>
      </main>

      {/* Code Canvas Panel */}
      {isCodePanelOpen && (
        <aside className="code-canvas-panel fade-in">
          <div className="canvas-header">
            <div className="canvas-tabs">
              <div className="canvas-tab active">
                <Code size={16} />
                <span>Source Code</span>
              </div>
            </div>
            <div className="canvas-actions">
              <button className="action-btn" title="Copy Code" onClick={() => copyToClipboard(activeCode)}>
                <Copy size={16} />
              </button>
              <button className="action-btn" title="Close Panel" onClick={() => setIsCodePanelOpen(false)}>
                <X size={20} />
              </button>
            </div>
          </div>
          <div className="canvas-content">
            <Editor
              height="100%"
              defaultLanguage="python"
              theme="vs-dark"
              value={activeCode}
              options={{
                readOnly: true,
                minimap: { enabled: false },
                fontSize: 14,
                fontFamily: 'JetBrains Mono',
                scrollBeyondLastLine: false,
                padding: { top: 20 }
              }}
            />
          </div>
        </aside>
      )}

      {/* Rules Panel Overlay */}
      {isRulesPanelOpen && (
        <div className="panel-overlay" onClick={() => setIsRulesPanelOpen(false)}>
          <div className="rules-panel glass fade-in" onClick={e => e.stopPropagation()}>
            <div className="panel-header">
              <div className="header-title">
                <Layout className="accent-icon" size={24} />
                <h2>Rule Management</h2>
              </div>
              <button className="close-btn" onClick={() => setIsRulesPanelOpen(false)}>
                <X size={24} />
              </button>
            </div>

            <div className="panel-content">
              <p className="panel-desc">Define instructions and behavioral constraints for the AI.</p>

              <div className="rules-list">
                {rules.map(rule => (
                  <div key={rule.id} className={`rule-card glass ${rule.enabled ? 'enabled' : ''}`}>
                    <div className="rule-info">
                      <div className="rule-header">
                        <h4>{rule.title}</h4>
                        <span className={`rule-badge ${rule.type}`}>{rule.type}</span>
                      </div>
                      <p>{rule.description}</p>
                    </div>
                    <div className="rule-action">
                      <label className="switch">
                        <input
                          type="checkbox"
                          checked={rule.enabled}
                          onChange={() => toggleRule(rule.id, rule.enabled)}
                        />
                        <span className="slider"></span>
                      </label>
                    </div>
                  </div>
                ))}
              </div>

              <button className="add-rule-btn glass">
                <Plus size={18} />
                <span>Add New Rule (Feature coming soon)</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

function App() {
  // const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('token'))
  const [isAuthenticated, setIsAuthenticated] = useState(true)

  const handleLogin = () => {
    setIsAuthenticated(true)
  }

  // Inject token into API on mount if exists
  useEffect(() => {
    const token = localStorage.getItem('token')
    if (token) {
      api.defaults.headers.common['Authorization'] = `Bearer ${token}`
    }
  }, [])

  return (
    <Router>
      <Routes>
        <Route
          path="/login"
          element={isAuthenticated ? <Navigate to="/" /> : <Login onLogin={handleLogin} />}
        />
        <Route
          path="/"
          element={isAuthenticated ? <Chatbot /> : <Navigate to="/login" />}
        />
        <Route path="*" element={<Navigate to={isAuthenticated ? "/" : "/login"} />} />
      </Routes>
    </Router>
  )
}

export default App
