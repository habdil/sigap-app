package repository

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

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
	INSERT INTO users (username, email, password_hash, google_id, full_name, role, is_verified)
	VALUES ($1, $2, $3, $4, $5, $6, $7)
	RETURNING id, created_at, updated_at
	`

	// Set default role jika kosong
	role := user.Role
	if role == "" {
		role = "regular"
	}

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		user.Username,
		user.Email,
		user.PasswordHash,
		user.GoogleID,
		user.FullName,
		role,
		user.IsVerified,
	).Scan(&user.ID, &user.CreatedAt, &user.UpdatedAt)

	if err != nil {
		return err
	}

	return nil
}

func (r *UserRepository) GetUserByEmail(email string) (*models.User, error) {
	user := &models.User{}
	query := `
	SELECT id, username, email, password_hash, full_name, date_of_birth, gender, 
	       role, profile_picture_url, is_verified, oauth_provider, oauth_id, 
	       google_id, age, height, weight, created_at, updated_at, last_login
	FROM users 
	WHERE email = $1
	`

	var fullNameNull, genderNull, roleNull, profilePictureURLNull pgtype.Text
	var oauthProviderNull, oauthIDNull, googleIDNull pgtype.Text
	var dateOfBirthNull, lastLoginNull pgtype.Timestamp
	var isVerifiedNull pgtype.Bool
	var ageNull pgtype.Int4
	var heightNull, weightNull pgtype.Float8

	err := config.DBPool.QueryRow(context.Background(), query, email).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&user.PasswordHash,
		&fullNameNull,
		&dateOfBirthNull,
		&genderNull,
		&roleNull,
		&profilePictureURLNull,
		&isVerifiedNull,
		&oauthProviderNull,
		&oauthIDNull,
		&googleIDNull,
		&ageNull,
		&heightNull,
		&weightNull,
		&user.CreatedAt,
		&user.UpdatedAt,
		&lastLoginNull,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	// Set nilai null fields jika valid
	if fullNameNull.Valid {
		user.FullName = fullNameNull.String
	}
	if dateOfBirthNull.Valid {
		user.DateOfBirth = dateOfBirthNull.Time
	}
	if genderNull.Valid {
		user.Gender = genderNull.String
	}
	if roleNull.Valid {
		user.Role = roleNull.String
	}
	if profilePictureURLNull.Valid {
		user.ProfilePictureURL = profilePictureURLNull.String
	}
	if isVerifiedNull.Valid {
		user.IsVerified = isVerifiedNull.Bool
	}
	if oauthProviderNull.Valid {
		user.OAuthProvider = oauthProviderNull.String
	}
	if oauthIDNull.Valid {
		user.OAuthID = oauthIDNull.String
	}
	if googleIDNull.Valid {
		user.GoogleID = googleIDNull.String
	}
	if ageNull.Valid {
		user.Age = int(ageNull.Int32)
	}
	if heightNull.Valid {
		user.Height = heightNull.Float64
	}
	if weightNull.Valid {
		user.Weight = weightNull.Float64
	}
	if lastLoginNull.Valid {
		user.LastLogin = lastLoginNull.Time
	}

	return user, nil
}

// GetUserByID mengambil pengguna berdasarkan ID
func (r *UserRepository) GetUserByID(id int) (*models.User, error) {
	user := &models.User{}
	query := `
	SELECT id, username, email, password_hash, full_name, date_of_birth, gender, 
	       role, profile_picture_url, is_verified, oauth_provider, oauth_id, 
	       google_id, age, height, weight, created_at, updated_at, last_login 
	FROM users 
	WHERE id = $1
	`

	var fullNameNull, genderNull, roleNull, profilePictureURLNull pgtype.Text
	var oauthProviderNull, oauthIDNull, googleIDNull pgtype.Text
	var dateOfBirthNull, lastLoginNull pgtype.Timestamp
	var isVerifiedNull pgtype.Bool
	var ageNull pgtype.Int4
	var heightNull, weightNull pgtype.Float8

	err := config.DBPool.QueryRow(context.Background(), query, id).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&user.PasswordHash,
		&fullNameNull,
		&dateOfBirthNull,
		&genderNull,
		&roleNull,
		&profilePictureURLNull,
		&isVerifiedNull,
		&oauthProviderNull,
		&oauthIDNull,
		&googleIDNull,
		&ageNull,
		&heightNull,
		&weightNull,
		&user.CreatedAt,
		&user.UpdatedAt,
		&lastLoginNull,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	// Set nilai null fields jika valid
	if fullNameNull.Valid {
		user.FullName = fullNameNull.String
	}
	if dateOfBirthNull.Valid {
		user.DateOfBirth = dateOfBirthNull.Time
	}
	if genderNull.Valid {
		user.Gender = genderNull.String
	}
	if roleNull.Valid {
		user.Role = roleNull.String
	}
	if profilePictureURLNull.Valid {
		user.ProfilePictureURL = profilePictureURLNull.String
	}
	if isVerifiedNull.Valid {
		user.IsVerified = isVerifiedNull.Bool
	}
	if oauthProviderNull.Valid {
		user.OAuthProvider = oauthProviderNull.String
	}
	if oauthIDNull.Valid {
		user.OAuthID = oauthIDNull.String
	}
	if googleIDNull.Valid {
		user.GoogleID = googleIDNull.String
	}
	if ageNull.Valid {
		user.Age = int(ageNull.Int32)
	}
	if heightNull.Valid {
		user.Height = heightNull.Float64
	}
	if weightNull.Valid {
		user.Weight = weightNull.Float64
	}
	if lastLoginNull.Valid {
		user.LastLogin = lastLoginNull.Time
	}

	return user, nil
}

// GetUserByGoogleID mengambil pengguna berdasarkan Google ID
func (r *UserRepository) GetUserByGoogleID(googleID string) (*models.User, error) {
	user := &models.User{}
	query := `
	SELECT id, username, email, google_id, age, height, weight, created_at, updated_at 
	FROM users 
	WHERE google_id = $1
	`

	var ageNull pgtype.Int4
	var heightNull, weightNull pgtype.Float8
	var googleIDNull pgtype.Text

	err := config.DBPool.QueryRow(context.Background(), query, googleID).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&googleIDNull,
		&ageNull,
		&heightNull,
		&weightNull,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	if googleIDNull.Valid {
		user.GoogleID = googleIDNull.String
	}
	if ageNull.Valid {
		user.Age = int(ageNull.Int32)
	}
	if heightNull.Valid {
		user.Height = heightNull.Float64
	}
	if weightNull.Valid {
		user.Weight = weightNull.Float64
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

// GetUserBySupabaseUUID mengambil pengguna berdasarkan Supabase UUID
func (r *UserRepository) GetUserBySupabaseUUID(supabaseUUID string) (*models.User, error) {
	user := &models.User{}
	query := `
    SELECT id, username, email, google_id, age, height, weight, created_at, updated_at, supabase_uuid
    FROM users 
    WHERE supabase_uuid = $1
    `

	var ageNull pgtype.Int4
	var heightNull, weightNull pgtype.Float8
	var googleIDNull, supabaseUUIDNull pgtype.Text

	err := config.DBPool.QueryRow(context.Background(), query, supabaseUUID).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&googleIDNull,
		&ageNull,
		&heightNull,
		&weightNull,
		&user.CreatedAt,
		&user.UpdatedAt,
		&supabaseUUIDNull,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	if googleIDNull.Valid {
		user.GoogleID = googleIDNull.String
	}
	if supabaseUUIDNull.Valid {
		user.SupabaseUUID = supabaseUUIDNull.String
	}
	if ageNull.Valid {
		user.Age = int(ageNull.Int32)
	}
	if heightNull.Valid {
		user.Height = heightNull.Float64
	}
	if weightNull.Valid {
		user.Weight = weightNull.Float64
	}

	return user, nil
}

// CreateUserWithSupabase membuat pengguna baru menggunakan auth Supabase
func (r *UserRepository) CreateUserWithSupabase(user *models.User) error {
	query := `
    INSERT INTO users (username, email, supabase_uuid, google_id, password_hash)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING id, created_at, updated_at
    `

	// Jika tidak ada password (login Google), set password_hash kosong
	if user.PasswordHash == "" {
		user.PasswordHash = ""
	}

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		user.Username,
		user.Email,
		user.SupabaseUUID,
		user.GoogleID,
		user.PasswordHash,
	).Scan(&user.ID, &user.CreatedAt, &user.UpdatedAt)

	if err != nil {
		return err
	}

	return nil
}

// UpdateUserSupabaseInfo memperbarui informasi Supabase dan Google untuk user yang sudah ada
func (r *UserRepository) UpdateUserSupabaseInfo(userID int, supabaseUUID, googleID string) error {
	query := `
    UPDATE users 
    SET supabase_uuid = $1, google_id = $2, updated_at = NOW()
    WHERE id = $3
    `

	_, err := config.DBPool.Exec(
		context.Background(),
		query,
		supabaseUUID,
		googleID,
		userID,
	)

	return err
}
