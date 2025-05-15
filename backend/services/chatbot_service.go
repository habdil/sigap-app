// services/chatbot_service.go
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

// ChatbotService handles chatbot business logic
type ChatbotService struct {
	chatbotRepo *repository.ChatbotRepository
	userRepo    *repository.UserRepository
}

// NewChatbotService creates a new ChatbotService
func NewChatbotService() *ChatbotService {
	return &ChatbotService{
		chatbotRepo: repository.NewChatbotRepository(),
		userRepo:    repository.NewUserRepository(),
	}
}

// CreateConversation creates a new conversation
func (s *ChatbotService) CreateConversation(userID int, title string) (*models.ChatbotConversation, error) {
	// If no title provided, generate a default title
	if title == "" {
		title = fmt.Sprintf("Conversation %s", time.Now().Format("Jan 2, 2006"))
	}

	// Create conversation
	conversation, err := s.chatbotRepo.CreateConversation(userID, title)
	if err != nil {
		return nil, err
	}

	// Create initial greeting message from bot
	greeting := "Hello! I'm the AI Health Assistant for the SIGAP app. I can help you with questions about health, physical activity, and lifestyle. How can I assist you today?"

	_, err = s.chatbotRepo.AddMessage(userID, conversation.ID, greeting, "bot", nil)
	if err != nil {
		log.Printf("Warning: Could not add initial bot message: %v", err)
		// Continue even if greeting fails
	}

	return conversation, nil
}

// GetConversation retrieves a conversation by ID
func (s *ChatbotService) GetConversation(conversationID int, userID int) (*models.ChatbotConversation, error) {
	return s.chatbotRepo.GetConversation(conversationID, userID)
}

// GetUserConversations retrieves all conversations for a user
func (s *ChatbotService) GetUserConversations(userID int) ([]models.ChatbotConversation, error) {
	return s.chatbotRepo.GetUserConversations(userID)
}

// SendMessage sends a user message and gets a bot response
func (s *ChatbotService) SendMessage(userID int, conversationID int, content string) (*models.ChatMessage, *models.ChatMessage, error) {
	// Add user message to conversation
	userMessage, err := s.chatbotRepo.AddMessage(userID, conversationID, content, "user", nil)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to add user message: %v", err)
	}

	// Get user information for context
	user, err := s.userRepo.GetUserByID(userID)
	if err != nil {
		log.Printf("Warning: Could not get user info: %v", err)
		// Continue with minimal context
	}

	// Get conversation history for context
	messages, err := s.chatbotRepo.GetMessagesByConversation(conversationID)
	if err != nil {
		log.Printf("Warning: Could not get conversation history: %v", err)
		// Continue with minimal context
	}

	// Generate bot response
	botResponse, err := s.generateBotResponse(content, user, messages)
	if err != nil {
		log.Printf("Error generating bot response: %v", err)
		// Use fallback response
		botResponse = "Maaf, saya mengalami kendala dalam memproses permintaan Anda. Mohon coba lagi."
	}

	// Modifikasi: Perhatikan struktur metadata
	// Gunakan struktur metadata yang lebih sederhana
	metadata := map[string]interface{}{
		"time_ms": time.Now().Sub(userMessage.CreatedAt).Milliseconds(),
	}

	// Try to add bot message
	botMessage, err := s.chatbotRepo.AddMessage(userID, conversationID, botResponse, "bot", metadata)
	if err != nil {
		// Return user message with error for bot message
		return userMessage, nil, fmt.Errorf("failed to add bot message: %v", err)
	}

	return userMessage, botMessage, nil
}

// GetMessages gets all messages for a conversation
func (s *ChatbotService) GetMessages(conversationID int, userID int) ([]models.ChatMessage, error) {
	// First check if the user has access to this conversation
	conversation, err := s.chatbotRepo.GetConversation(conversationID, userID)
	if err != nil {
		return nil, err
	}

	if conversation.UserID != userID {
		return nil, fmt.Errorf("access denied to conversation")
	}

	return s.chatbotRepo.GetMessagesByConversation(conversationID)
}

// DeleteConversation deletes a conversation
func (s *ChatbotService) DeleteConversation(conversationID int, userID int) error {
	return s.chatbotRepo.DeleteConversation(conversationID, userID)
}

