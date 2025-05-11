// controllers/chatbot_controller.go
package controllers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// ChatbotController handles chatbot endpoints
type ChatbotController struct {
	chatbotService *services.ChatbotService
}

// NewChatbotController creates a new ChatbotController
func NewChatbotController() *ChatbotController {
	return &ChatbotController{
		chatbotService: services.NewChatbotService(),
	}
}

// CreateConversation handles the creation of a new conversation
func (c *ChatbotController) CreateConversation(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.NewConversationRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Create the conversation
	conversation, err := c.chatbotService.CreateConversation(userID.(int), req.Title)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusCreated, models.ConversationResponse{
		Conversation: *conversation,
	})
}

// GetConversation handles retrieving a conversation
func (c *ChatbotController) GetConversation(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get conversation ID from URL
	conversationID, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid conversation ID"})
		return
	}

	// Get the conversation
	conversation, err := c.chatbotService.GetConversation(conversationID, userID.(int))
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, models.ConversationResponse{
		Conversation: *conversation,
	})
}

// GetConversations handles retrieving all conversations for a user
func (c *ChatbotController) GetConversations(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get the conversations
	conversations, err := c.chatbotService.GetUserConversations(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, gin.H{"conversations": conversations})
}

// SendMessage handles sending a message to a conversation
func (c *ChatbotController) SendMessage(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get conversation ID from URL
	conversationID, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid conversation ID"})
		return
	}

	var req models.ChatMessageRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Send the message
	userMessage, botMessage, err := c.chatbotService.SendMessage(userID.(int), conversationID, req.Content)
	if err != nil {
		// Check if we have at least the user message
		if userMessage != nil {
			ctx.JSON(http.StatusPartialContent, gin.H{
				"user_message": userMessage,
				"error":        err.Error(),
			})
			return
		}

		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return both messages
	ctx.JSON(http.StatusOK, gin.H{
		"user_message": userMessage,
		"bot_message":  botMessage,
	})
}

// controllers/chatbot_controller.go (lanjutan)
// GetMessages handles retrieving all messages for a conversation
func (c *ChatbotController) GetMessages(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get conversation ID from URL
	conversationID, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid conversation ID"})
		return
	}

	// Get the messages
	messages, err := c.chatbotService.GetMessages(conversationID, userID.(int))
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, models.MessagesResponse{
		Messages: messages,
	})
}

// DeleteConversation handles deleting a conversation
func (c *ChatbotController) DeleteConversation(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get conversation ID from URL
	conversationID, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid conversation ID"})
		return
	}

	// Delete the conversation
	err = c.chatbotService.DeleteConversation(conversationID, userID.(int))
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	// Return success
	ctx.JSON(http.StatusOK, gin.H{"message": "Conversation deleted successfully"})
}
