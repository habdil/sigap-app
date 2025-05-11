package repository

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// AssessmentRepository handles database operations for assessments
type AssessmentRepository struct{}

// NewAssessmentRepository creates a new AssessmentRepository
func NewAssessmentRepository() *AssessmentRepository {
	return &AssessmentRepository{}
}

// CreateAssessment creates a new assessment
func (r *AssessmentRepository) CreateAssessment(userID int, req *models.AssessmentRequest) (*models.UserAssessment, error) {
	query := `
	INSERT INTO user_assessments (user_id, screen_time_hours, exercise_hours, late_night_frequency, diet_quality)
	VALUES ($1, $2, $3, $4, $5)
	RETURNING id, created_at, updated_at
	`

	assessment := &models.UserAssessment{
		UserID:             userID,
		ScreenTimeHours:    req.ScreenTimeHours,
		ExerciseHours:      req.ExerciseHours,
		LateNightFrequency: req.LateNightFrequency,
		DietQuality:        req.DietQuality,
	}

	var createdAt, updatedAt time.Time

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		userID,
		req.ScreenTimeHours,
		req.ExerciseHours,
		req.LateNightFrequency,
		req.DietQuality,
	).Scan(&assessment.ID, &createdAt, &updatedAt)

	if err != nil {
		return nil, err
	}

	assessment.CreatedAt = createdAt
	assessment.UpdatedAt = updatedAt

	return assessment, nil
}

// CreateRiskAssessmentResult creates a new risk assessment result
func (r *AssessmentRepository) CreateRiskAssessmentResult(userID int, assessmentID int, riskPercentage int, riskFactors []string, recommendations []string) (*models.RiskAssessmentResult, error) {
	// Set default values if null or empty
	if riskFactors == nil || len(riskFactors) == 0 {
		riskFactors = []string{"Unknown risk factor"}
	}

	if recommendations == nil || len(recommendations) == 0 {
		recommendations = []string{"Consult with a healthcare professional"}
	}

	// Log the values being inserted
	log.Printf("Inserting risk assessment with factors: %v and recommendations: %v", riskFactors, recommendations)

	// Convert slices to JSON objects
	riskFactorsJSON, err := json.Marshal(riskFactors)
	if err != nil {
		log.Printf("Error marshaling risk factors to JSON: %v", err)
		return nil, err
	}

	recommendationsJSON, err := json.Marshal(recommendations)
	if err != nil {
		log.Printf("Error marshaling recommendations to JSON: %v", err)
		return nil, err
	}

	// Use query with explicit JSONB cast
	query := `
    INSERT INTO risk_assessment_results (user_id, assessment_id, risk_percentage, risk_factors, recommendations)
    VALUES ($1, $2, $3, $4::jsonb, $5::jsonb)
    RETURNING id, created_at
    `

	result := &models.RiskAssessmentResult{
		UserID:          userID,
		AssessmentID:    assessmentID,
		RiskPercentage:  riskPercentage,
		RiskFactors:     riskFactors,
		Recommendations: recommendations,
	}

	var createdAt time.Time

	// Execute the query with JSON strings
	err = config.DBPool.QueryRow(
		context.Background(),
		query,
		userID,
		assessmentID,
		riskPercentage,
		string(riskFactorsJSON),     // Convert []byte to string with explicit JSONB cast in query
		string(recommendationsJSON), // Convert []byte to string with explicit JSONB cast in query
	).Scan(&result.ID, &createdAt)

	if err != nil {
		log.Printf("Error creating risk assessment result: %v", err)
		return nil, err
	}

	result.CreatedAt = createdAt
	return result, nil
}

// GetLatestAssessment retrieves the latest assessment for a user
func (r *AssessmentRepository) GetLatestAssessment(userID int) (*models.UserAssessment, error) {
	query := `
	SELECT 
		id, 
		user_id, 
		screen_time_hours, 
		exercise_hours, 
		late_night_frequency, 
		diet_quality, 
		created_at, 
		updated_at
	FROM 
		user_assessments
	WHERE 
		user_id = $1
	ORDER BY 
		created_at DESC
	LIMIT 1
	`

	var assessment models.UserAssessment
	var createdAt, updatedAt time.Time

	err := config.DBPool.QueryRow(context.Background(), query, userID).Scan(
		&assessment.ID,
		&assessment.UserID,
		&assessment.ScreenTimeHours,
		&assessment.ExerciseHours,
		&assessment.LateNightFrequency,
		&assessment.DietQuality,
		&createdAt,
		&updatedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("no assessment found for this user")
		}
		return nil, err
	}

	assessment.CreatedAt = createdAt
	assessment.UpdatedAt = updatedAt

	return &assessment, nil
}