// generateBotResponse calls the AI API to generate a response
func (s *ChatbotService) generateBotResponse(userMessage string, user *models.User, conversationHistory []models.ChatMessage) (string, error) {
	// Get the Gemini API key from environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		return "", fmt.Errorf("GEMINI_API_KEY environment variable is not set")
	}

	// Buat format payload yang benar untuk Gemini 1.5
	// Format ini berbeda dari versi sebelumnya yang menggunakan role
	systemPrompt := "Kamu adalah AI Health Assistant untuk aplikasi SIGAP, fokus pada gaya hidup sehat dan pencegahan stroke. " +
		"Berikan saran tentang olahraga, nutrisi, dan manajemen stres. " +
		"Jawab dengan sopan, informatif, jangan di bold responnya apapun pertanyaan saya dan singkat dalam bahasa Inggris. " +
		"Jangan lupa untuk sesekali mengingatkan pentingnya aktivitas fisik, pola makan sehat, dan istirahat yang cukup."

	// Format untuk Gemini 1.5 menggunakan parts dalam contents
	contents := []map[string]interface{}{
		{
			"parts": []map[string]interface{}{
				{
					"text": systemPrompt,
				},
			},
			"role": "user", // Untuk Gemini 1.5, peran sistem diganti dengan user
		},
	}

	// Tambahkan informasi pengguna jika tersedia
	if user != nil {
		userContext := fmt.Sprintf("Informasi pengguna: Usia: %d, Tinggi: %.1f cm, Berat: %.1f kg.",
			user.Age, user.Height, user.Weight)

		contents = append(contents, map[string]interface{}{
			"parts": []map[string]interface{}{
				{
					"text": userContext,
				},
			},
			"role": "user",
		})
	}

	// Tambahkan histori percakapan (maksimal 5 pesan terakhir)
	historyLimit := 5
	if len(conversationHistory) > 0 {
		startIdx := 0
		if len(conversationHistory) > historyLimit {
			startIdx = len(conversationHistory) - historyLimit
		}

		for _, msg := range conversationHistory[startIdx:] {
			role := "user"
			if msg.SenderType == "bot" {
				role = "model" // Untuk Gemini 1.5, peran assistant diganti dengan model
			}

			contents = append(contents, map[string]interface{}{
				"parts": []map[string]interface{}{
					{
						"text": msg.Content,
					},
				},
				"role": role,
			})
		}
	}

	// Tambahkan pesan pengguna saat ini
	contents = append(contents, map[string]interface{}{
		"parts": []map[string]interface{}{
			{
				"text": userMessage,
			},
		},
		"role": "user",
	})

	// Buat request untuk Gemini API
	url := "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey

	requestBody := map[string]interface{}{
		"contents": contents,
		"safetySettings": []map[string]interface{}{
			{
				"category":  "HARM_CATEGORY_HARASSMENT",
				"threshold": "BLOCK_MEDIUM_AND_ABOVE",
			},
			{
				"category":  "HARM_CATEGORY_HATE_SPEECH",
				"threshold": "BLOCK_MEDIUM_AND_ABOVE",
			},
			{
				"category":  "HARM_CATEGORY_SEXUALLY_EXPLICIT",
				"threshold": "BLOCK_MEDIUM_AND_ABOVE",
			},
			{
				"category":  "HARM_CATEGORY_DANGEROUS_CONTENT",
				"threshold": "BLOCK_MEDIUM_AND_ABOVE",
			},
		},
		"generationConfig": map[string]interface{}{
			"temperature":     0.7,
			"topP":            0.8,
			"topK":            40,
			"maxOutputTokens": 1024,
		},
	}

	// Tambahkan logging untuk debug
	jsonBodyDebug, _ := json.MarshalIndent(requestBody, "", "  ")
	log.Printf("Request to Gemini API: %s", string(jsonBodyDebug))

	jsonBody, err := json.Marshal(requestBody)
	if err != nil {
		return "", err
	}

	req, err := http.NewRequest("POST", url, strings.NewReader(string(jsonBody)))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 20 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	// Baca respons
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	// Tambahkan logging respons untuk debug
	log.Printf("Response from Gemini API: %s", string(body))

	// Periksa status respons
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("Gemini API returned status code %d: %s", resp.StatusCode, string(body))
	}

	// Parse respons
	var geminiResponse map[string]interface{}
	if err := json.Unmarshal(body, &geminiResponse); err != nil {
		return "", fmt.Errorf("failed to parse API response: %v", err)
	}

	// Ekstrak teks dari respons
	candidates, ok := geminiResponse["candidates"].([]interface{})
	if !ok || len(candidates) == 0 {
		return "", fmt.Errorf("no candidates in response")
	}

	candidate, ok := candidates[0].(map[string]interface{})
	if !ok {
		return "", fmt.Errorf("invalid candidate format")
	}

	content, ok := candidate["content"].(map[string]interface{})
	if !ok {
		return "", fmt.Errorf("no content in response")
	}

	parts, ok := content["parts"].([]interface{})
	if !ok || len(parts) == 0 {
		return "", fmt.Errorf("no parts in content")
	}

	// Log untuk debug
	log.Printf("Parts from response: %+v", parts)

	for _, part := range parts {
		partMap, ok := part.(map[string]interface{})
		if !ok {
			log.Printf("Part is not a map: %+v", part)
			continue
		}

		text, ok := partMap["text"].(string)
		if !ok {
			log.Printf("Part does not contain text: %+v", partMap)
			continue
		}

		return text, nil
	}

	// Jika tidak ada teks yang ditemukan, kembalikan respons default
	return "Maaf, saya tidak dapat memberikan respons saat ini. Silakan coba lagi nanti.", nil
}
