package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// ProfileController handles health profile endpoints
type ProfileController struct {
	profileService *services.HealthProfileService
}

// NewProfileController creates a new instance of ProfileController
func NewProfileController() *ProfileController {
	return &ProfileController{
		profileService: services.NewHealthProfileService(),
	}
}

// UpdateProfile handles updating a user's health profile
func (c *ProfileController) UpdateProfile(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.ProfileUpdateRequest

	// Bind the request body
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update the user's profile
	err := c.profileService.UpdateUserProfile(userID.(int), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return success
	ctx.JSON(http.StatusOK, gin.H{"message": "Profile updated successfully"})
}

// GetProfile handles retrieving a user's health profile
func (c *ProfileController) GetProfile(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get the user's profile
	profile, err := c.profileService.GetUserProfile(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the profile
	ctx.JSON(http.StatusOK, profile)
}
