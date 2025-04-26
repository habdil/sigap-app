package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// AssessmentController handles assessment endpoints
type AssessmentController struct {
	assessmentService *services.AssessmentService
}

// NewAssessmentController creates a new instance of AssessmentController
func NewAssessmentController() *AssessmentController {
	return &AssessmentController{
		assessmentService: services.NewAssessmentService(),
	}
}

// SubmitAssessment handles the submission of a new assessment
func (c *AssessmentController) SubmitAssessment(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req models.AssessmentRequest

	// Bind the request body
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Submit the assessment
	response, err := c.assessmentService.SubmitAssessment(userID.(int), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, response)
}

// GetLatestAssessment handles retrieving the latest assessment for a user
func (c *AssessmentController) GetLatestAssessment(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get the latest assessment
	assessment, err := c.assessmentService.GetLatestAssessment(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the assessment
	ctx.JSON(http.StatusOK, assessment)
}

// GetAssessmentHistory handles retrieving the assessment history for a user
func (c *AssessmentController) GetAssessmentHistory(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get the assessment history
	history, err := c.assessmentService.GetAssessmentHistory(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the history
	ctx.JSON(http.StatusOK, history)
}
