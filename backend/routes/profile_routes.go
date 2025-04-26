package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupProfileRoutes sets up the health profile routes
func SetupProfileRoutes(router *gin.Engine) {
	profileController := controllers.NewProfileController()

	// All profile routes are protected
	profile := router.Group("/api/profile")
	profile.Use(middlewares.AuthMiddleware())
	{
		profile.GET("", profileController.GetProfile)
		profile.PUT("", profileController.UpdateProfile)
	}
}
