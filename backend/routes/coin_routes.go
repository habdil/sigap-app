// routes/coin_routes.go
package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupCoinRoutes sets up the coin routes
func SetupCoinRoutes(router *gin.Engine) {
	coinController := controllers.NewCoinController()

	// All coin routes are protected
	coins := router.Group("/api/coins")
	coins.Use(middlewares.AuthMiddleware())
	{
		coins.GET("", coinController.GetUserCoins)
		coins.POST("/add", coinController.AddCoins)
		coins.POST("/spend", coinController.SpendCoins)
		coins.GET("/transactions", coinController.GetTransactionHistory)
	}
}
