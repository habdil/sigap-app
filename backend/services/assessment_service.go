package services

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/repository"
)

// AssessmentService handles assessment business logic
type AssessmentService struct {
	assessmentRepo *repository.AssessmentRepository
	userRepo       *repository.UserRepository
}

// NewAssessmentService creates a new AssessmentService
func NewAssessmentService() *AssessmentService {
	return &AssessmentService{
		assessmentRepo: repository.NewAssessmentRepository(),
		userRepo:       repository.NewUserRepository(),
	}
}

// SubmitAssessment submits a new assessment and gets the risk analysis
func (s *AssessmentService) SubmitAssessment(userID int, req *models.AssessmentRequest) (*models.AssessmentResponse, error) {
	// Get user details
	user, err := s.userRepo.GetUserByID(userID)
	if err != nil {
		return nil, err
	}

	// Create assessment record
	assessment, err := s.assessmentRepo.CreateAssessment(userID, req)
	if err != nil {
		return nil, err
	}

	// Call the AI Model for risk analysis
	riskPercentage, riskFactors, recommendations, err := s.analyzeRisk(user, req)
	if err != nil {
		log.Printf("Error analyzing risk: %v", err)
		// Default values in case of error
		riskPercentage = 50
		riskFactors = []string{"Error analyzing risk", "Data not sufficient", "Try again later"}
		recommendations = []string{"Complete your profile", "Try assessment again later", "Contact support if problem persists"}
	}

	// Save the risk assessment result
	result, err := s.assessmentRepo.CreateRiskAssessmentResult(
		userID,
		assessment.ID,
		riskPercentage,
		riskFactors,
		recommendations,
	)
	if err != nil {
		return nil, err
	}

	// Create response
	response := &models.AssessmentResponse{
		Assessment: *assessment,
		Result:     *result,
	}

	return response, nil
}

// GetLatestAssessment retrieves the latest assessment for a user
func (s *AssessmentService) GetLatestAssessment(userID int) (*models.AssessmentResponse, error) {
	// Get the latest assessment
	assessment, err := s.assessmentRepo.GetLatestAssessment(userID)
	if err != nil {
		return nil, err
	}

	// Get the corresponding result
	result, err := s.assessmentRepo.GetLatestAssessmentResult(userID)
	if err != nil {
		return nil, err
	}

	// Create response
	response := &models.AssessmentResponse{
		Assessment: *assessment,
		Result:     *result,
	}

	return response, nil
}

// GetAssessmentHistory retrieves the assessment history for a user
func (s *AssessmentService) GetAssessmentHistory(userID int) ([]models.AssessmentResponse, error) {
	return s.assessmentRepo.GetAssessmentHistory(userID)
}

