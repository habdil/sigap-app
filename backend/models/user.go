package models

import (
	"time"

	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID                int       `json:"id"`
	Username          string    `json:"username"`
	Email             string    `json:"email"`
	PasswordHash      string    `json:"-"` // "-" means this field won't be included in JSON responses
	Password          string    `json:"password,omitempty"`
	FullName          string    `json:"full_name,omitempty"`
	DateOfBirth       time.Time `json:"date_of_birth,omitempty"`
	Gender            string    `json:"gender,omitempty"`
	Role              string    `json:"role,omitempty"`
	ProfilePictureURL string    `json:"profile_picture_url,omitempty"`
	IsVerified        bool      `json:"is_verified,omitempty"`
	OAuthProvider     string    `json:"oauth_provider,omitempty"`
	OAuthID           string    `json:"oauth_id,omitempty"`
	SupabaseUUID      string    `json:"supabase_uuid,omitempty"` // Tambahkan ini
	GoogleID          string    `json:"google_id,omitempty"`
	Age               int       `json:"age,omitempty"`
	Height            float64   `json:"height,omitempty"`
	Weight            float64   `json:"weight,omitempty"`
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
	LastLogin         time.Time `json:"last_login,omitempty"`
}

// HashPassword takes a plain text password and hashes it
func (u *User) HashPassword() error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	u.PasswordHash = string(hashedPassword)
	u.Password = "" // Clear the plain text password
	return nil
}

// CheckPassword compares the provided password with the stored hash
func (u *User) CheckPassword(password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(password))
	return err == nil
}

// SignupRequest represents the request body for user registration
type SignupRequest struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

// LoginRequest represents the request body for user login
type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// GoogleLoginRequest represents the request body for Google login
type GoogleLoginRequest struct {
	GoogleID string `json:"google_id" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Username string `json:"username" binding:"required"`
}

// AuthResponse represents the response for authentication endpoints
type AuthResponse struct {
	Token string `json:"token"`
	User  User   `json:"user"`
}

// ProfileUpdateRequest represents the request to update a user's profile
type ProfileUpdateRequest struct {
	Age    int     `json:"age" binding:"required"`
	Height float64 `json:"height" binding:"required"`
	Weight float64 `json:"weight" binding:"required"`
}

// SupabaseAuthRequest untuk login/register dengan Supabase
type SupabaseAuthRequest struct {
	SupabaseUUID string `json:"supabase_uuid" binding:"required"`
	Email        string `json:"email" binding:"required,email"`
	Username     string `json:"username" binding:"required"`
	GoogleID     string `json:"google_id,omitempty"`
	AvatarURL    string `json:"avatar_url,omitempty"`
}
