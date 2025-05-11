// controllers/activity.go
package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// ActivityController handles activity endpoints
type ActivityController struct {
	activityService *services.ActivityService
}

// NewActivityController creates a new instance of ActivityController
func NewActivityController() *ActivityController {
	return &ActivityController{
		activityService: services.NewActivityService(),
	}
}

// LogActivity handles the creation of a new activity log
func (c *ActivityController) LogActivity(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.ActivityLogRequest

	// Bind the request body
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Log the activity
	log, err := c.activityService.LogActivity(userID.(int), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusCreated, log)
}

// GetUserActivities gets activities for a user
func (c *ActivityController) GetUserActivities(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get activities
	activities, err := c.activityService.GetUserActivities(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, activities)
}

// GetRecommendedActivities gets recommended activities for a user
func (c *ActivityController) GetRecommendedActivities(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get recommendations
	recommendations, err := c.activityService.GetRecommendedActivities(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, recommendations)
}
