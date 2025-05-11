// controllers/coin_controller.go
package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// CoinController handles coin-related endpoints
type CoinController struct {
	coinService *services.CoinService
}

// NewCoinController creates a new CoinController
func NewCoinController() *CoinController {
	return &CoinController{
		coinService: services.NewCoinService(),
	}
}

// GetUserCoins handles retrieving a user's coin balance
func (c *CoinController) GetUserCoins(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get the user's coins
	coins, err := c.coinService.GetUserCoins(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the coins
	ctx.JSON(http.StatusOK, coins)
}

// AddCoins handles adding coins to a user's balance (admin only)
func (c *CoinController) AddCoins(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Only admin or system can add coins directly
	// You may want to add role check here

	var req models.AddCoinsRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Add coins
	if err := c.coinService.AddCoins(userID.(int), &req); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return success
	ctx.JSON(http.StatusOK, gin.H{"message": "Coins added successfully"})
}

// SpendCoins handles spending coins from a user's balance
func (c *CoinController) SpendCoins(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.SpendCoinsRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Spend coins
	if err := c.coinService.SpendCoins(userID.(int), &req); err != nil {
		if err.Error() == "insufficient coins" {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": "Insufficient coins"})
			return
		}
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return success
	ctx.JSON(http.StatusOK, gin.H{"message": "Coins spent successfully"})
}

// GetTransactionHistory handles retrieving a user's coin transaction history
func (c *CoinController) GetTransactionHistory(ctx *gin.Context) {
	// Get user ID from context
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get the transaction history
	transactions, err := c.coinService.GetTransactionHistory(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the transactions
	ctx.JSON(http.StatusOK, transactions)
}