// analyzeRisk calls the Gemini AI model to analyze the risk
func (s *AssessmentService) analyzeRisk(user *models.User, req *models.AssessmentRequest) (int, []string, []string, error) {
	// Get the Gemini API key from environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		return 0, nil, nil, fmt.Errorf("GEMINI_API_KEY environment variable is not set")
	}

	// Prepare the prompt for Gemini
	screenTimeDesc := getScreenTimeDescription(req.ScreenTimeHours)
	exerciseDesc := getExerciseDescription(req.ExerciseHours)
	lateNightDesc := getLateNightDescription(req.LateNightFrequency)
	dietDesc := getDietDescription(req.DietQuality)

	// Use default values if user profile is incomplete
	age := 30
	if user.Age > 0 {
		age = user.Age
	}

	height := 170.0
	if user.Height > 0 {
		height = user.Height
	}

	weight := 70.0
	if user.Weight > 0 {
		weight = user.Weight
	}

	prompt := fmt.Sprintf(`You are a stroke risk assessment AI. Analyze this user profile:
Age: %d, Height: %.2f cm, Weight: %.2f kg
Screen time: %s
Exercise: %s
Late night habits: %s
Diet: %s

Return ONLY a JSON object with these fields:
- risk_percentage: an integer from 0-100
- risk_factors: array of 3 risk factors identified
- recommendations: array of 3 recommendations to reduce risk

Example response format:
{"risk_percentage": 65, "risk_factors": ["factor1", "factor2", "factor3"], "recommendations": ["recommendation1", "recommendation2", "recommendation3"]}
`, age, height, weight, screenTimeDesc, exerciseDesc, lateNightDesc, dietDesc)

	// Create the request to Gemini API - using gemini-2.0-flash as shown in the documentation
	url := "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + apiKey

	requestBody := map[string]interface{}{
		"contents": []map[string]interface{}{
			{
				"parts": []map[string]interface{}{
					{
						"text": prompt,
					},
				},
			},
		},
	}

	jsonBody, err := json.Marshal(requestBody)
	if err != nil {
		return 0, nil, nil, err
	}

	// Log the request body for debugging
	log.Printf("Gemini API request body: %s", string(jsonBody))

	// Make the request to Gemini API
	req2, err := http.NewRequest("POST", url, strings.NewReader(string(jsonBody)))
	if err != nil {
		return 0, nil, nil, err
	}
	req2.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req2)
	if err != nil {
		return 0, nil, nil, err
	}
	defer resp.Body.Close()

	// Read the response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return 0, nil, nil, err
	}

	// Log the raw response for debugging
	log.Printf("Gemini API raw response: %s", string(body))

	// Check response status
	if resp.StatusCode != http.StatusOK {
		return 0, nil, nil, fmt.Errorf("gemini API returned status code %d: %s", resp.StatusCode, string(body))
	}

	// Parse the Gemini response
	var geminiResponse map[string]interface{}
	if err := json.Unmarshal(body, &geminiResponse); err != nil {
		return 0, nil, nil, fmt.Errorf("failed to parse Gemini response: %v", err)
	}

	// Extract the text content from Gemini's response
	var text string
	candidates, ok := geminiResponse["candidates"].([]interface{})
	if !ok || len(candidates) == 0 {
		// Fallback to heuristic when no candidates
		riskPercentage := calculateRiskScore(user, req)
		riskFactors := generateRiskFactors(req)
		recommendations := generateRecommendations(req)
		return riskPercentage, riskFactors, recommendations, nil
	}

	// Navigate the response structure to find the text
	firstCandidate, ok := candidates[0].(map[string]interface{})
	if !ok {
		// Fallback to heuristic when invalid format
		riskPercentage := calculateRiskScore(user, req)
		riskFactors := generateRiskFactors(req)
		recommendations := generateRecommendations(req)
		return riskPercentage, riskFactors, recommendations, nil
	}

	content, ok := firstCandidate["content"].(map[string]interface{})
	if !ok {
		// Fallback to heuristic when content not found
		riskPercentage := calculateRiskScore(user, req)
		riskFactors := generateRiskFactors(req)
		recommendations := generateRecommendations(req)
		return riskPercentage, riskFactors, recommendations, nil
	}

	parts, ok := content["parts"].([]interface{})
	if !ok || len(parts) == 0 {
		// Fallback to heuristic when parts not found
		riskPercentage := calculateRiskScore(user, req)
		riskFactors := generateRiskFactors(req)
		recommendations := generateRecommendations(req)
		return riskPercentage, riskFactors, recommendations, nil
	}

	for _, part := range parts {
		partMap, ok := part.(map[string]interface{})
		if !ok {
			continue
		}

		if t, ok := partMap["text"].(string); ok {
			text = t
			break
		}
	}

	if text == "" {
		// Fallback to heuristic when no text found
		riskPercentage := calculateRiskScore(user, req)
		riskFactors := generateRiskFactors(req)
		recommendations := generateRecommendations(req)
		return riskPercentage, riskFactors, recommendations, nil
	}

	// Clean the text and extract JSON
	text = strings.TrimSpace(text)

	// Remove markdown code blocks if present (```json and ```)
	text = strings.ReplaceAll(text, "```json", "")
	text = strings.ReplaceAll(text, "```", "")

	// Find JSON content (handles cases where there might be text before or after the JSON)
	jsonStart := strings.Index(text, "{")
	jsonEnd := strings.LastIndex(text, "}")

	if jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart {
		text = text[jsonStart : jsonEnd+1]
	}

	log.Printf("Extracted JSON text: %s", text)

	// Parse the risk assessment result
	var result struct {
		RiskPercentage  int      `json:"risk_percentage"`
		RiskFactors     []string `json:"risk_factors"`
		Recommendations []string `json:"recommendations"`
	}

	if err := json.Unmarshal([]byte(text), &result); err != nil {
		log.Printf("Error parsing JSON from Gemini response: %v, raw text: %s", err, text)

		// Fallback: Try to create a simple heuristic assessment
		riskPercentage := calculateRiskScore(user, req)
		riskFactors := generateRiskFactors(req)
		recommendations := generateRecommendations(req)

		return riskPercentage, riskFactors, recommendations, nil
	}

	// Ensure risk factors is never nil or empty
	if result.RiskFactors == nil || len(result.RiskFactors) == 0 {
		result.RiskFactors = generateRiskFactors(req)
	}

	// Validate the results
	if result.RiskPercentage < 0 || result.RiskPercentage > 100 {
		result.RiskPercentage = calculateRiskScore(user, req) // Use heuristic if outside valid range
	}

	// Ensure we have at least one risk factor and recommendation
	if result.RiskFactors == nil || len(result.RiskFactors) == 0 {
		result.RiskFactors = generateRiskFactors(req)
	}

	if result.Recommendations == nil || len(result.Recommendations) == 0 {
		result.Recommendations = generateRecommendations(req)
	}

	// Ensure arrays are never nil
	if result.RiskFactors == nil {
		result.RiskFactors = []string{"General lifestyle factors"}
	}

	if result.Recommendations == nil {
		result.Recommendations = []string{"Consult with a healthcare professional"}
	}

	// Ensure arrays are never empty
	if len(result.RiskFactors) == 0 {
		result.RiskFactors = []string{"General lifestyle factors"}
	}

	if len(result.Recommendations) == 0 {
		result.Recommendations = []string{"Consult with a healthcare professional"}
	}

	// Limit to max 3 factors and recommendations
	if len(result.RiskFactors) > 3 {
		result.RiskFactors = result.RiskFactors[:3]
	} else {
		// Ensure we have exactly 3 risk factors
		for len(result.RiskFactors) < 3 {
			result.RiskFactors = append(result.RiskFactors, "Other lifestyle factors")
		}
	}

	if len(result.Recommendations) > 3 {
		result.Recommendations = result.Recommendations[:3]
	} else {
		// Ensure we have exactly 3 recommendations
		defaultRecs := []string{
			"Maintain a healthy diet",
			"Exercise regularly",
			"Get adequate sleep",
		}

		for i := 0; len(result.Recommendations) < 3; i++ {
			// Add default recommendations if needed
			if i < len(defaultRecs) {
				result.Recommendations = append(result.Recommendations, defaultRecs[i])
			} else {
				result.Recommendations = append(result.Recommendations, "Consult with a healthcare professional")
			}
		}
	}

	return result.RiskPercentage, result.RiskFactors, result.Recommendations, nil
}

