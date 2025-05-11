// repository/food_repository.go
package repository

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// FoodRepository handles database operations for food logs
type FoodRepository struct{}

// NewFoodRepository creates a new FoodRepository
func NewFoodRepository() *FoodRepository {
	return &FoodRepository{}
}

// CreateFoodLog creates a new food log entry
func (r *FoodRepository) CreateFoodLog(userID int, req *models.FoodLogRequest) (*models.FoodLog, error) {
	query := `
	INSERT INTO food_logs (user_id, food_name, notes, photo_url)
	VALUES ($1, $2, $3, $4)
	RETURNING id, log_date
	`

	foodLog := &models.FoodLog{
		UserID:   userID,
		FoodName: req.FoodName,
		Notes:    req.Notes,
		PhotoURL: req.PhotoURL,
	}

	var logDate time.Time

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		userID,
		req.FoodName,
		req.Notes,
		req.PhotoURL,
	).Scan(&foodLog.ID, &logDate)

	if err != nil {
		return nil, err
	}

	foodLog.LogDate = logDate
	return foodLog, nil
}

// GetFoodLogByID retrieves a specific food log
func (r *FoodRepository) GetFoodLogByID(logID int) (*models.FoodLog, error) {
	query := `
	SELECT id, user_id, food_name, log_date, photo_url, notes
	FROM food_logs
	WHERE id = $1
	`

	var foodLog models.FoodLog
	var foodNameNull, photoURLNull, notesNull pgtype.Text
	var logDate time.Time

	err := config.DBPool.QueryRow(context.Background(), query, logID).Scan(
		&foodLog.ID,
		&foodLog.UserID,
		&foodNameNull,
		&logDate,
		&photoURLNull,
		&notesNull,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("food log not found")
		}
		return nil, err
	}

	foodLog.LogDate = logDate

	if foodNameNull.Valid {
		foodLog.FoodName = foodNameNull.String
	}
	if photoURLNull.Valid {
		foodLog.PhotoURL = photoURLNull.String
	}
	if notesNull.Valid {
		foodLog.Notes = notesNull.String
	}

	// Try to get food analysis if it exists
	analysis, err := r.GetFoodAnalysisByLogID(logID)
	if err == nil {
		foodLog.Analysis = analysis
	}

	return &foodLog, nil
}

