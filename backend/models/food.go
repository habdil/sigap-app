// models/food.go
package models

import "time"

// FoodLog represents a food consumption record
type FoodLog struct {
	ID       int           `json:"id"`
	UserID   int           `json:"user_id"`
	FoodName string        `json:"food_name,omitempty"`
	LogDate  time.Time     `json:"log_date"`
	PhotoURL string        `json:"photo_url,omitempty"`
	Notes    string        `json:"notes,omitempty"`
	Analysis *FoodAnalysis `json:"analysis,omitempty"`
}

// FoodAnalysis represents the nutritional analysis of a food log
type FoodAnalysis struct {
	ID               int       `json:"id"`
	FoodLogID        int       `json:"food_log_id"`
	ProteinGrams     float64   `json:"protein_grams,omitempty"`
	CarbsGrams       float64   `json:"carbs_grams,omitempty"`
	FatGrams         float64   `json:"fat_grams,omitempty"`
	FiberGrams       float64   `json:"fiber_grams,omitempty"`
	Calories         int       `json:"calories,omitempty"`
	DetectedItems    []byte    `json:"-"` // Stored as JSON in database
	HealthinessScore int       `json:"healthiness_score,omitempty"`
	AIConfidence     float64   `json:"ai_confidence,omitempty"`
	AnalyzedAt       time.Time `json:"analyzed_at"`
}

// FoodLogRequest represents the request to create a food log
type FoodLogRequest struct {
	FoodName string `json:"food_name,omitempty"`
	PhotoURL string `json:"photo_url,omitempty"`
	Notes    string `json:"notes,omitempty"`
}

// FoodAnalysisRequest represents the request for AI to analyze a food photo
type FoodAnalysisRequest struct {
	FoodLogID int    `json:"food_log_id" binding:"required"`
	ImageData string `json:"image_data" binding:"required"` // Base64 encoded image
}
