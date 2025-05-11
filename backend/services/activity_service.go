// services/activity_service.go
package services

import (
	"log"
	"math"
	"time"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/repository"
)

// ActivityService handles activity business logic
type ActivityService struct {
	activityRepo   *repository.ActivityRepository
	userRepo       *repository.UserRepository
	assessmentRepo *repository.AssessmentRepository
	coinRepo       *repository.CoinRepository
}

// NewActivityService creates a new ActivityService
func NewActivityService() *ActivityService {
	return &ActivityService{
		activityRepo:   repository.NewActivityRepository(),
		userRepo:       repository.NewUserRepository(),
		assessmentRepo: repository.NewAssessmentRepository(),
		coinRepo:       repository.NewCoinRepository(),
	}
}

// LogActivity logs a new activity and awards coins
func (s *ActivityService) LogActivity(userID int, req *models.ActivityLogRequest) (*models.ActivityLog, error) {
	// Calculate calories if not provided
	if req.CaloriesBurned == 0 && req.ActivityType != "Yoga" && req.ActivityType != "Badminton" {
		// Get user info for weight-based calculation
		user, err := s.userRepo.GetUserByID(userID)
		if err != nil {
			log.Printf("Error getting user for calorie calculation: %v", err)
			// Use default weight if user not found
			user = &models.User{Weight: 70.0}
		}

		// Calculate calories based on activity type and duration
		weight := user.Weight
		if weight <= 0 {
			weight = 70.0 // Default weight if not set
		}

		req.CaloriesBurned = s.calculateCalories(req.ActivityType, req.DurationMinutes, weight, req.DistanceKM)
	}

	// Calculate coins to award
	coinsEarned := s.calculateCoinsForActivity(req.ActivityType, req.DurationMinutes)

	// Create log in database
	activityLog, err := s.activityRepo.CreateActivityLog(userID, req, coinsEarned)
	if err != nil {
		return nil, err
	}

	// Award coins to user
	if coinsEarned > 0 {
		err = s.coinRepo.AddCoins(userID, coinsEarned, "Activity", activityLog.ID, "activity_logs")
		if err != nil {
			log.Printf("Error awarding coins: %v", err)
			// Continue even if coin award fails
		}
	}

	return activityLog, nil
}

// GetUserActivities gets all activities for a user
func (s *ActivityService) GetUserActivities(userID int) ([]models.ActivityLog, error) {
	return s.activityRepo.GetUserActivities(userID)
}

// GetRecommendedActivities gets activity recommendations for a user
func (s *ActivityService) GetRecommendedActivities(userID int) ([]models.ActivityRecommendation, error) {
	// First try to get existing recommendations
	recommendations, err := s.activityRepo.GetUserRecommendations(userID)
	if err == nil && len(recommendations) > 0 {
		return recommendations, nil
	}

	// If no recommendations exist or there was an error, try to generate new ones
	// based on the latest assessment
	assessment, err := s.assessmentRepo.GetLatestAssessment(userID)
	if err != nil {
		return []models.ActivityRecommendation{}, err
	}

	// Generate recommendations based on assessment data
	recommendations = s.generateActivityRecommendations(userID, assessment)

	// Save recommendations to database
	for i := range recommendations {
		_, err := s.activityRepo.SaveActivityRecommendation(&recommendations[i])
		if err != nil {
			log.Printf("Error saving recommendation: %v", err)
			// Continue even if save fails
		}
	}

	return recommendations, nil
}

// calculateCalories estimates calories burned during an activity
func (s *ActivityService) calculateCalories(activityType string, durationMinutes int, weightKg float64, distanceKm float64) int {
	// MET values (Metabolic Equivalent of Task)
	// These are approximate values
	var met float64
	switch activityType {
	case "Jogging":
		met = 7.0
	case "Running":
		met = 9.8
	case "Yoga":
		met = 3.0
	case "Badminton":
		met = 5.5
	default:
		met = 5.0 // Default for unknown activities
	}

	// Calories = MET * weight (kg) * duration (hours)
	durationHours := float64(durationMinutes) / 60.0
	calories := met * weightKg * durationHours

	return int(math.Round(calories))
}

// calculateCoinsForActivity determines coins earned from activity
func (s *ActivityService) calculateCoinsForActivity(activityType string, durationMinutes int) int {
	// Base coins per minute of activity
	var coinsPerMinute float64
	switch activityType {
	case "Running":
		coinsPerMinute = 0.5 // Higher intensity, more coins
	case "Jogging":
		coinsPerMinute = 0.4
	case "Yoga":
		coinsPerMinute = 0.3
	case "Badminton":
		coinsPerMinute = 0.4
	default:
		coinsPerMinute = 0.3
	}

	// Calculate coins with bonus for longer activities
	baseCoins := coinsPerMinute * float64(durationMinutes)

	// Add bonus for activities over 30 minutes
	var bonus float64 = 0
	if durationMinutes >= 60 {
		bonus = 10 // Big bonus for 1 hour+
	} else if durationMinutes >= 45 {
		bonus = 5
	} else if durationMinutes >= 30 {
		bonus = 3
	}

	totalCoins := baseCoins + bonus
	return int(math.Round(totalCoins))
}

// generateActivityRecommendations creates personalized activity recommendations
func (s *ActivityService) generateActivityRecommendations(userID int, assessment *models.UserAssessment) []models.ActivityRecommendation {
	recommendations := []models.ActivityRecommendation{}
	now := time.Now()

	// Recommend Yoga for high screen time and late nights
	if assessment.ScreenTimeHours >= 3 || assessment.LateNightFrequency >= 3 {
		recommendations = append(recommendations, models.ActivityRecommendation{
			UserID:               userID,
			ActivityType:         "Yoga",
			RecommendationReason: "Help reduce stress from high screen time and improve sleep quality",
			PriorityOrder:        1,
			CreatedAt:            now,
			UpdatedAt:            now,
		})
	}

	// Running for poor diet quality or low exercise
	if assessment.DietQuality >= 3 || assessment.ExerciseHours <= 2 {
		recommendations = append(recommendations, models.ActivityRecommendation{
			UserID:               userID,
			ActivityType:         "Running",
			RecommendationReason: "Boost metabolism and improve cardiovascular health",
			PriorityOrder:        len(recommendations) + 1,
			CreatedAt:            now,
			UpdatedAt:            now,
		})
	}

	// Jogging as a moderate option, especially good for beginners
	if assessment.ExerciseHours <= 1 {
		recommendations = append(recommendations, models.ActivityRecommendation{
			UserID:               userID,
			ActivityType:         "Jogging",
			RecommendationReason: "Great starting exercise for beginners with low impact",
			PriorityOrder:        len(recommendations) + 1,
			CreatedAt:            now,
			UpdatedAt:            now,
		})
	} else {
		recommendations = append(recommendations, models.ActivityRecommendation{
			UserID:               userID,
			ActivityType:         "Jogging",
			RecommendationReason: "Maintain fitness with regular moderate exercise",
			PriorityOrder:        len(recommendations) + 1,
			CreatedAt:            now,
			UpdatedAt:            now,
		})
	}

	// Badminton for social activity and fun
	recommendations = append(recommendations, models.ActivityRecommendation{
		UserID:               userID,
		ActivityType:         "Badminton",
		RecommendationReason: "Enjoy social exercise with friends while improving reflexes",
		PriorityOrder:        len(recommendations) + 1,
		CreatedAt:            now,
		UpdatedAt:            now,
	})

	return recommendations
}
