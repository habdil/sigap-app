// routes/chatbot_routes.go
package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupChatbotRoutes sets up the chatbot routes
func SetupChatbotRoutes(router *gin.Engine) {
	chatbotController := controllers.NewChatbotController()

	// All chatbot routes are protected
	chatbot := router.Group("/api/chatbot")
	chatbot.Use(middlewares.AuthMiddleware())
	{
		// Conversation management
		chatbot.GET("/conversations", chatbotController.GetConversations)
		chatbot.POST("/conversations", chatbotController.CreateConversation)
		chatbot.GET("/conversations/:id", chatbotController.GetConversation)
		chatbot.DELETE("/conversations/:id", chatbotController.DeleteConversation)

		// Message management
		chatbot.GET("/conversations/:id/messages", chatbotController.GetMessages)
		chatbot.POST("/conversations/:id/messages", chatbotController.SendMessage)
	}
}
