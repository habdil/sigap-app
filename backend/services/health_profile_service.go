package services

import (
	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/repository"
)

// HealthProfileService handles health profile business logic
type HealthProfileService struct {
	profileRepo *repository.HealthProfileRepository
}

// NewHealthProfileService creates a new HealthProfileService
func NewHealthProfileService() *HealthProfileService {
	return &HealthProfileService{
		profileRepo: repository.NewHealthProfileRepository(),
	}
}

// UpdateUserProfile updates a user's health profile
func (s *HealthProfileService) UpdateUserProfile(userID int, req *models.ProfileUpdateRequest) error {
	return s.profileRepo.UpdateUserProfile(userID, req)
}

// GetUserProfile retrieves a user's health profile
func (s *HealthProfileService) GetUserProfile(userID int) (*models.HealthProfile, error) {
	return s.profileRepo.GetUserProfile(userID)
}
