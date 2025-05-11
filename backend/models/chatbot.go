// models/chatbot.go
package models

import (
	"time"
)

// ChatbotConversation represents a conversation between user and chatbot
type ChatbotConversation struct {
	ID        int           `json:"id"`
	UserID    int           `json:"user_id"`
	Title     string        `json:"title"`
	CreatedAt time.Time     `json:"created_at"`
	UpdatedAt time.Time     `json:"updated_at"`
	IsActive  bool          `json:"is_active"`
	Messages  []ChatMessage `json:"messages,omitempty"`
}

// ChatMessage represents a single message in a conversation
type ChatMessage struct {
	ID             int                    `json:"id"`
	ConversationID int                    `json:"conversation_id"`
	UserID         int                    `json:"user_id"`
	Content        string                 `json:"content"`
	SenderType     string                 `json:"sender_type"` // "user" or "bot"
	CreatedAt      time.Time              `json:"created_at"`
	Metadata       []byte                 `json:"-"` // Stored as JSONB in database
	MetadataMap    map[string]interface{} `json:"metadata,omitempty"`
}

// NewConversationRequest represents a request to create a new conversation
type NewConversationRequest struct {
	Title string `json:"title,omitempty"`
}

// ChatMessageRequest represents a request to send a message
type ChatMessageRequest struct {
	Content string `json:"content" binding:"required"`
}

// ConversationResponse represents a response with conversation details
type ConversationResponse struct {
	Conversation ChatbotConversation `json:"conversation"`
}

// MessagesResponse represents a response with messages
type MessagesResponse struct {
	Messages []ChatMessage `json:"messages"`
}
