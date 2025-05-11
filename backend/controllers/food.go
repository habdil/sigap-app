// controllers/food.go
package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// FoodController handles food log endpoints
type FoodController struct {
	foodService *services.FoodService
}

// NewFoodController creates a new instance of FoodController
func NewFoodController() *FoodController {
	return &FoodController{
		foodService: services.NewFoodService(),
	}
}

// LogFood handles the creation of a new food log
func (c *FoodController) LogFood(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.FoodLogRequest

	// Bind the request body
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Log the food
	log, err := c.foodService.LogFood(userID.(int), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusCreated, log)
}

// AnalyzeFood handles food image analysis
func (c *FoodController) AnalyzeFood(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.FoodAnalysisRequest

	// Bind the request body
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Analyze the food
	analysis, err := c.foodService.AnalyzeFood(userID.(int), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, analysis)
}

// GetUserFoodLogs gets food logs for a user
func (c *FoodController) GetUserFoodLogs(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get food logs
	logs, err := c.foodService.GetUserFoodLogs(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, logs)
}
