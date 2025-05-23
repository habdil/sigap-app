package main

import (
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/routes"
)

func main() {
	// Load environment variables
	err := godotenv.Load()
	if err != nil {
		log.Printf("Warning: Error loading .env file: %v", err)
		// Continue anyway as env vars might be set in the system
	}

	// Initialize database
	config.InitDB()

	// Set Gin mode to Release (Production)
	gin.SetMode(gin.ReleaseMode)

	// Create default router
	router := gin.Default()

	// Setup CORS
	router.Use(config.SetupCORS())

	// Setup routes
	routes.SetupAuthRoutes(router)
	routes.SetupProfileRoutes(router)
	routes.SetupAssessmentRoutes(router)
	routes.SetupActivityRoutes(router)
	routes.SetupFoodRoutes(router)
	routes.SetupCoinRoutes(router)
	routes.SetupChatbotRoutes(router)

	// Add health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status": "ok",
		})
	})

	// Get port from environment variables or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	// Defer closing database connection
	defer config.CloseDB()

	// Start the server
	log.Printf("Server starting on port %s", port)
	if err := router.Run(fmt.Sprintf(":%s", port)); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
