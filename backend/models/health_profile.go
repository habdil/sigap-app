package models

import "time"

// HealthProfile represents a user's health profile
type HealthProfile struct {
	UserID    int       `json:"user_id"`
	Age       int       `json:"age"`
	Height    float64   `json:"height"`
	Weight    float64   `json:"weight"`
	UpdatedAt time.Time `json:"updated_at"`
}

// CreateHealthProfileRequest represents the request to create a health profile
type CreateHealthProfileRequest struct {
	Age    int     `json:"age" binding:"required"`
	Height float64 `json:"height" binding:"required"`
	Weight float64 `json:"weight" binding:"required"`
}

// UpdateHealthProfileRequest represents the request to update a health profile
type UpdateHealthProfileRequest struct {
	Age    int     `json:"age" binding:"required"`
	Height float64 `json:"height" binding:"required"`
	Weight float64 `json:"weight" binding:"required"`
}
