package repository

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// UserRepository menangani semua operasi database untuk pengguna
type UserRepository struct{}

// NewUserRepository membuat instance baru dari UserRepository
func NewUserRepository() *UserRepository {
	return &UserRepository{}
}

// CreateUser membuat pengguna baru di database
func (r *UserRepository) CreateUser(user *models.User) error {
	query := `
	INSERT INTO users (username, email, password_hash)
	VALUES ($1, $2, $3)
	RETURNING id, created_at, updated_at
	`

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		user.Username,
		user.Email,
		user.PasswordHash,
	).Scan(&user.ID, &user.CreatedAt, &user.UpdatedAt)

	if err != nil {
		return err
	}

	return nil
}

// GetUserByEmail mengambil pengguna berdasarkan email
func (r *UserRepository) GetUserByEmail(email string) (*models.User, error) {
	user := &models.User{}
	query := `
	SELECT id, username, email, password_hash, created_at, updated_at 
	FROM users 
	WHERE email = $1
	`

	err := config.DBPool.QueryRow(context.Background(), query, email).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&user.PasswordHash,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	return user, nil
}

// GetUserByID mengambil pengguna berdasarkan ID
func (r *UserRepository) GetUserByID(id int) (*models.User, error) {
	user := &models.User{}
	query := `
	SELECT id, username, email, created_at, updated_at 
	FROM users 
	WHERE id = $1
	`

	err := config.DBPool.QueryRow(context.Background(), query, id).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	return user, nil
}

// IsEmailTaken memeriksa apakah email sudah digunakan
func (r *UserRepository) IsEmailTaken(email string) (bool, error) {
	var exists bool
	query := `SELECT EXISTS(SELECT 1 FROM users WHERE email = $1)`

	err := config.DBPool.QueryRow(context.Background(), query, email).Scan(&exists)
	if err != nil {
		return false, err
	}

	return exists, nil
}

// IsUsernameTaken memeriksa apakah username sudah digunakan
func (r *UserRepository) IsUsernameTaken(username string) (bool, error) {
	var exists bool
	query := `SELECT EXISTS(SELECT 1 FROM users WHERE username = $1)`

	err := config.DBPool.QueryRow(context.Background(), query, username).Scan(&exists)
	if err != nil {
		return false, err
	}

	return exists, nil
}