// GetLatestAssessmentResult retrieves the latest assessment result for a user
func (r *AssessmentRepository) GetLatestAssessmentResult(userID int) (*models.RiskAssessmentResult, error) {
	query := `
	SELECT 
		id, 
		user_id, 
		assessment_id, 
		risk_percentage, 
		risk_factors, 
		recommendations, 
		created_at
	FROM 
		risk_assessment_results
	WHERE 
		user_id = $1
	ORDER BY 
		created_at DESC
	LIMIT 1
	`

	var result models.RiskAssessmentResult
	var createdAt time.Time
	var riskFactorsJSON, recommendationsJSON []byte

	err := config.DBPool.QueryRow(context.Background(), query, userID).Scan(
		&result.ID,
		&result.UserID,
		&result.AssessmentID,
		&result.RiskPercentage,
		&riskFactorsJSON,
		&recommendationsJSON,
		&createdAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("no assessment result found for this user")
		}
		return nil, err
	}

	result.CreatedAt = createdAt

	// Parse JSON data untuk risk factors
	if err := json.Unmarshal(riskFactorsJSON, &result.RiskFactors); err != nil {
		log.Printf("Error unmarshaling risk factors: %v", err)
		result.RiskFactors = []string{"Error parsing risk factors"}
	}

	// Parse JSON data untuk recommendations
	if err := json.Unmarshal(recommendationsJSON, &result.Recommendations); err != nil {
		log.Printf("Error unmarshaling recommendations: %v", err)
		result.Recommendations = []string{"Error parsing recommendations"}
	}

	return &result, nil
}

// GetAssessmentHistory retrieves the assessment history for a user
func (r *AssessmentRepository) GetAssessmentHistory(userID int) ([]models.AssessmentResponse, error) {
	query := `
	WITH assessments AS (
		SELECT 
			a.id, 
			a.user_id, 
			a.screen_time_hours, 
			a.exercise_hours, 
			a.late_night_frequency, 
			a.diet_quality, 
			a.created_at, 
			a.updated_at
		FROM 
			user_assessments a
		WHERE 
			a.user_id = $1
		ORDER BY 
			a.created_at DESC
	)
	SELECT 
		a.id, 
		a.user_id, 
		a.screen_time_hours, 
		a.exercise_hours, 
		a.late_night_frequency, 
		a.diet_quality, 
		a.created_at, 
		a.updated_at,
		r.id,
		r.assessment_id,
		r.risk_percentage,
		r.risk_factors,
		r.recommendations,
		r.created_at
	FROM 
		assessments a
	LEFT JOIN 
		risk_assessment_results r ON a.id = r.assessment_id
	ORDER BY 
		a.created_at DESC
	`

	rows, err := config.DBPool.Query(context.Background(), query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var results []models.AssessmentResponse

	for rows.Next() {
		var resp models.AssessmentResponse
		var assessment models.UserAssessment
		var result models.RiskAssessmentResult
		var assessmentCreatedAt, assessmentUpdatedAt, resultCreatedAt pgtype.Timestamp
		var resultID, assessmentID pgtype.Int4
		var riskPercentage pgtype.Int4
		var riskFactorsJSON, recommendationsJSON []byte

		err := rows.Scan(
			&assessment.ID,
			&assessment.UserID,
			&assessment.ScreenTimeHours,
			&assessment.ExerciseHours,
			&assessment.LateNightFrequency,
			&assessment.DietQuality,
			&assessmentCreatedAt,
			&assessmentUpdatedAt,
			&resultID,
			&assessmentID,
			&riskPercentage,
			&riskFactorsJSON,
			&recommendationsJSON,
			&resultCreatedAt,
		)
		if err != nil {
			return nil, err
		}

		if assessmentCreatedAt.Valid {
			assessment.CreatedAt = assessmentCreatedAt.Time
		}
		if assessmentUpdatedAt.Valid {
			assessment.UpdatedAt = assessmentUpdatedAt.Time
		}

		resp.Assessment = assessment

		if resultID.Valid {
			result.ID = int(resultID.Int32)
			result.UserID = userID
			result.AssessmentID = int(assessmentID.Int32)
			if riskPercentage.Valid {
				result.RiskPercentage = int(riskPercentage.Int32)
			}

			// Parse JSON data
			var riskFactors []string
			if err := json.Unmarshal(riskFactorsJSON, &riskFactors); err != nil {
				log.Printf("Error unmarshaling risk factors: %v", err)
				riskFactors = []string{"Error parsing risk factors"}
			}
			result.RiskFactors = riskFactors

			var recommendations []string
			if err := json.Unmarshal(recommendationsJSON, &recommendations); err != nil {
				log.Printf("Error unmarshaling recommendations: %v", err)
				recommendations = []string{"Error parsing recommendations"}
			}
			result.Recommendations = recommendations

			if resultCreatedAt.Valid {
				result.CreatedAt = resultCreatedAt.Time
			}

			resp.Result = result
		}

		results = append(results, resp)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return results, nil
}
