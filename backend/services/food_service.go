// services/food_service.go
package services

import (
	"encoding/base64"
	"encoding/json"
	"errors"
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

// FoodService handles food logging and analysis business logic
type FoodService struct {
	foodRepo *repository.FoodRepository
	userRepo *repository.UserRepository
}

// NewFoodService creates a new FoodService
func NewFoodService() *FoodService {
	return &FoodService{
		foodRepo: repository.NewFoodRepository(),
		userRepo: repository.NewUserRepository(),
	}
}

// LogFood logs a new food entry
func (s *FoodService) LogFood(userID int, req *models.FoodLogRequest) (*models.FoodLog, error) {
	return s.foodRepo.CreateFoodLog(userID, req)
}

// AnalyzeFood analyzes a food image using AI
func (s *FoodService) AnalyzeFood(userID int, req *models.FoodAnalysisRequest) (*models.FoodAnalysis, error) {
	// Verify the food log exists and belongs to the user
	foodLog, err := s.foodRepo.GetFoodLogByID(req.FoodLogID)
	if err != nil {
		return nil, err
	}

	if foodLog.UserID != userID {
		return nil, errors.New("unauthorized access to food log")
	}

	// Check if analysis already exists
	existingAnalysis, err := s.foodRepo.GetFoodAnalysisByLogID(req.FoodLogID)
	if err == nil && existingAnalysis != nil {
		return existingAnalysis, nil
	}

	// Perform AI analysis on the image
	analysis, err := s.analyzeImage(req.ImageData)
	if err != nil {
		return nil, err
	}

	// Save the analysis to database
	analysis.FoodLogID = req.FoodLogID
	analysis.AnalyzedAt = time.Now()

	return s.foodRepo.SaveFoodAnalysis(analysis)
}

// GetUserFoodLogs gets all food logs for a user
func (s *FoodService) GetUserFoodLogs(userID int) ([]models.FoodLog, error) {
	return s.foodRepo.GetUserFoodLogs(userID)
}

// analyzeImage uses AI to analyze food nutritional content
func (s *FoodService) analyzeImage(imageData string) (*models.FoodAnalysis, error) {
	// Check if the image data is base64 encoded
	if !strings.HasPrefix(imageData, "data:image") {
		return nil, errors.New("invalid image format: must be base64 encoded")
	}

	// Extract the base64 data
	parts := strings.Split(imageData, ",")
	if len(parts) != 2 {
		return nil, errors.New("invalid image data format")
	}

	// Decode base64 to binary
	imgBytes, err := base64.StdEncoding.DecodeString(parts[1])
	if err != nil {
		return nil, fmt.Errorf("failed to decode image: %v", err)
	}

	// Get API key from environment
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		return nil, errors.New("GEMINI_API_KEY environment variable is not set")
	}

	// Call Gemini Vision API to analyze the food
	response, err := s.callGeminiVisionAPI(apiKey, imgBytes)
	if err != nil {
		// Fallback to a mock analysis if API fails
		log.Printf("AI Analysis failed, using mock data: %v", err)
		return s.createMockAnalysis(), nil
	}

	// Parse the AI response to extract nutritional information
	analysis, err := s.parseAIResponse(response)
	if err != nil {
		log.Printf("Error parsing AI response: %v", err)
		return s.createMockAnalysis(), nil
	}

	return analysis, nil
}

