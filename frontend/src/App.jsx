import React, { useState, useRef, useEffect, useLayoutEffect } from 'react'
import {
  Send,
  Plus,
  MessageSquare,
  Settings,
  User,
  Bot,
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
  ExternalLink,
  Eye,
  LogOut,
  Clock,
  History,
  Pin,
  Pencil
} from 'lucide-react'
import Editor from '@monaco-editor/react'
import api from './services/api'
import './App.css'
import logo from './assets/logo.png'

import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import { vscDarkPlus } from 'react-syntax-highlighter/dist/esm/styles/prism'

import { HashRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom'
import Login from './pages/Login'

// Safe LocalStorage helper for restricted environments (like iframes)
const storage = {
  get: (key) => {
    try {
      if (typeof window === 'undefined' || !window.localStorage) return null;
      return localStorage.getItem(key);
    } catch (e) {
      console.warn('LocalStorage access blocked:', e);
      return null;
    }
  },
  set: (key, value) => {
    try {
      if (typeof window === 'undefined' || !window.localStorage) return;
      localStorage.setItem(key, value);
    } catch (e) {
      console.warn('LocalStorage write blocked:', e);
    }
  },
  remove: (key) => {
    try {
      if (typeof window === 'undefined' || !window.localStorage) return;
      localStorage.removeItem(key);
    } catch (e) {
      console.warn('LocalStorage remove blocked:', e);
    }
  }
};

// Rename old App to Chatbot
function Chatbot({ isMobile, setIsMobile, isPluginMode, setIsPluginMode }) {
  const [user, setUser] = useState(null)
  const [messages, setMessages] = useState([])
  const [input, setInput] = useState('')
  const [isSidebarOpen, setIsSidebarOpen] = useState(window.innerWidth > 768)
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
  const [editingMessageId, setEditingMessageId] = useState(null)
  const [editMessageContent, setEditMessageContent] = useState('')
  const [previewImage, setPreviewImage] = useState(null)
  const [streamingMessageId, setStreamingMessageId] = useState(null)
  const [isMobileHistoryOpen, setIsMobileHistoryOpen] = useState(false)

  const fileInputRef = useRef(null)
  const folderInputRef = useRef(null)
  const imageInputRef = useRef(null)
  const inputRef = useRef(null)

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

  useLayoutEffect(() => {
    if (inputRef.current) {
      inputRef.current.style.height = 'auto'
      inputRef.current.style.height = `${Math.min(inputRef.current.scrollHeight, 200)}px`
    }
  }, [input])

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

    const handleResize = () => {
      const mobile = window.innerWidth <= 768
      setIsMobile(mobile)
      if (mobile) setIsSidebarOpen(false)
    }
    window.addEventListener('resize', handleResize)

    // Handle initial prompt from params
    const params = new URLSearchParams(window.location.search)
    const initialPrompt = params.get('prompt') || params.get('q')
    if (initialPrompt) {
      setInput(decodeURIComponent(initialPrompt))
    }

    // Force sidebar closed in plugin mode
    if (isPluginMode) {
      setIsSidebarOpen(false)
    }

    return () => window.removeEventListener('resize', handleResize)
  }, [isPluginMode, setIsMobile])

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

  const resizeImage = (file, maxWidth = 1024, maxHeight = 1024) => {
    return new Promise((resolve) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = (event) => {
        const img = new Image();
        img.src = event.target.result;
        img.onload = () => {
          const canvas = document.createElement('canvas');
          let width = img.width;
          let height = img.height;

          if (width > height) {
            if (width > maxWidth) {
              height *= maxWidth / width;
              width = maxWidth;
            }
          } else {
            if (height > maxHeight) {
              width *= maxHeight / height;
              height = maxHeight;
            }
          }

          canvas.width = width;
          canvas.height = height;
          const ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0, width, height);
          resolve(canvas.toDataURL('image/jpeg', 0.8)); // Convert to compressed JPEG
        };
      };
    });
  };

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
        if (file.type.startsWith('image/')) {
          resizeImage(file).then(compressedContent => {
            resolve({
              id: Math.random().toString(36).substr(2, 9),
              name: file.name,
              type: 'image',
              content: compressedContent,
              fileObj: file
            })
          })
        } else {
          const reader = new FileReader()
          reader.onload = (e) => {
            resolve({
              id: Math.random().toString(36).substr(2, 9),
              name: file.name,
              type: 'file',
              content: e.target.result,
              fileObj: file
            })
          }
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

  const consumeStream = async (response, tempBotId) => {
    const reader = response.body.getReader()
    const decoder = new TextDecoder()
    let accumulatedContent = ""
    let partialLine = ""

    setStreamingMessageId(tempBotId)
    while (true) {
      const { done, value } = await reader.read()
      if (done) break

      const chunk = decoder.decode(value, { stream: true })
      const lines = (partialLine + chunk).split('\n')
      partialLine = lines.pop()

      for (const line of lines) {
        if (!line.trim() || !line.startsWith('data: ')) continue

        try {
          const data = JSON.parse(line.replace('data: ', ''))

          if (data.type === 'metadata') {
            if (data.chat_id && !activeChatId) {
              setActiveChatId(data.chat_id)
              fetchChats()
            }
          } else if (data.type === 'content') {
            accumulatedContent += data.delta
            setMessages(prev => prev.map(m => m.id === tempBotId ? { ...m, content: accumulatedContent } : m))
          } else if (data.type === 'message_id') {
            setMessages(prev => prev.map(m => m.id === tempBotId ? { ...m, id: data.id } : m))
          }
        } catch (e) {
          console.error("Error parsing SSE line:", line, e)
        }
      }
    }
    setStreamingMessageId(null)
  }

  const groupConversationsByDate = (convs) => {
    const groups = {
      'Pinned': [],
      'Today': [],
      'Yesterday': [],
      'Last 7 Days': [],
      'Last 30 Days': [],
      'Older': []
    }

    const now = new Date()
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime()
    const oneDayMs = 24 * 60 * 60 * 1000

    convs.forEach(conv => {
      if (conv.is_pinned) {
        groups['Pinned'].push(conv)
        return
      }

      const convDate = new Date(conv.created_at)
      const convTimestamp = new Date(convDate.getFullYear(), convDate.getMonth(), convDate.getDate()).getTime()
      const diffDays = Math.round((startOfToday - convTimestamp) / oneDayMs)

      if (diffDays <= 0) groups['Today'].push(conv)
      else if (diffDays === 1) groups['Yesterday'].push(conv)
      else if (diffDays < 7) groups['Last 7 Days'].push(conv)
      else if (diffDays < 30) groups['Last 30 Days'].push(conv)
      else groups['Older'].push(conv)
    })

    return Object.fromEntries(Object.entries(groups).filter(([_, v]) => v.length > 0))
  }

  const handlePinChat = async (e, chatId, currentStatus) => {
    e.stopPropagation()
    try {
      await api.patch(`/chats/${chatId}`, { is_pinned: !currentStatus })
      fetchChats()
    } catch (error) {
      console.error("Failed to pin chat:", error)
    }
  }

  const handleDeleteAllHistory = async () => {
    if (!window.confirm("Are you sure you want to delete all chat history? This cannot be undone.")) return
    try {
      await api.delete('/chats/all')
      setConversations([])
      setActiveChatId(null)
      setMessages([])
      if (isMobile || isPluginMode) setIsMobileHistoryOpen(false)
    } catch (error) {
      console.error("Failed to delete all history:", error)
    }
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
      const response = await fetch(`${api.defaults.baseURL}/invoke`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': api.defaults.headers.common['Authorization']
        },
        body: JSON.stringify({
          message: finalPrompt,
          chat_id: activeChatId,
          rules_applied: attachedRules,
          attachments: attachmentsData,
          provider: selectedModel.provider,
          model: selectedModel.id,
          stream: true
        })
      })

      if (!response.ok) throw new Error('Streaming failed')

      const tempBotId = Date.now() + 1
      const botMessage = {
        id: tempBotId,
        role: 'bot',
        content: '',
        timestamp: new Date()
      }

      setMessages(prev => [...prev, botMessage])
      setIsLoading(false)

      await consumeStream(response, tempBotId)
    } catch (error) {
      console.error("Streaming error:", error)
      alert("Failed to send message. Please check your connection or AI provider settings.")
      setIsLoading(false)
    }
  }

  const handleLogout = () => {
    storage.remove('token')
    delete api.defaults.headers.common['Authorization']
    window.location.href = `/login${window.location.search}`
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

  const startEditingMessage = (msg) => {
    setEditingMessageId(msg.id)
    setEditMessageContent(msg.content)
  }

  const handleEditMessage = async (messageId) => {
    if (!editMessageContent.trim()) {
      setEditingMessageId(null)
      return
    }

    setIsLoading(true)
    setEditingMessageId(null)

    try {
      const token = storage.get('token')
      const baseUrl = api.defaults.baseURL || ''
      const url = `${baseUrl}/messages/${messageId}`

      const response = await fetch(url, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({
          content: editMessageContent,
          stream: true,
          provider: selectedModel.provider,
          model: selectedModel.id,
          rules_applied: attachedRules
        })
      })

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}))
        throw new Error(errorData.detail || 'Edit failed')
      }

      const tempBotId = Date.now() + 2

      // Update local messages: remove all messages after the edited one and add the new bot response
      setMessages(prev => {
        const index = prev.findIndex(m => m.id === messageId)
        if (index === -1) return prev
        const updatedUserMsg = { ...prev[index], content: editMessageContent }
        const newBotMsg = {
          id: tempBotId,
          role: 'bot',
          content: '',
          timestamp: new Date()
        }
        return [...prev.slice(0, index), updatedUserMsg, newBotMsg]
      })

      setIsLoading(false)
      await consumeStream(response, tempBotId)
    } catch (error) {
      console.error("Failed to edit message:", error)
      alert(`Failed to edit message: ${error.message}`)
      setIsLoading(false)
    }
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
    <div className={`app-container ${!isSidebarOpen ? 'sidebar-hidden' : ''} ${isResizingSidebar || isResizingCodePanel ? 'is-resizing' : ''} ${isPluginMode ? 'is-plugin' : ''} ${isMobile ? 'is-mobile' : ''}`} style={{ '--sidebar-width': isSidebarOpen ? `${sidebarWidth}px` : '80px', '--sidebar-collapsed-width': '80px' }}>
      {/* Sidebar - Hidden on mobile/plugin */}
      {!isMobile && !isPluginMode && (
        <aside className={`sidebar glass ${isSidebarOpen ? 'open' : 'closed'}`} style={{ width: isSidebarOpen ? `${sidebarWidth}px` : '80px' }}>
          <div className="sidebar-header">
            <div className="logo-section">
              {!isPluginMode && <img src={logo} alt="Logo" className="sidebar-logo-img" />}
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
            <div className="section-header-row">
              <div className="section-label">{isSidebarOpen && 'Recent Chats'}</div>
              {isSidebarOpen && conversations.length > 0 && (
                <button className="delete-all-btn" onClick={handleDeleteAllHistory} title="Delete All History">
                  <Trash2 size={14} />
                </button>
              )}
            </div>
            <div className="conversations-list">
              {Object.entries(groupConversationsByDate(conversations)).map(([group, chats]) => (
                <React.Fragment key={group}>
                  {isSidebarOpen && <div className="group-divider">{group}</div>}
                  {chats.map(conv => (
                    <div
                      key={conv.id}
                      className={`conv-item ${activeChatId === conv.id ? 'active' : ''} ${conv.is_pinned ? 'pinned' : ''}`}
                      onClick={() => fetchChatMessages(conv.id)}
                    >
                      <MessageSquare size={16} />
                      {isSidebarOpen && (
                        editingChatId === conv.id ? (
                          <input
                            className="edit-input"
                            value={editTitle}
                            onChange={(e) => setEditTitle(e.target.value)}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter') handleRenameChat(e, conv.id)
                              if (e.key === 'Escape') setEditingChatId(null)
                            }}
                            onBlur={(e) => handleRenameChat(e, conv.id)}
                            autoFocus
                            onClick={(e) => e.stopPropagation()}
                          />
                        ) : (
                          <span className="conv-title">{conv.title}</span>
                        )
                      )}
                      {isSidebarOpen && (
                        <div className="chat-actions">
                          <button
                            className={`action-btn ${conv.is_pinned ? 'active' : ''}`}
                            onClick={(e) => handlePinChat(e, conv.id, conv.is_pinned)}
                            title={conv.is_pinned ? "Unpin" : "Pin"}
                          >
                            <Pin size={14} fill={conv.is_pinned ? "currentColor" : "none"} />
                          </button>
                          <button className="action-btn" onClick={(e) => {
                            e.stopPropagation()
                            setEditingChatId(conv.id)
                            setEditTitle(conv.title)
                          }} title="Rename">
                            <Pencil size={14} />
                          </button>
                          <button className="action-btn" onClick={(e) => handleDeleteChat(e, conv.id)} title="Delete">
                            <Trash2 size={14} />
                          </button>
                        </div>
                      )}
                    </div>
                  ))}
                </React.Fragment>
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
                {isSidebarOpen && user && <span className="rule-access-badge">{user.ruleaccess}</span>}
                <button
                  className="logout-icon-btn"
                  title="Logout"
                  onClick={handleLogout}
                >
                  <LogOut size={18} />
                </button>
              </div>
            </div>
          </div>
        </aside>
      )}

      {!isMobile && !isPluginMode && isSidebarOpen && (
        <div className="resizer-handle sidebar-resizer" onMouseDown={startSidebarResize} />
      )}

      {/* Remove the old sidebar toggle as requested - we will use a history icon instead */}

      <main className="main-content">
        <header className="chat-header glass">
          <div className="header-info">
            <div className="header-main-info">
              <h3 className="conversation-title">
                {activeChatId ? getFriendlyTitle(conversations.find(c => c.id === activeChatId)?.title) : (isPluginMode ? ' ' : 'New Conversation')}
              </h3>
            </div>

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
                      {selectedModel.id === model.id && <img src={logo} alt="selected" className="sidebar-logo-img small" style={{ width: '14px', height: '14px' }} />}
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
          <div className="header-actions">
            {(isMobile || isPluginMode) && (
              <div className="mobile-header-controls">
                <button
                  className="mobile-nav-btn glass history-btn"
                  onClick={() => setIsMobileHistoryOpen(true)}
                  title="History"
                >
                  <Clock size={20} />
                </button>
                {user && (
                  <div className="mobile-user-details">
                    {!isPluginMode && <span className="mobile-username">{user.username}</span>}
                    <button className="mobile-nav-btn logout glass" onClick={handleLogout} title="Logout">
                      <LogOut size={20} />
                    </button>
                  </div>
                )}
              </div>
            )}
            {/* Icons removed as per user request */}
          </div>
        </header>

        <div className="messages-container">
          <div className="messages-content-wrapper">
            {messages.length === 0 && !isLoading && (
              <div className="welcome-screen fade-in">
                <div className="welcome-logo">
                  <img src={logo} alt="Logo" className="welcome-logo-img pulse" />
                </div>
                <h1>How can I help you today?</h1>
                <p>ITSS AI is ready to assist with code, design, and logic.</p>
              </div>
            )}
            {messages.map((msg) => (
              <div key={msg.id} className={`message-wrapper ${msg.role}`}>
                <div className="message-icon">
                  {msg.role === 'bot' ? <img src={logo} alt="AI" className="bot-avatar-img" /> : <User size={20} />}
                </div>
                <div className={`message-bubble glass fade-in ${streamingMessageId === msg.id ? 'is-streaming' : ''}`}>
                  {msg.attachments && msg.attachments.length > 0 && (
                    <div className="message-attachments-display">
                      {msg.attachments.map((at, i) => (
                        at.type === 'image' && (
                          <img key={i} src={at.content} alt={at.name} className="bubble-image" />
                        )
                      ))}
                    </div>
                  )}

                  {editingMessageId === msg.id ? (
                    <div className="message-edit-container">
                      <textarea
                        className="message-edit-textarea"
                        value={editMessageContent}
                        onChange={(e) => setEditMessageContent(e.target.value)}
                        onKeyDown={(e) => {
                          if (e.key === 'Enter' && !e.shiftKey) {
                            e.preventDefault();
                            handleEditMessage(msg.id);
                          }
                          if (e.key === 'Escape') {
                            setEditingMessageId(null);
                          }
                        }}
                        autoFocus
                      />
                      <div className="edit-actions">
                        <button className="save-btn" onClick={() => handleEditMessage(msg.id)}>
                          Send
                        </button>
                        <button className="cancel-btn" onClick={() => setEditingMessageId(null)}>
                          Cancel
                        </button>
                      </div>
                    </div>
                  ) : (
                    <>
                      <MessageContent content={msg.content} />
                      {streamingMessageId === msg.id && <span className="streaming-cursor"></span>}
                    </>
                  )}

                  <div className="message-time">
                    <div className="message-actions-row">
                      <button className="copy-btn" onClick={() => copyToClipboard(msg.content)}>
                        <Copy size={12} /> Copy
                      </button>
                      {msg.role === 'user' && !editingMessageId && (
                        <button className="copy-btn" onClick={() => startEditingMessage(msg)}>
                          <Edit2 size={12} /> Edit
                        </button>
                      )}
                    </div>
                    {new Date(msg.timestamp || msg.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </div>
                </div>
              </div>
            ))}
            {isLoading && (
              <div className="message-wrapper bot">
                <div className="message-icon">
                  <img src={logo} alt="AI" className="bot-avatar-img pulse" />
                </div>
                <div className="message-bubble glass thinking-bubble">
                  <div className="thinking-dots">
                    <span></span><span></span><span></span>
                  </div>
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
                <div key={file.id} className={`attachment-preview-item glass ${file.type === 'image' ? 'image-type' : ''}`}>
                  {file.type === 'image' ? (
                    <div className="attachment-image-wrapper">
                      <img src={file.content} alt={file.name} />
                      <div className="attachment-overlay">
                        <button className="overlay-btn" onClick={() => setPreviewImage(file.content)}>
                          <Eye size={16} />
                        </button>
                        <button className="overlay-btn delete" onClick={() => removeAttachment(file.id)}>
                          <X size={16} />
                        </button>
                      </div>
                    </div>
                  ) : (
                    <>
                      <FileText size={16} />
                      <span className="file-name">{file.name}</span>
                      <button className="remove-btn" onClick={() => removeAttachment(file.id)}>
                        <X size={12} />
                      </button>
                    </>
                  )}
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
              ref={inputRef}
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
      {
        isCodePanelOpen && (
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
        )
      }

      {/* Rules Panel Overlay */}
      {
        isRulesPanelOpen && (
          <div className="panel-overlay" onClick={() => setIsRulesPanelOpen(false)}>
            <div className="rules-panel glass fade-in" onClick={e => e.stopPropagation()}>
              <div className="panel-header">
                <div className="header-title">
                  <img src={logo} alt="Logo" className="sidebar-logo-img" style={{ marginRight: '10px' }} />
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
                        {user && user.ruleaccess?.toLowerCase() === 'admin' ? (
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

                {user && user.ruleaccess?.toLowerCase() === 'admin' && (
                  <button className="add-rule-btn glass" onClick={() => setIsAddRuleModalOpen(true)}>
                    <Plus size={18} />
                    <span>Add New Rule</span>
                  </button>
                )}
              </div>
            </div>
          </div>
        )
      }

      {/* Add Rule Modal */}
      {
        isAddRuleModalOpen && (
          <div className="panel-overlay" onClick={() => setIsAddRuleModalOpen(false)}>
            <div className="rules-panel add-rule-modal glass fade-in" onClick={e => e.stopPropagation()}>
              <div className="panel-header">
                <div className="header-title">
                  <img src={logo} alt="Logo" className="sidebar-logo-img" style={{ marginRight: '10px' }} />
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
        )
      }
      {/* Lightbox for image preview */}
      {
        previewImage && (
          <div className="lightbox-overlay fade-in" onClick={() => setPreviewImage(null)}>
            <button className="lightbox-close" onClick={() => setPreviewImage(null)}>
              <X size={32} />
            </button>
            <img src={previewImage} alt="Preview" className="lightbox-image" onClick={e => e.stopPropagation()} />
          </div>
        )
      }

      {/* Mobile/Plugin History Drawer - Refined Sliding Drawer */}
      {
        isMobileHistoryOpen && (isMobile || isPluginMode) && (
          <div className="panel-overlay drawer-overlay fade-in" onClick={() => setIsMobileHistoryOpen(false)}>
            <div className="mobile-history-panel refined-drawer slideInLeft" onClick={e => e.stopPropagation()}>
              <div className="drawer-header">
                <div className="drawer-title-section">
                  <History size={20} className="accent-icon" />
                  <div>
                    <h3>Chat History</h3>
                    <p className="drawer-subtitle">{conversations.length} sessions</p>
                  </div>
                </div>
                <button className="close-btn-mini" onClick={() => setIsMobileHistoryOpen(false)}>
                  <X size={20} />
                </button>
              </div>

              <div className="drawer-actions">
                <button
                  className="new-chat-btn-compact glass"
                  onClick={() => {
                    handleNewChat()
                    setIsMobileHistoryOpen(false)
                  }}
                >
                  <Plus size={16} />
                  <span>New Conversation</span>
                </button>
                {conversations.length > 0 && (
                  <button
                    className="delete-all-btn-mobile glass"
                    onClick={handleDeleteAllHistory}
                  >
                    <Trash2 size={16} />
                  </button>
                )}
              </div>

              <div className="drawer-content scrollable-list">
                {conversations.length > 0 ? (
                  Object.entries(groupConversationsByDate(conversations)).map(([group, chats]) => (
                    <div key={group} className="history-group">
                      <div className="group-header">{group}</div>
                      <div className="group-items">
                        {chats.map(conv => (
                          <div
                            key={conv.id}
                            className={`history-item-compact glass ${activeChatId === conv.id ? 'active' : ''} ${conv.is_pinned ? 'pinned' : ''}`}
                            onClick={() => {
                              if (editingChatId !== conv.id) {
                                fetchChatMessages(conv.id)
                                setIsMobileHistoryOpen(false)
                              }
                            }}
                          >
                            <div className="item-main">
                              <MessageSquare size={14} className="item-icon" />
                              <div className="item-text">
                                {editingChatId === conv.id ? (
                                  <input
                                    className="compact-edit-input"
                                    value={editTitle}
                                    autoFocus
                                    onChange={(e) => setEditTitle(e.target.value)}
                                    onKeyDown={(e) => {
                                      if (e.key === 'Enter') handleRenameChat(e, conv.id)
                                      if (e.key === 'Escape') setEditingChatId(null)
                                    }}
                                    onClick={(e) => e.stopPropagation()}
                                  />
                                ) : (
                                  <span className="item-title">{getFriendlyTitle(conv.title)}</span>
                                )}
                                <span className="item-time">
                                  {new Date(conv.created_at).toLocaleDateString([], { month: 'short', day: 'numeric' })}
                                </span>
                              </div>
                            </div>

                            <div className="item-actions">
                              <button
                                className={`mini-action-btn ${conv.is_pinned ? 'active' : ''}`}
                                onClick={(e) => handlePinChat(e, conv.id, conv.is_pinned)}
                                title={conv.is_pinned ? "Unpin" : "Pin"}
                              >
                                <Pin size={12} fill={conv.is_pinned ? "currentColor" : "none"} />
                              </button>
                              {editingChatId === conv.id ? (
                                <button className="mini-action-btn success" onClick={(e) => handleRenameChat(e, conv.id)}>
                                  <Check size={14} />
                                </button>
                              ) : (
                                <>
                                  <button className="mini-action-btn" onClick={(e) => {
                                    e.stopPropagation()
                                    setEditingChatId(conv.id)
                                    setEditTitle(conv.title)
                                  }}>
                                    <Edit2 size={12} />
                                  </button>
                                  <button className="mini-action-btn delete" onClick={(e) => {
                                    e.stopPropagation()
                                    handleDeleteChat(e, conv.id)
                                  }}>
                                    <Trash2 size={12} />
                                  </button>
                                </>
                              )}
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  ))
                ) : (
                  <div className="drawer-empty-state">
                    <History size={40} className="muted-icon" />
                    <p>No chat history yet</p>
                  </div>
                )}
              </div>
            </div>
          </div>
        )
      }
    </div >
  )
}


function App() {
  const [isPluginMode, setIsPluginMode] = useState(false)
  const [isMobile, setIsMobile] = useState(window.innerWidth <= 768)
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    const token = storage.get('token')
    if (token) {
      api.defaults.headers.common['Authorization'] = `Bearer ${token}`
      return true
    }
    return false
  })
  const [isInitialized, setIsInitialized] = useState(false)

  const handleLogin = () => {
    setIsAuthenticated(true)
  }

  // Handle initialization and parameters
  useEffect(() => {
    try {
      const searchParams = new URLSearchParams(window.location.search)
      const hashParams = new URLSearchParams(window.location.hash.includes('?') ? window.location.hash.split('?')[1] : '')

      // 1. Detect Plugin Mode (v3 - Check both search and hash)
      const isPlugin = searchParams.get('isPlugin') === 'true' ||
        searchParams.get('plugin') === 'true' ||
        hashParams.get('isPlugin') === 'true' ||
        hashParams.get('plugin') === 'true' ||
        window.location.href.includes('plugin=true')

      console.log("Detecting Plugin Mode:", { isPlugin, href: window.location.href })
      if (isPlugin) setIsPluginMode(true)

      // 2. Handle Auto-Authentication Token
      const urlToken = searchParams.get('token') || hashParams.get('token')
      if (urlToken) {
        storage.set('token', urlToken)
        api.defaults.headers.common['Authorization'] = `Bearer ${urlToken}`
        setIsAuthenticated(true)
      } else {
        const savedToken = storage.get('token')
        if (savedToken) {
          api.defaults.headers.common['Authorization'] = `Bearer ${savedToken}`
          setIsAuthenticated(true)
        }
      }
    } catch (e) {
      console.error("App initialization failed:", e)
    } finally {
      setIsInitialized(true)
    }
  }, [])

  if (!isInitialized) {
    return (
      <div style={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#0a0a0c', color: 'white' }}>
        <Loader2 className="animate-spin" size={40} />
      </div>
    )
  }

  return (
    <ErrorBoundary>
      <div className={`app-root-wrapper ${isPluginMode ? 'is-plugin' : ''}`} style={{ minHeight: '100vh', background: isPluginMode ? 'transparent' : '#0a0a0c' }}>
        <Router>
          <Routes>
            <Route
              path="/login"
              element={isAuthenticated ? <Navigate to={`/${window.location.search || ''}`} /> : <Login onLogin={handleLogin} isPluginMode={isPluginMode} />}
            />
            <Route
              path="/"
              element={isAuthenticated ?
                <Chatbot isMobile={isMobile} setIsMobile={setIsMobile} isPluginMode={isPluginMode} setIsPluginMode={setIsPluginMode} /> :
                <Navigate to={`/login${window.location.search || ''}`} />
              }
            />
            <Route path="*" element={<Navigate to={isAuthenticated ? `/${window.location.search || ''}` : `/login${window.location.search || ''}`} />} />
          </Routes>
        </Router>
        {/* Hidden debug marker */}
        <div id="app-initialized-marker" style={{ display: 'none' }}>ready</div>
      </div>
    </ErrorBoundary>
  )
}

// Robust Error Boundary
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error("ErrorBoundary caught an error:", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{ height: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: '#0a0a0c', color: 'white', padding: '2rem', textAlign: 'center' }}>
          <h1>Something went wrong</h1>
          <p>The application encountered an unexpected error.</p>
          <pre style={{ background: '#1a1a1c', padding: '1rem', borderRadius: '8px', color: '#ef4444', maxWidth: '100%', overflow: 'auto', textAlign: 'left' }}>
            {this.state.error?.toString()}
          </pre>
          <button onClick={() => window.location.reload()} style={{ marginTop: '1rem', padding: '0.6rem 2rem', borderRadius: '12px', background: 'var(--accent-primary, #7c3aed)', color: 'white', border: 'none', cursor: 'pointer', fontWeight: 'bold' }}>
            Reload Page
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}

export default App