// GetUserFoodLogs retrieves all food logs for a user
func (r *FoodRepository) GetUserFoodLogs(userID int) ([]models.FoodLog, error) {
	query := `
	SELECT f.id, f.user_id, f.food_name, f.log_date, f.photo_url, f.notes,
	       a.id, a.protein_grams, a.carbs_grams, a.fat_grams, a.fiber_grams, 
	       a.calories, a.detected_items, a.healthiness_score, a.ai_confidence, a.analyzed_at
	FROM food_logs f
	LEFT JOIN food_analysis a ON f.id = a.food_log_id
	WHERE f.user_id = $1
	ORDER BY f.log_date DESC
	`

	rows, err := config.DBPool.Query(context.Background(), query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var foodLogs []models.FoodLog

	for rows.Next() {
		var log models.FoodLog
		var analysis models.FoodAnalysis
		var logDate, analyzedAt pgtype.Timestamp
		var foodNameNull, photoURLNull, notesNull pgtype.Text
		var analysisIDNull pgtype.Int4
		var proteinGramsNull, carbsGramsNull, fatGramsNull, fiberGramsNull, aiConfidenceNull pgtype.Float8
		var caloriesNull, healthinessScoreNull pgtype.Int4
		var detectedItemsNull []byte

		err := rows.Scan(
			&log.ID,
			&log.UserID,
			&foodNameNull,
			&logDate,
			&photoURLNull,
			&notesNull,
			&analysisIDNull,
			&proteinGramsNull,
			&carbsGramsNull,
			&fatGramsNull,
			&fiberGramsNull,
			&caloriesNull,
			&detectedItemsNull,
			&healthinessScoreNull,
			&aiConfidenceNull,
			&analyzedAt,
		)
		if err != nil {
			return nil, err
		}

		if logDate.Valid {
			log.LogDate = logDate.Time
		}
		if foodNameNull.Valid {
			log.FoodName = foodNameNull.String
		}
		if photoURLNull.Valid {
			log.PhotoURL = photoURLNull.String
		}
		if notesNull.Valid {
			log.Notes = notesNull.String
		}

		// repository/food_repository.go (lanjutan)
		// If we have analysis data, include it
		if analysisIDNull.Valid {
			analysis.ID = int(analysisIDNull.Int32)
			analysis.FoodLogID = log.ID

			if proteinGramsNull.Valid {
				analysis.ProteinGrams = proteinGramsNull.Float64
			}
			if carbsGramsNull.Valid {
				analysis.CarbsGrams = carbsGramsNull.Float64
			}
			if fatGramsNull.Valid {
				analysis.FatGrams = fatGramsNull.Float64
			}
			if fiberGramsNull.Valid {
				analysis.FiberGrams = fiberGramsNull.Float64
			}
			if caloriesNull.Valid {
				analysis.Calories = int(caloriesNull.Int32)
			}
			if detectedItemsNull != nil {
				analysis.DetectedItems = detectedItemsNull
			}
			if healthinessScoreNull.Valid {
				analysis.HealthinessScore = int(healthinessScoreNull.Int32)
			}
			if aiConfidenceNull.Valid {
				analysis.AIConfidence = aiConfidenceNull.Float64
			}
			if analyzedAt.Valid {
				analysis.AnalyzedAt = analyzedAt.Time
			}

			log.Analysis = &analysis
		}

		foodLogs = append(foodLogs, log)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return foodLogs, nil
}

// SaveFoodAnalysis saves a food analysis to the database
func (r *FoodRepository) SaveFoodAnalysis(analysis *models.FoodAnalysis) (*models.FoodAnalysis, error) {
	query := `
    INSERT INTO food_analysis (
        food_log_id, protein_grams, carbs_grams, fat_grams, fiber_grams,
        calories, detected_items, healthiness_score, ai_confidence, analyzed_at
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7::jsonb, $8, $9, $10)
    ON CONFLICT (food_log_id) 
    DO UPDATE SET
        protein_grams = EXCLUDED.protein_grams,
        carbs_grams = EXCLUDED.carbs_grams,
        fat_grams = EXCLUDED.fat_grams,
        fiber_grams = EXCLUDED.fiber_grams,
        calories = EXCLUDED.calories,
        detected_items = EXCLUDED.detected_items,
        healthiness_score = EXCLUDED.healthiness_score,
        ai_confidence = EXCLUDED.ai_confidence,
        analyzed_at = EXCLUDED.analyzed_at
    RETURNING id
    `

	// Pastikan detected_items dalam format string JSON yang valid
	var detectedItemsJSON string
	if analysis.DetectedItems != nil {
		detectedItemsJSON = string(analysis.DetectedItems)
	} else {
		// Default empty array jika nil
		detectedItemsJSON = "[]"
	}

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		analysis.FoodLogID,
		analysis.ProteinGrams,
		analysis.CarbsGrams,
		analysis.FatGrams,
		analysis.FiberGrams,
		analysis.Calories,
		detectedItemsJSON, // Gunakan string JSON
		analysis.HealthinessScore,
		analysis.AIConfidence,
		analysis.AnalyzedAt,
	).Scan(&analysis.ID)

	if err != nil {
		return nil, err
	}

	return analysis, nil
}

// GetFoodAnalysisByLogID retrieves the analysis for a specific food log
func (r *FoodRepository) GetFoodAnalysisByLogID(logID int) (*models.FoodAnalysis, error) {
	query := `
	SELECT id, food_log_id, protein_grams, carbs_grams, fat_grams, fiber_grams,
	       calories, detected_items, healthiness_score, ai_confidence, analyzed_at
	FROM food_analysis
	WHERE food_log_id = $1
	`

	var analysis models.FoodAnalysis
	var proteinGramsNull, carbsGramsNull, fatGramsNull, fiberGramsNull, aiConfidenceNull pgtype.Float8
	var caloriesNull, healthinessScoreNull pgtype.Int4
	var analyzedAt pgtype.Timestamp
	var detectedItemsNull []byte

	err := config.DBPool.QueryRow(context.Background(), query, logID).Scan(
		&analysis.ID,
		&analysis.FoodLogID,
		&proteinGramsNull,
		&carbsGramsNull,
		&fatGramsNull,
		&fiberGramsNull,
		&caloriesNull,
		&detectedItemsNull,
		&healthinessScoreNull,
		&aiConfidenceNull,
		&analyzedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("food analysis not found")
		}
		return nil, err
	}

	if proteinGramsNull.Valid {
		analysis.ProteinGrams = proteinGramsNull.Float64
	}
	if carbsGramsNull.Valid {
		analysis.CarbsGrams = carbsGramsNull.Float64
	}
	if fatGramsNull.Valid {
		analysis.FatGrams = fatGramsNull.Float64
	}
	if fiberGramsNull.Valid {
		analysis.FiberGrams = fiberGramsNull.Float64
	}
	if caloriesNull.Valid {
		analysis.Calories = int(caloriesNull.Int32)
	}
	if detectedItemsNull != nil {
		analysis.DetectedItems = detectedItemsNull
	}
	if healthinessScoreNull.Valid {
		analysis.HealthinessScore = int(healthinessScoreNull.Int32)
	}
	if aiConfidenceNull.Valid {
		analysis.AIConfidence = aiConfidenceNull.Float64
	}
	if analyzedAt.Valid {
		analysis.AnalyzedAt = analyzedAt.Time
	}

	return &analysis, nil
}