// callGeminiVisionAPI calls Google's Gemini Vision API to analyze food image
func (s *FoodService) callGeminiVisionAPI(apiKey string, imageData []byte) (string, error) {
	// Encode image to base64 for API
	base64Image := base64.StdEncoding.EncodeToString(imageData)

	// Create the request payload for Gemini Vision API
	// Update model ke gemini-1.5-flash
	requestBody := map[string]interface{}{
		"contents": []map[string]interface{}{
			{
				"parts": []map[string]interface{}{
					{
						"text": "Analyze this food image and provide nutritional information. Return JSON with protein_grams, carbs_grams, fat_grams, fiber_grams, and calories. Identify the food items in the image and provide a healthiness score from 1-10.",
					},
					{
						"inlineData": map[string]interface{}{
							"mimeType": "image/jpeg",
							"data":     base64Image,
						},
					},
				},
			},
		},
	}

	jsonBody, err := json.Marshal(requestBody)
	if err != nil {
		return "", err
	}

	// Update URL endpoint untuk menggunakan model gemini-1.5-flash
	url := "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey
	req, err := http.NewRequest("POST", url, strings.NewReader(string(jsonBody)))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 30 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	// Read the response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	// Check response status
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("AI API returned status code %d: %s", resp.StatusCode, string(body))
	}

	// Extract the text from Gemini response
	var geminiResponse map[string]interface{}
	if err := json.Unmarshal(body, &geminiResponse); err != nil {
		return "", err
	}

	candidates, ok := geminiResponse["candidates"].([]interface{})
	if !ok || len(candidates) == 0 {
		return "", errors.New("no candidates in response")
	}

	firstCandidate, ok := candidates[0].(map[string]interface{})
	if !ok {
		return "", errors.New("invalid candidate format")
	}

	content, ok := firstCandidate["content"].(map[string]interface{})
	if !ok {
		return "", errors.New("no content in response")
	}

	parts, ok := content["parts"].([]interface{})
	if !ok || len(parts) == 0 {
		return "", errors.New("no parts in content")
	}

	for _, part := range parts {
		partMap, ok := part.(map[string]interface{})
		if !ok {
			continue
		}

		if text, ok := partMap["text"].(string); ok {
			return text, nil
		}
	}

	return "", errors.New("no text found in response")
}

// parseAIResponse extracts nutritional information from AI text response
func (s *FoodService) parseAIResponse(aiResponse string) (*models.FoodAnalysis, error) {
	// Clean the text and extract JSON
	text := strings.TrimSpace(aiResponse)

	// Find JSON content
	jsonStart := strings.Index(text, "{")
	jsonEnd := strings.LastIndex(text, "}")

	if jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart {
		jsonText := text[jsonStart : jsonEnd+1]

		// Try to parse the JSON
		var result struct {
			ProteinGrams     float64  `json:"protein_grams"`
			CarbsGrams       float64  `json:"carbs_grams"`
			FatGrams         float64  `json:"fat_grams"`
			FiberGrams       float64  `json:"fiber_grams"`
			Calories         int      `json:"calories"`
			DetectedItems    []string `json:"detected_items"`
			HealthinessScore int      `json:"healthiness_score"`
		}

		if err := json.Unmarshal([]byte(jsonText), &result); err != nil {
			log.Printf("Error parsing JSON from AI response: %v", err)
			return s.createMockAnalysis(), nil
		}

		// Create detected items JSON
		detectedItemsJSON, _ := json.Marshal(result.DetectedItems)

		// Create and return the analysis
		return &models.FoodAnalysis{
			ProteinGrams:     result.ProteinGrams,
			CarbsGrams:       result.CarbsGrams,
			FatGrams:         result.FatGrams,
			FiberGrams:       result.FiberGrams,
			Calories:         result.Calories,
			DetectedItems:    detectedItemsJSON,
			HealthinessScore: result.HealthinessScore,
			AIConfidence:     0.9, // Default confidence
		}, nil
	}

	// If JSON parsing fails, create mock data
	return s.createMockAnalysis(), nil
}

// createMockAnalysis creates mock nutritional data when analysis fails
func (s *FoodService) createMockAnalysis() *models.FoodAnalysis {
	// Default nutritional values
	detectedItems, _ := json.Marshal([]string{"Unknown food item"})

	return &models.FoodAnalysis{
		ProteinGrams:     15.0,
		CarbsGrams:       30.0,
		FatGrams:         10.0,
		FiberGrams:       5.0,
		Calories:         275,
		DetectedItems:    detectedItems,
		HealthinessScore: 6,
		AIConfidence:     0.5, // Lower confidence for mock data
	}
}
