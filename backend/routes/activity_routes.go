// routes/activity_routes.go
package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupActivityRoutes sets up the activity routes
func SetupActivityRoutes(router *gin.Engine) {
	activityController := controllers.NewActivityController()

	// All activity routes are protected
	activity := router.Group("/api/activities")
	activity.Use(middlewares.AuthMiddleware())
	{
		activity.POST("", activityController.LogActivity)
		activity.GET("", activityController.GetUserActivities)
		activity.GET("/recommendations", activityController.GetRecommendedActivities)
	}
}
