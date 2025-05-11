// models/coin.go
package models

import "time"

// UserCoins represents a user's coin balance
type UserCoins struct {
	ID         int       `json:"id"`
	UserID     int       `json:"user_id"`
	TotalCoins int       `json:"total_coins"`
	UpdatedAt  time.Time `json:"updated_at"`
}

// CoinTransaction represents a transaction in a user's coin account
type CoinTransaction struct {
	ID              int       `json:"id"`
	UserID          int       `json:"user_id"`
	Amount          int       `json:"amount"` // Positive for earned, negative for spent
	TransactionType string    `json:"transaction_type"`
	ReferenceID     int       `json:"reference_id,omitempty"`
	ReferenceType   string    `json:"reference_type,omitempty"`
	CreatedAt       time.Time `json:"created_at"`
}

// SpendCoinsRequest represents a request to spend coins
type SpendCoinsRequest struct {
	Amount          int    `json:"amount" binding:"required,min=1"`
	TransactionType string `json:"transaction_type" binding:"required"`
	ReferenceID     int    `json:"reference_id,omitempty"`
	ReferenceType   string `json:"reference_type,omitempty"`
}

// AddCoinsRequest represents a request to add coins
type AddCoinsRequest struct {
	Amount          int    `json:"amount" binding:"required,min=1"`
	TransactionType string `json:"transaction_type" binding:"required"`
	ReferenceID     int    `json:"reference_id,omitempty"`
	ReferenceType   string `json:"reference_type,omitempty"`
}
