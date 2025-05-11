// repository/chatbot_repository.go (perbaikan)
package repository

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// ChatbotRepository handles database operations for chatbot conversations and messages
type ChatbotRepository struct{}

// NewChatbotRepository creates a new ChatbotRepository
func NewChatbotRepository() *ChatbotRepository {
	return &ChatbotRepository{}
}

// CreateConversation creates a new conversation
func (r *ChatbotRepository) CreateConversation(userID int, title string) (*models.ChatbotConversation, error) {
	query := `
    INSERT INTO chatbot_conversations (user_id, title, created_at, updated_at, is_active)
    VALUES ($1, $2, NOW(), NOW(), TRUE)
    RETURNING id, created_at, updated_at
    `

	conversation := &models.ChatbotConversation{
		UserID:   userID,
		Title:    title,
		IsActive: true,
	}

	var createdAt, updatedAt time.Time

	err := config.DBPool.QueryRow(
		context.Background(),
		query,
		userID,
		title,
	).Scan(&conversation.ID, &createdAt, &updatedAt)

	if err != nil {
		return nil, err
	}

	conversation.CreatedAt = createdAt
	conversation.UpdatedAt = updatedAt

	return conversation, nil
}

// GetConversation retrieves a conversation by ID
func (r *ChatbotRepository) GetConversation(conversationID int, userID int) (*models.ChatbotConversation, error) {
	query := `
    SELECT id, user_id, title, created_at, updated_at, is_active
    FROM chatbot_conversations
    WHERE id = $1 AND user_id = $2
    `

	var conversation models.ChatbotConversation
	var createdAt, updatedAt time.Time

	err := config.DBPool.QueryRow(context.Background(), query, conversationID, userID).Scan(
		&conversation.ID,
		&conversation.UserID,
		&conversation.Title,
		&createdAt,
		&updatedAt,
		&conversation.IsActive,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("conversation not found or access denied")
		}
		return nil, err
	}

	conversation.CreatedAt = createdAt
	conversation.UpdatedAt = updatedAt

	// Get messages for the conversation
	messages, err := r.GetMessagesByConversation(conversationID)
	if err == nil {
		conversation.Messages = messages
	}

	return &conversation, nil
}

// GetUserConversations retrieves all conversations for a user
func (r *ChatbotRepository) GetUserConversations(userID int) ([]models.ChatbotConversation, error) {
	query := `
    SELECT id, user_id, title, created_at, updated_at, is_active
    FROM chatbot_conversations
    WHERE user_id = $1
    ORDER BY updated_at DESC
    `

	rows, err := config.DBPool.Query(context.Background(), query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var conversations []models.ChatbotConversation

	for rows.Next() {
		var conversation models.ChatbotConversation
		var createdAt, updatedAt time.Time

		err := rows.Scan(
			&conversation.ID,
			&conversation.UserID,
			&conversation.Title,
			&createdAt,
			&updatedAt,
			&conversation.IsActive,
		)
		if err != nil {
			return nil, err
		}

		conversation.CreatedAt = createdAt
		conversation.UpdatedAt = updatedAt

		conversations = append(conversations, conversation)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return conversations, nil
}

// AddMessage adds a message to a conversation
func (r *ChatbotRepository) AddMessage(userID int, conversationID int, content string, senderType string, metadata map[string]interface{}) (*models.ChatMessage, error) {
	// First verify the conversation exists and belongs to the user
	query := `
    SELECT id FROM chatbot_conversations
    WHERE id = $1 AND user_id = $2
    `

	var convoID int
	err := config.DBPool.QueryRow(context.Background(), query, conversationID, userID).Scan(&convoID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("conversation not found or access denied")
		}
		return nil, err
	}

	// Modifikasi: Handle metadata dengan benar
	var metadataParam interface{} = nil

	if metadata != nil {
		metadataBytes, err := json.Marshal(metadata)
		if err != nil {
			log.Printf("Error marshaling metadata to JSON: %v", err)
			// Use empty JSON object if marshaling fails
			metadataParam = "{}"
		} else {
			// Convert to string for PostgreSQL JSONB type
			metadataParam = string(metadataBytes)
		}
	} else {
		// Use valid empty JSON object
		metadataParam = "{}"
	}

	// Insert the message
	insertQuery := `
    INSERT INTO chat_messages (conversation_id, user_id, content, sender_type, created_at, metadata)
    VALUES ($1, $2, $3, $4, NOW(), $5::jsonb)
    RETURNING id, created_at
    `

	message := &models.ChatMessage{
		ConversationID: conversationID,
		UserID:         userID,
		Content:        content,
		SenderType:     senderType,
		MetadataMap:    metadata,
	}

	var createdAt time.Time

	// Execute with explicit JSONB cast
	err = config.DBPool.QueryRow(
		context.Background(),
		insertQuery,
		conversationID,
		userID,
		content,
		senderType,
		metadataParam, // Pass as string with explicit JSONB cast
	).Scan(&message.ID, &createdAt)

	if err != nil {
		log.Printf("Error inserting message: %v", err)
		return nil, fmt.Errorf("failed to save message: %v", err)
	}

	message.CreatedAt = createdAt

	// Update the conversation's updated_at timestamp
	updateQuery := `
    UPDATE chatbot_conversations
    SET updated_at = NOW()
    WHERE id = $1
    `

	_, err = config.DBPool.Exec(context.Background(), updateQuery, conversationID)
	if err != nil {
		// Non-critical error, log but continue
		log.Printf("Warning: Error updating conversation timestamp: %v", err)
	}

	return message, nil
}

// GetMessagesByConversation gets all messages for a conversation
func (r *ChatbotRepository) GetMessagesByConversation(conversationID int) ([]models.ChatMessage, error) {
	query := `
    SELECT id, conversation_id, user_id, content, sender_type, created_at, metadata
    FROM chat_messages
    WHERE conversation_id = $1
    ORDER BY created_at ASC
    `

	rows, err := config.DBPool.Query(context.Background(), query, conversationID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var messages []models.ChatMessage

	for rows.Next() {
		var message models.ChatMessage
		var createdAt time.Time
		// Gunakan pgx.NullString untuk metadata
		var metadataNull pgtype.Text

		err := rows.Scan(
			&message.ID,
			&message.ConversationID,
			&message.UserID,
			&message.Content,
			&message.SenderType,
			&createdAt,
			&metadataNull,
		)
		if err != nil {
			return nil, err
		}

		message.CreatedAt = createdAt

		// Parse metadata if present
		if metadataNull.Valid && metadataNull.String != "" {
			var metadataMap map[string]interface{}
			if err := json.Unmarshal([]byte(metadataNull.String), &metadataMap); err == nil {
				message.MetadataMap = metadataMap
			} else {
				log.Printf("Warning: Error unmarshaling metadata: %v", err)
			}
		}

		messages = append(messages, message)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return messages, nil
}

// DeleteConversation removes a conversation
func (r *ChatbotRepository) DeleteConversation(conversationID int, userID int) error {
	// Verify the conversation exists and belongs to the user
	query := `
    SELECT id FROM chatbot_conversations
    WHERE id = $1 AND user_id = $2
    `

	var convoID int
	err := config.DBPool.QueryRow(context.Background(), query, conversationID, userID).Scan(&convoID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return errors.New("conversation not found or access denied")
		}
		return err
	}

	// Delete the conversation (will cascade to messages)
	deleteQuery := `
    DELETE FROM chatbot_conversations
    WHERE id = $1
    `

	_, err = config.DBPool.Exec(context.Background(), deleteQuery, conversationID)
	return err
}
