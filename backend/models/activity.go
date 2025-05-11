// models/activity.go
package models

import "time"

// ActivityLog represents a user's physical activity record
type ActivityLog struct {
	ID               int         `json:"id"`
	UserID           int         `json:"user_id"`
	ActivityType     string      `json:"activity_type"`
	DurationMinutes  int         `json:"duration_minutes"`
	DistanceKM       float64     `json:"distance_km,omitempty"`
	CaloriesBurned   int         `json:"calories_burned,omitempty"`
	HeartRateAvg     int         `json:"heart_rate_avg,omitempty"`
	ActivityDate     time.Time   `json:"activity_date"`
	Notes            string      `json:"notes,omitempty"`
	WeatherCondition string      `json:"weather_condition,omitempty"`
	LocationData     interface{} `json:"location_data,omitempty"`
	AvgPace          float64     `json:"avg_pace,omitempty"`
	CoinsEarned      int         `json:"coins_earned"`
	MusicPlayed      string      `json:"music_played,omitempty"`
}

// ActivityLogRequest represents the request to create an activity log
type ActivityLogRequest struct {
	ActivityType     string      `json:"activity_type" binding:"required"`
	DurationMinutes  int         `json:"duration_minutes" binding:"required,min=1"`
	DistanceKM       float64     `json:"distance_km,omitempty"`
	CaloriesBurned   int         `json:"calories_burned,omitempty"`
	HeartRateAvg     int         `json:"heart_rate_avg,omitempty"`
	Notes            string      `json:"notes,omitempty"`
	WeatherCondition string      `json:"weather_condition,omitempty"`
	LocationData     interface{} `json:"location_data,omitempty"`
	AvgPace          float64     `json:"avg_pace,omitempty"`
	MusicPlayed      string      `json:"music_played,omitempty"`
}

// ActivityRecommendation represents an AI-generated activity recommendation
type ActivityRecommendation struct {
	ID                   int       `json:"id"`
	UserID               int       `json:"user_id"`
	ActivityType         string    `json:"activity_type"`
	RecommendationReason string    `json:"recommendation_reason"`
	PriorityOrder        int       `json:"priority_order"`
	CreatedAt            time.Time `json:"created_at"`
	UpdatedAt            time.Time `json:"updated_at"`
}
