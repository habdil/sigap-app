package routes

import (
	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/controllers"
	"github.com/habdil/sigap-app/backend/middlewares"
)

// SetupAssessmentRoutes sets up the assessment routes
func SetupAssessmentRoutes(router *gin.Engine) {
	assessmentController := controllers.NewAssessmentController()

	// All assessment routes are protected
	assessment := router.Group("/api/assessment")
	assessment.Use(middlewares.AuthMiddleware())
	{
		assessment.POST("", assessmentController.SubmitAssessment)
		assessment.GET("/latest", assessmentController.GetLatestAssessment)
		assessment.GET("/history", assessmentController.GetAssessmentHistory)
	}
}
