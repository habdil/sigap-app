// routes/food_routes.go
package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupFoodRoutes sets up the food routes
func SetupFoodRoutes(router *gin.Engine) {
	foodController := controllers.NewFoodController()

	// All food routes are protected
	food := router.Group("/api/food")
	food.Use(middlewares.AuthMiddleware())
	{
		food.POST("", foodController.LogFood)
		food.POST("/analyze", foodController.AnalyzeFood)
		food.GET("", foodController.GetUserFoodLogs)
	}
}
