// repository/activity_repository.go
package repository

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/jackc/pgx/v5/pgtype"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// ActivityRepository handles database operations for activities
type ActivityRepository struct{}

// NewActivityRepository creates a new ActivityRepository
func NewActivityRepository() *ActivityRepository {
	return &ActivityRepository{}
}

// CreateActivityLog creates a new activity log
func (r *ActivityRepository) CreateActivityLog(userID int, req *models.ActivityLogRequest, coinsEarned int) (*models.ActivityLog, error) {
	query := `
    INSERT INTO activity_logs (
        user_id, activity_type, duration_minutes, distance_km, calories_burned,
        heart_rate_avg, notes, weather_condition, location_data, avg_pace, coins_earned, music_played
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
    RETURNING id, activity_date
    `

	// Koreksi untuk location_data
	var locationDataParam interface{} = nil

	if req.LocationData != nil {
		// Konversi ke JSON string dulu
		locationDataJSON, err := json.Marshal(req.LocationData)
		if err != nil {
			return nil, err
		}
		// Gunakan string JSON yang valid
		locationDataParam = string(locationDataJSON)
	}

	activityLog := &models.ActivityLog{
		UserID:           userID,
		ActivityType:     req.ActivityType,
		DurationMinutes:  req.DurationMinutes,
		DistanceKM:       req.DistanceKM,
		CaloriesBurned:   req.CaloriesBurned,
		HeartRateAvg:     req.HeartRateAvg,
		Notes:            req.Notes,
		WeatherCondition: req.WeatherCondition,
		LocationData:     req.LocationData,
		AvgPace:          req.AvgPace,
		CoinsEarned:      coinsEarned,
		MusicPlayed:      req.MusicPlayed,
	}

	var activityDate time.Time

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		userID,
		req.ActivityType,
		req.DurationMinutes,
		req.DistanceKM,
		req.CaloriesBurned,
		req.HeartRateAvg,
		req.Notes,
		req.WeatherCondition,
		locationDataParam, // Gunakan parameter yang sudah diproses
		req.AvgPace,
		coinsEarned,
		req.MusicPlayed,
	).Scan(&activityLog.ID, &activityDate)

	if err != nil {
		return nil, err
	}

	activityLog.ActivityDate = activityDate
	return activityLog, nil
}

// GetUserActivities retrieves all activities for a user
func (r *ActivityRepository) GetUserActivities(userID int) ([]models.ActivityLog, error) {
	query := `
	SELECT 
		id, user_id, activity_type, duration_minutes, distance_km, calories_burned,
		heart_rate_avg, activity_date, notes, weather_condition, location_data, avg_pace, coins_earned, music_played
	FROM activity_logs
	WHERE user_id = $1
	ORDER BY activity_date DESC
	`

	rows, err := config.DBPool.Query(context.Background(), query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var activities []models.ActivityLog

	for rows.Next() {
		var activity models.ActivityLog
		var activityDate time.Time
		var distanceKMNull, avgPaceNull pgtype.Float8
		var caloriesBurnedNull, heartRateAvgNull pgtype.Int4
		var notesNull, weatherConditionNull, musicPlayedNull pgtype.Text
		var locationDataNull []byte

		err := rows.Scan(
			&activity.ID,
			&activity.UserID,
			&activity.ActivityType,
			&activity.DurationMinutes,
			&distanceKMNull,
			&caloriesBurnedNull,
			&heartRateAvgNull,
			&activityDate,
			&notesNull,
			&weatherConditionNull,
			&locationDataNull,
			&avgPaceNull,
			&activity.CoinsEarned,
			&musicPlayedNull,
		)
		if err != nil {
			return nil, err
		}

		activity.ActivityDate = activityDate

		if distanceKMNull.Valid {
			activity.DistanceKM = distanceKMNull.Float64
		}
		if caloriesBurnedNull.Valid {
			activity.CaloriesBurned = int(caloriesBurnedNull.Int32)
		}
		if heartRateAvgNull.Valid {
			activity.HeartRateAvg = int(heartRateAvgNull.Int32)
		}
		if notesNull.Valid {
			activity.Notes = notesNull.String
		}
		if weatherConditionNull.Valid {
			activity.WeatherCondition = weatherConditionNull.String
		}
		if locationDataNull != nil {
			var locationData interface{}
			if err := json.Unmarshal(locationDataNull, &locationData); err == nil {
				activity.LocationData = locationData
			}
		}
		if avgPaceNull.Valid {
			activity.AvgPace = avgPaceNull.Float64
		}
		if musicPlayedNull.Valid {
			activity.MusicPlayed = musicPlayedNull.String
		}

		activities = append(activities, activity)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return activities, nil
}

// GetUserRecommendations retrieves activity recommendations for a user
func (r *ActivityRepository) GetUserRecommendations(userID int) ([]models.ActivityRecommendation, error) {
	query := `
	SELECT 
		id, user_id, activity_type, recommendation_reason, priority_order, created_at, updated_at
	FROM activity_recommendations
	WHERE user_id = $1
	ORDER BY priority_order ASC
	`

	rows, err := config.DBPool.Query(context.Background(), query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var recommendations []models.ActivityRecommendation

	for rows.Next() {
		var rec models.ActivityRecommendation
		var createdAt, updatedAt time.Time

		err := rows.Scan(
			&rec.ID,
			&rec.UserID,
			&rec.ActivityType,
			&rec.RecommendationReason,
			&rec.PriorityOrder,
			&createdAt,
			&updatedAt,
		)
		if err != nil {
			return nil, err
		}

		rec.CreatedAt = createdAt
		rec.UpdatedAt = updatedAt

		recommendations = append(recommendations, rec)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	if len(recommendations) == 0 {
		return nil, errors.New("no recommendations found")
	}

	return recommendations, nil
}

// SaveActivityRecommendation saves or updates an activity recommendation
func (r *ActivityRepository) SaveActivityRecommendation(rec *models.ActivityRecommendation) (*models.ActivityRecommendation, error) {
	query := `
	INSERT INTO activity_recommendations (
		user_id, activity_type, recommendation_reason, priority_order, created_at, updated_at
	)
	VALUES ($1, $2, $3, $4, $5, $6)
	ON CONFLICT (user_id, activity_type) 
	DO UPDATE SET
		recommendation_reason = EXCLUDED.recommendation_reason,
		priority_order = EXCLUDED.priority_order,
		updated_at = NOW()
	RETURNING id
	`

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		rec.UserID,
		rec.ActivityType,
		rec.RecommendationReason,
		rec.PriorityOrder,
		rec.CreatedAt,
		rec.UpdatedAt,
	).Scan(&rec.ID)

	if err != nil {
		return nil, err
	}

	return rec, nil
}