// calculateRiskScore provides a simple heuristic for stroke risk when Gemini fails
func calculateRiskScore(user *models.User, req *models.AssessmentRequest) int {
	baseScore := 30 // Start with a base score

	// Age factor (older = higher risk)
	if user.Age > 60 {
		baseScore += 20
	} else if user.Age > 45 {
		baseScore += 10
	}

	// Screen time factor
	baseScore += (req.ScreenTimeHours - 1) * 5

	// Exercise factor (more = lower risk)
	baseScore -= (req.ExerciseHours - 1) * 5

	// Late night habits factor
	baseScore += (req.LateNightFrequency - 1) * 5

	// Diet factor
	baseScore += (req.DietQuality - 1) * 5

	// Clamp the score between 0 and 100
	if baseScore < 0 {
		baseScore = 0
	} else if baseScore > 100 {
		baseScore = 100
	}

	return baseScore
}

// generateRiskFactors creates risk factors based on assessment
func generateRiskFactors(req *models.AssessmentRequest) []string {
	factors := []string{}

	if req.ScreenTimeHours >= 3 {
		factors = append(factors, "Excessive screen time")
	}

	if req.ExerciseHours <= 2 {
		factors = append(factors, "Insufficient physical activity")
	}

	if req.LateNightFrequency >= 3 {
		factors = append(factors, "Irregular sleep patterns")
	}

	if req.DietQuality >= 3 {
		factors = append(factors, "Poor dietary habits")
	}

	// Add default factor if none identified
	if len(factors) == 0 {
		factors = append(factors, "Lifestyle factors")
	}

	// Ensure we have exactly 3 factors
	for len(factors) < 3 {
		factors = append(factors, "Other lifestyle factors")
	}

	return factors[:3]
}

// generateRecommendations creates recommendations based on assessment
func generateRecommendations(req *models.AssessmentRequest) []string {
	recommendations := []string{}

	if req.ScreenTimeHours >= 3 {
		recommendations = append(recommendations, "Reduce daily screen time to less than 4 hours")
	}

	if req.ExerciseHours <= 2 {
		recommendations = append(recommendations, "Increase physical activity to at least 30 minutes daily")
	}

	if req.LateNightFrequency >= 3 {
		recommendations = append(recommendations, "Establish regular sleep schedule")
	}

	if req.DietQuality >= 3 {
		recommendations = append(recommendations, "Improve diet with more fruits and vegetables")
	}

	// Add generic recommendations if needed
	options := []string{
		"Maintain a healthy weight",
		"Stay hydrated throughout the day",
		"Practice stress-reduction techniques",
		"Schedule regular health check-ups",
		"Monitor blood pressure regularly",
	}

	// Fill remaining slots with generic recommendations
	for i := 0; len(recommendations) < 3 && i < len(options); i++ {
		recommendations = append(recommendations, options[i])
	}

	return recommendations[:3]
}

// Helper functions to convert numeric values to descriptions
func getScreenTimeDescription(hours int) string {
	switch hours {
	case 1:
		return "just an hour"
	case 2:
		return "around 2-4 hours"
	case 3:
		return "around 5-8 hours"
	case 4:
		return "more than 9 hours per day"
	default:
		return "unknown"
	}
}

func getExerciseDescription(hours int) string {
	switch hours {
	case 1:
		return "just an hour"
	case 2:
		return "around 2-4 hours"
	case 3:
		return "around 5-8 hours"
	case 4:
		return "more than 9 hours per day"
	default:
		return "unknown"
	}
}

func getLateNightDescription(frequency int) string {
	switch frequency {
	case 1:
		return "never"
	case 2:
		return "once a week when tomorrow is a vacation day"
	case 3:
		return "about 2-4 times a week"
	case 4:
		return "every day without pause and continuously"
	default:
		return "unknown"
	}
}

func getDietDescription(quality int) string {
	switch quality {
	case 1:
		return "a regular diet with plenty of vegetables and fruit"
	case 2:
		return "a little messy but still consuming vegetables"
	case 3:
		return "messy diet and sometimes eat fast and high-fat foods"
	case 4:
		return "no vegetables, no fruits, only eat something like junk food"
	default:
		return "unknown"
	}
}
