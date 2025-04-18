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

// GetUserByID retrieves a user by ID
func (s *AuthService) GetUserByID(id int) (*models.User, error) {
	return s.userRepo.GetUserByID(id)
}
