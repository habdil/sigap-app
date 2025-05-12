package services

import (
	"errors"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/repository"
	"github.com/habdil/sigap-app/backend/utils"
)

// AuthService handles authentication business logic
type AuthService struct {
	userRepo *repository.UserRepository
}

// NewAuthService creates a new instance of AuthService
func NewAuthService() *AuthService {
	return &AuthService{
		userRepo: repository.NewUserRepository(),
	}
}

// SignUp registers a new user
func (s *AuthService) SignUp(req models.SignupRequest) (*models.AuthResponse, error) {
	// Check if email is already taken
	emailTaken, err := s.userRepo.IsEmailTaken(req.Email)
	if err != nil {
		return nil, err
	}
	if emailTaken {
		return nil, errors.New("email already in use")
	}

	// Check if username is already taken
	usernameTaken, err := s.userRepo.IsUsernameTaken(req.Username)
	if err != nil {
		return nil, err
	}
	if usernameTaken {
		return nil, errors.New("username already in use")
	}

	// Create user
	user := &models.User{
		Username: req.Username,
		Email:    req.Email,
		Password: req.Password,
	}

	// Hash password
	if err := user.HashPassword(); err != nil {
		return nil, err
	}

	// Save user to database
	if err := s.userRepo.CreateUser(user); err != nil {
		return nil, err
	}

	// Generate JWT token
	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		return nil, err
	}

	// Create response
	response := &models.AuthResponse{
		Token: token,
		User:  *user,
	}

	return response, nil
}

// Login authenticates a user
func (s *AuthService) Login(req models.LoginRequest) (*models.AuthResponse, error) {
	// Get user by email
	user, err := s.userRepo.GetUserByEmail(req.Email)
	if err != nil {
		return nil, errors.New("invalid email or password")
	}

	// Check password
	if !user.CheckPassword(req.Password) {
		return nil, errors.New("invalid email or password")
	}

	// Generate JWT token
	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		return nil, err
	}

	// Create response
	response := &models.AuthResponse{
		Token: token,
		User:  *user,
	}

	return response, nil
}

// GoogleLogin authenticates or creates a user using Google credentials
func (s *AuthService) GoogleLogin(req models.GoogleLoginRequest) (*models.AuthResponse, error) {
	// Check if user with Google ID exists
	user, err := s.userRepo.GetUserByGoogleID(req.GoogleID)
	if err != nil {
		// User does not exist, create new user
		emailTaken, err := s.userRepo.IsEmailTaken(req.Email)
		if err != nil {
			return nil, err
		}
		if emailTaken {
			return nil, errors.New("email already in use by another account")
		}

		// Create user
		user = &models.User{
			Username: req.Username,
			Email:    req.Email,
			GoogleID: req.GoogleID,
			// No password for Google login
		}

		// Save user to database
		if err := s.userRepo.CreateUser(user); err != nil {
			return nil, err
		}
	}

	// Generate JWT token
	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		return nil, err
	}

	// Create response
	response := &models.AuthResponse{
		Token: token,
		User:  *user,
	}

	return response, nil
}

// GetUserByID retrieves a user by ID
func (s *AuthService) GetUserByID(id int) (*models.User, error) {
	return s.userRepo.GetUserByID(id)
}

// SupabaseAuth handles authentication with Supabase
func (s *AuthService) SupabaseAuth(req models.SupabaseAuthRequest) (*models.AuthResponse, error) {
	// Coba cari user berdasarkan supabase_uuid
	user, err := s.userRepo.GetUserBySupabaseUUID(req.SupabaseUUID)
	if err == nil {
		// User ditemukan, generate token
		token, err := utils.GenerateToken(user.ID)
		if err != nil {
			return nil, err
		}

		return &models.AuthResponse{
			Token: token,
			User:  *user,
		}, nil
	}

	// Coba cari user berdasarkan email
	user, err = s.userRepo.GetUserByEmail(req.Email)
	if err == nil {
		// User sudah ada, perbarui dengan supabase_uuid
		err = s.userRepo.UpdateUserSupabaseInfo(user.ID, req.SupabaseUUID, req.GoogleID)
		if err != nil {
			return nil, err
		}

		// Ambil user yang sudah diupdate
		user, err = s.userRepo.GetUserByID(user.ID)
		if err != nil {
			return nil, err
		}

		// Generate token
		token, err := utils.GenerateToken(user.ID)
		if err != nil {
			return nil, err
		}

		return &models.AuthResponse{
			Token: token,
			User:  *user,
		}, nil
	}

	// User baru, buat user
	user = &models.User{
		Username:     req.Username,
		Email:        req.Email,
		SupabaseUUID: req.SupabaseUUID,
		GoogleID:     req.GoogleID,
	}

	// Simpan user baru
	if err := s.userRepo.CreateUserWithSupabase(user); err != nil {
		return nil, err
	}

	// Generate token
	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		return nil, err
	}

	return &models.AuthResponse{
		Token: token,
		User:  *user,
	}, nil
}
