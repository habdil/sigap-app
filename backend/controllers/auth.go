package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/services"
)

// AuthController handles authentication endpoints
type AuthController struct {
	authService *services.AuthService
}

// NewAuthController creates a new instance of AuthController
func NewAuthController() *AuthController {
	return &AuthController{
		authService: services.NewAuthService(),
	}
}

// SignUp handles the user registration
func (c *AuthController) SignUp(ctx *gin.Context) {
	var req models.SignupRequest

	// Bind the request body to the signup request struct
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Call the service to register the user
	response, err := c.authService.SignUp(req)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusCreated, response)
}

// Login handles the user login
func (c *AuthController) Login(ctx *gin.Context) {
	var req models.LoginRequest

	// Bind the request body to the login request struct
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Call the service to authenticate the user
	response, err := c.authService.Login(req)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, response)
}

// GoogleLogin handles the user login with Google
func (c *AuthController) GoogleLogin(ctx *gin.Context) {
	var req models.GoogleLoginRequest

	// Bind the request body to the Google login request struct
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Call the service to authenticate the user with Google
	response, err := c.authService.GoogleLogin(req)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	// Return the response
	ctx.JSON(http.StatusOK, response)
}

// GetCurrentUser gets the current user profile
func (c *AuthController) GetCurrentUser(ctx *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Get user from database
	user, err := c.authService.GetUserByID(userID.(int))
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	// Return the user
	ctx.JSON(http.StatusOK, user)
}

// SupabaseAuth handles authentication with Supabase (OAuth)
func (c *AuthController) SupabaseAuth(ctx *gin.Context) {
	var req models.SupabaseAuthRequest

	// Bind request body
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Proses autentikasi
	response, err := c.authService.SupabaseAuth(req)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Return hasil
	ctx.JSON(http.StatusOK, response)
}
