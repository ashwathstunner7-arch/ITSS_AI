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
  Mic,
  MicOff,
  FileText,
  Trash2,
  Paperclip,
  X,
  ChevronLeft,
  ChevronRight,
  ChevronDown,
  Code,
  Layout,
  ShieldCheck,
  Edit2,
  Check,
  Copy,
  ExternalLink
} from 'lucide-react'
import Editor from '@monaco-editor/react'
import api from './services/api'
import './App.css'

import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import { vscDarkPlus } from 'react-syntax-highlighter/dist/esm/styles/prism'

import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Login from './pages/Login'

// Rename old App to Chatbot
function Chatbot() {
  const [user, setUser] = useState(null)
  const [messages, setMessages] = useState([])
  const [input, setInput] = useState('')
  const [isSidebarOpen, setIsSidebarOpen] = useState(true)
  const [isRulesPanelOpen, setIsRulesPanelOpen] = useState(false)
  const [isTaggingRulesOpen, setIsTaggingRulesOpen] = useState(false)
  const [isModelSelectorOpen, setIsModelSelectorOpen] = useState(false)
  const [isAttachmentMenuOpen, setIsAttachmentMenuOpen] = useState(false)
  const [isListening, setIsListening] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [activeChatId, setActiveChatId] = useState(null)
  const [conversations, setConversations] = useState([])
  const [rules, setRules] = useState([])
  const [attachedRules, setAttachedRules] = useState([])
  const [attachments, setAttachments] = useState([])
  const [editingChatId, setEditingChatId] = useState(null)
  const [editTitle, setEditTitle] = useState('')
  const [activeCode, setActiveCode] = useState(null)
  const [isCodePanelOpen, setIsCodePanelOpen] = useState(false)
  const [isAddRuleModalOpen, setIsAddRuleModalOpen] = useState(false)
  const [newRule, setNewRule] = useState({ title: '', category: 'logic', description: '', rule_content: '' })
  const [sidebarWidth, setSidebarWidth] = useState(280)
  const [codePanelWidth, setCodePanelWidth] = useState(450)
  const [isResizingSidebar, setIsResizingSidebar] = useState(false)
  const [isResizingCodePanel, setIsResizingCodePanel] = useState(false)
  const [sidebarCollapsedWidth, setSidebarCollapsedWidth] = useState(80)

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
    fetchUserData()
    fetchRules()
    fetchChats()
  }, [])

  const fetchUserData = async () => {
    try {
      const response = await api.get('/auth/me')
      setUser(response.data)
    } catch (error) {
      console.error("Failed to fetch user data:", error)
    }
  }

  const fetchRules = async () => {
    try {
      const response = await api.get('/rules')
      setRules(response.data)
    } catch (error) {
      console.error("Failed to fetch rules:", error)
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

  const handleVoiceInput = () => {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (!SpeechRecognition) {
      alert("Your browser does not support voice recognition.")
      return
    }

    const recognition = new SpeechRecognition()
    recognition.continuous = false
    recognition.interimResults = false

    recognition.onstart = () => {
      setIsListening(true)
    }

    recognition.onresult = (event) => {
      const transcript = event.results[0][0].transcript
      setInput(prev => prev ? `${prev} ${transcript}` : transcript)
      setIsListening(false)
    }

    recognition.onerror = (event) => {
      console.error("Speech recognition error:", event.error)
      setIsListening(false)
    }

    recognition.onend = () => {
      setIsListening(false)
    }

    if (isListening) {
      recognition.stop()
    } else {
      recognition.start()
    }
  }

  const removeAttachment = (id) => {
    setAttachments(prev => prev.filter(a => a.id !== id))
  }

  const toggleAttachedRule = (ruleId) => {
    setAttachedRules(prev =>
      prev.includes(ruleId)
        ? prev.filter(id => id !== ruleId)
        : [...prev, ruleId]
    )
  }

  // Resizing Handlers
  const startSidebarResize = (e) => {
    e.preventDefault()
    setIsResizingSidebar(true)
  }

  const startCodePanelResize = (e) => {
    e.preventDefault()
    setIsResizingCodePanel(true)
  }

  useEffect(() => {
    const handleMouseMove = (e) => {
      if (isResizingSidebar) {
        const newWidth = Math.max(80, Math.min(600, e.clientX))
        if (newWidth <= 120) {
          setIsSidebarOpen(false)
          setSidebarWidth(280) // reset the "open" width for when it re-opens
        } else {
          setIsSidebarOpen(true)
          setSidebarWidth(newWidth)
        }
      }
      if (isResizingCodePanel) {
        const newWidth = Math.max(300, Math.min(800, window.innerWidth - e.clientX))
        setCodePanelWidth(newWidth)
      }
    }

    const handleMouseUp = () => {
      setIsResizingSidebar(false)
      setIsResizingCodePanel(false)
    }

    if (isResizingSidebar || isResizingCodePanel) {
      document.addEventListener('mousemove', handleMouseMove)
      document.addEventListener('mouseup', handleMouseUp)
      document.body.style.cursor = 'col-resize'
    }

    return () => {
      document.removeEventListener('mousemove', handleMouseMove)
      document.removeEventListener('mouseup', handleMouseUp)
      document.body.style.cursor = 'default'
    }
  }, [isResizingSidebar, isResizingCodePanel])

  const getFriendlyTitle = (title) => {
    if (!title) return 'New Conversation'
    return title.replace(/\[Attached\s+(image|file|folder):\s+.*?\]/g, 'Prompt Reference').trim()
  }

  const removeAttachedRule = (ruleId) => {
    setAttachedRules(prev => prev.filter(id => id !== ruleId))
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

  const handleNewChat = () => {
    setActiveChatId(null)
    setMessages([])
    setAttachedRules([])
    setAttachments([])
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
        rules_applied: attachedRules,
        attachments: attachmentsData,
        provider: selectedModel.provider,
        model: selectedModel.id
      })

      const botMessage = {
        id: response.data.id,
        role: 'bot',
        content: response.data.content,
        attachments: response.data.attachments,
        timestamp: response.data.created_at
      }

      setMessages(prev => [...prev, botMessage])

      if (!activeChatId && response.data.chat_id) {
        setActiveChatId(response.data.chat_id)
        fetchChats()
      }
    } catch (error) {
      console.error("Failed to send message:", error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleLogout = () => {
    localStorage.removeItem('token')
    delete api.defaults.headers.common['Authorization']
    window.location.href = '/login'
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
  }

  const toggleRule = async (id, currentStatus) => {
    try {
      const newStatus = currentStatus === 'active' ? 'inactive' : 'active'
      await api.patch(`/rules/${id}`, { status: newStatus })
      setRules(rules.map(r => r.id === id ? { ...r, status: newStatus } : r))
    } catch (error) {
      console.error("Failed to toggle rule:", error)
    }
  }

  const handleAddRule = async () => {
    if (!newRule.title.trim() || !newRule.rule_content.trim()) return
    try {
      const response = await api.post('/rules', newRule)
      setRules([...rules, response.data])
      setNewRule({ title: '', category: 'logic', description: '', rule_content: '' })
      setIsAddRuleModalOpen(false)
    } catch (error) {
      console.error("Failed to add rule:", error)
    }
  }

  const handleDeleteRule = async (id) => {
    if (!window.confirm("Are you sure you want to delete this rule? This will also remove the generated .md file.")) return
    try {
      await api.delete(`/rules/${id}`)
      setRules(rules.filter(r => r.id !== id))
    } catch (error) {
      console.error("Failed to delete rule:", error)
    }
  }

  const MessageContent = ({ content }) => {
    if (!content) return null
    // Strip [Attached ...] tags from the content
    const cleanContent = content.replace(/\[Attached\s+(image|file|folder):\s+.*?\]\n?/g, '').trim()
    if (!cleanContent) return null

    return (
      <div className="message-content">
        <ReactMarkdown
          remarkPlugins={[remarkGfm]}
          components={{
            code({ node, inline, className, children, ...props }) {
              const match = /language-(\w+)/.exec(className || '')
              const language = match ? match[1] : ''
              const codeString = String(children).replace(/\n$/, '')

              return !inline ? (
                <div className="code-block-container" onClick={(e) => {
                  e.stopPropagation()
                  setActiveCode(codeString)
                  setIsCodePanelOpen(true)
                }}>
                  <div className="code-header">
                    <span className="code-lang">{language || 'code'}</span>
                    <button className="copy-btn" onClick={(e) => {
                      e.stopPropagation()
                      copyToClipboard(codeString)
                    }}>
                      <Copy size={12} /> Copy
                    </button>
                  </div>
                  <SyntaxHighlighter
                    {...props}
                    style={vscDarkPlus}
                    language={language || 'text'}
                    PreTag="div"
                    className="syntax-highlighter"
                  >
                    {codeString}
                  </SyntaxHighlighter>
                </div>
              ) : (
                <code className="inline-code" {...props}>
                  {children}
                </code>
              )
            }
          }}
        >
          {cleanContent}
        </ReactMarkdown>
      </div>
    )
  }

  return (
    <div className={`app-container ${!isSidebarOpen ? 'sidebar-hidden' : ''} ${isResizingSidebar || isResizingCodePanel ? 'is-resizing' : ''}`} style={{ '--sidebar-width': isSidebarOpen ? `${sidebarWidth}px` : '80px', '--sidebar-collapsed-width': '80px' }}>
      {/* Sidebar */}
      <aside className={`sidebar glass ${isSidebarOpen ? 'open' : 'closed'}`} style={{ width: isSidebarOpen ? `${sidebarWidth}px` : '80px' }}>
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
          </div>
        </div>

        <div className="sidebar-footer">
          <div className="user-profile">
            <div className="avatar">
              <User size={20} />
            </div>
            {isSidebarOpen && user && (
              <div className="user-info">
                <span className="user-name">{user.username}</span>
                <span className="user-status">{user.emailaddress || 'Online'}</span>
              </div>
            )}
            <div className="profile-actions">
              {isSidebarOpen && <span className="rule-access-badge">{user?.ruleaccess}</span>}
              <button
                className="logout-icon-btn"
                title="Logout"
                onClick={handleLogout}
              >
                <X size={18} />
              </button>
            </div>
          </div>
        </div>
      </aside>

      {isSidebarOpen && (
        <div className="resizer-handle sidebar-resizer" onMouseDown={startSidebarResize} />
      )}

      {/* Main Chat Area */}
      <main className="main-content">
        <header className="chat-header glass">
          <div className="header-info">
            <h3>{activeChatId ? getFriendlyTitle(conversations.find(c => c.id === activeChatId)?.title) : 'New Conversation'}</h3>
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
            {/* Icons removed as per user request */}
          </div>
        </header>

        <div className="messages-container">
          <div className="messages-content-wrapper">
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
                  {msg.attachments && msg.attachments.length > 0 && (
                    <div className="message-attachments-display">
                      {msg.attachments.map((at, i) => (
                        at.type === 'image' && (
                          <img key={i} src={at.content} alt={at.name} className="bubble-image" />
                        )
                      ))}
                    </div>
                  )}
                  <MessageContent content={msg.content} />
                  <div className="message-time">
                    <button className="copy-btn" onClick={() => copyToClipboard(msg.content)}>
                      <Copy size={12} /> Copy
                    </button>
                    {new Date(msg.timestamp || msg.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
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
        </div>

        <footer className="chat-input-container">
          {attachedRules.length > 0 && (
            <div className="attached-rules-bar fade-in">
              {attachedRules.map(ruleId => {
                const rule = rules.find(r => r.id === ruleId)
                return (
                  <div key={ruleId} className="attached-rule-tag">
                    <ShieldCheck size={12} />
                    <span>{rule?.title}</span>
                    <button onClick={() => removeAttachedRule(ruleId)}>
                      <X size={10} />
                    </button>
                  </div>
                )
              })}
            </div>
          )}
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

              <div className="tag-rules-wrapper">
                <button
                  className={`input-action-btn ${isTaggingRulesOpen ? 'active' : ''} ${attachedRules.length > 0 ? 'has-rules' : ''}`}
                  onClick={() => setIsTaggingRulesOpen(!isTaggingRulesOpen)}
                  title="Attach Rules"
                >
                  <ShieldCheck size={20} />
                </button>

                {isTaggingRulesOpen && (
                  <div className="rules-tag-dropdown glass fade-in">
                    <div className="dropdown-header">
                      <span>Select Rules to Apply</span>
                      <button onClick={() => setIsTaggingRulesOpen(false)}><X size={14} /></button>
                    </div>
                    <div className="rules-scrollable">
                      {rules.map(rule => (
                        <button
                          key={rule.id}
                          className={`rule-select-item ${attachedRules.includes(rule.id) ? 'selected' : ''}`}
                          onClick={() => toggleAttachedRule(rule.id)}
                        >
                          <div className="rule-item-check">
                            {attachedRules.includes(rule.id) ? <Check size={14} /> : <div className="dot" />}
                          </div>
                          <div className="rule-item-info">
                            <span className="rule-title">{rule.title}</span>
                            <span className="rule-type">{rule.category} v{rule.version}</span>
                          </div>
                        </button>
                      ))}
                    </div>
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
              className={`mic-btn ${isListening ? 'listening' : ''}`}
              onClick={handleVoiceInput}
              title={isListening ? "Stop Recording" : "Voice Input"}
              disabled={isLoading}
            >
              {isListening ? <MicOff size={20} /> : <Mic size={20} />}
            </button>
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
        <>
          <div className="resizer-handle code-panel-resizer" onMouseDown={startCodePanelResize} />
          <aside className="code-canvas-panel fade-in" style={{ width: `${codePanelWidth}px` }}>
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
        </>
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
                  <div key={rule.id} className={`rule-card glass ${rule.status === 'active' ? 'enabled' : ''}`}>
                    <div className="rule-info">
                      <div className="rule-header">
                        <h4>{rule.title}</h4>
                        <span className={`rule-badge ${rule.category}`}>{rule.category}</span>
                      </div>
                      <p>{rule.description}</p>
                    </div>
                    <div className="rule-action">
                      {user?.ruleaccess?.toLowerCase() === 'admin' ? (
                        <div className="admin-actions">
                          <button
                            className="rule-icon-btn delete"
                            title="Delete Rule"
                            onClick={() => handleDeleteRule(rule.id)}
                          >
                            <Trash2 size={16} />
                          </button>
                          <label className="switch">
                            <input
                              type="checkbox"
                              checked={rule.status === 'active'}
                              onChange={() => toggleRule(rule.id, rule.status)}
                            />
                            <span className="slider"></span>
                          </label>
                        </div>
                      ) : (
                        <span className={`status-badge ${rule.status}`}>
                          {rule.status === 'active' ? 'Enabled' : 'Disabled'}
                        </span>
                      )}
                    </div>
                  </div>
                ))}
              </div>

              {user?.ruleaccess?.toLowerCase() === 'admin' && (
                <button className="add-rule-btn glass" onClick={() => setIsAddRuleModalOpen(true)}>
                  <Plus size={18} />
                  <span>Add New Rule</span>
                </button>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Add Rule Modal */}
      {isAddRuleModalOpen && (
        <div className="panel-overlay" onClick={() => setIsAddRuleModalOpen(false)}>
          <div className="rules-panel add-rule-modal glass fade-in" onClick={e => e.stopPropagation()}>
            <div className="panel-header">
              <div className="header-title">
                <Plus className="accent-icon" size={24} />
                <h2>Create Custom Rule</h2>
              </div>
              <button className="close-btn" onClick={() => setIsAddRuleModalOpen(false)}>
                <X size={24} />
              </button>
            </div>

            <div className="panel-content">
              <div className="form-group">
                <label>Title</label>
                <input
                  type="text"
                  placeholder="e.g., Python Specialist"
                  value={newRule.title}
                  onChange={e => setNewRule({ ...newRule, title: e.target.value })}
                />
              </div>
              <div className="form-group">
                <label>Category</label>
                <select
                  value={newRule.category}
                  onChange={e => setNewRule({ ...newRule, category: e.target.value })}
                >
                  <option value="logic">Logic</option>
                  <option value="style">Style</option>
                  <option value="security">Security</option>
                  <option value="infrastructure">Infrastructure</option>
                </select>
              </div>
              <div className="form-group">
                <label>Short Description</label>
                <input
                  type="text"
                  placeholder="Brief objective of the rule"
                  value={newRule.description}
                  onChange={e => setNewRule({ ...newRule, description: e.target.value })}
                />
              </div>
              <div className="form-group">
                <label>Rule Content (Markdown format instructions)</label>
                <textarea
                  placeholder="Detailed AI instructions..."
                  rows={6}
                  value={newRule.rule_content}
                  onChange={e => setNewRule({ ...newRule, rule_content: e.target.value })}
                />
              </div>

              <div className="modal-actions">
                <button className="cancel-btn" onClick={() => setIsAddRuleModalOpen(false)}>Cancel</button>
                <button className="save-rule-btn" onClick={handleAddRule}>Save Rule & Generate MD</button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('token'))

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
