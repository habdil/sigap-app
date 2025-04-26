package repository

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// HealthProfileRepository handles database operations for health profiles
type HealthProfileRepository struct{}

// NewHealthProfileRepository creates a new HealthProfileRepository
func NewHealthProfileRepository() *HealthProfileRepository {
	return &HealthProfileRepository{}
}

// UpdateUserProfile updates a user's health profile information in the users table
func (r *HealthProfileRepository) UpdateUserProfile(userID int, profile *models.ProfileUpdateRequest) error {
	query := `
	UPDATE users 
	SET age = $1, height = $2, weight = $3, updated_at = NOW()
	WHERE id = $4
	RETURNING updated_at
	`

	var updatedAt pgtype.Timestamp
	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		profile.Age,
		profile.Height,
		profile.Weight,
		userID,
	).Scan(&updatedAt)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return errors.New("user not found")
		}
		return err
	}

	return nil
}

// GetUserProfile retrieves a user's health profile
func (r *HealthProfileRepository) GetUserProfile(userID int) (*models.HealthProfile, error) {
	query := `
	SELECT id, age, height, weight, updated_at
	FROM users
	WHERE id = $1
	`

	profile := &models.HealthProfile{UserID: userID}
	var (
		id        int
		age       pgtype.Int4
		height    pgtype.Float8
		weight    pgtype.Float8
		updatedAt pgtype.Timestamp
	)

	err := config.DBPool.QueryRow(context.Background(), query, userID).Scan(
		&id,
		&age,
		&height,
		&weight,
		&updatedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	if age.Valid {
		profile.Age = int(age.Int32)
	}
	if height.Valid {
		profile.Height = height.Float64
	}
	if weight.Valid {
		profile.Weight = weight.Float64
	}
	if updatedAt.Valid {
		profile.UpdatedAt = updatedAt.Time
	}

	return profile, nil
}
