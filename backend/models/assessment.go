package models

import "time"

// UserAssessment represents a user's health assessment
type UserAssessment struct {
	ID                 int       `json:"id"`
	UserID             int       `json:"user_id"`
	ScreenTimeHours    int       `json:"screen_time_hours"`    // Question 1
	ExerciseHours      int       `json:"exercise_hours"`       // Question 2
	LateNightFrequency int       `json:"late_night_frequency"` // Question 3
	DietQuality        int       `json:"diet_quality"`         // Question 4
	CreatedAt          time.Time `json:"created_at"`
	UpdatedAt          time.Time `json:"updated_at"`
}

// RiskAssessmentResult represents the result of a risk assessment
type RiskAssessmentResult struct {
	ID              int       `json:"id"`
	UserID          int       `json:"user_id"`
	AssessmentID    int       `json:"assessment_id"`
	RiskPercentage  int       `json:"risk_percentage"`
	RiskFactors     []string  `json:"risk_factors"`
	Recommendations []string  `json:"recommendations,omitempty"`
	CreatedAt       time.Time `json:"created_at"`
}

// AssessmentRequest represents the request for a user assessment
type AssessmentRequest struct {
	ScreenTimeHours    int `json:"screen_time_hours" binding:"required,min=1,max=4"`
	ExerciseHours      int `json:"exercise_hours" binding:"required,min=1,max=4"`
	LateNightFrequency int `json:"late_night_frequency" binding:"required,min=1,max=4"`
	DietQuality        int `json:"diet_quality" binding:"required,min=1,max=4"`
}

// AssessmentResponse represents the response for an assessment
type AssessmentResponse struct {
	Assessment UserAssessment       `json:"assessment"`
	Result     RiskAssessmentResult `json:"result"`
}
