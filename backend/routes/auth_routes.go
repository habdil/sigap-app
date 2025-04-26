package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupAuthRoutes sets up the authentication routes
func SetupAuthRoutes(router *gin.Engine) {
	authController := controllers.NewAuthController()

	// Public routes
	auth := router.Group("/api/auth")
	{
		auth.POST("/signup", authController.SignUp)
		auth.POST("/login", authController.Login)
		auth.POST("/google-login", authController.GoogleLogin)
	}

	// Protected routes
	protected := router.Group("/api")
	protected.Use(middlewares.AuthMiddleware())
	{
		protected.GET("/user", authController.GetCurrentUser)
	}
}
