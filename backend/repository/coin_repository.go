// repository/coin_repository.go
package repository

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"

	"github.com/habdil/sigap-app/backend/config"
	"github.com/habdil/sigap-app/backend/models"
)

// CoinRepository handles database operations for user coins
type CoinRepository struct{}

// NewCoinRepository creates a new CoinRepository
func NewCoinRepository() *CoinRepository {
	return &CoinRepository{}
}

// EnsureUserCoinsExists makes sure the user has a coin record
func (r *CoinRepository) EnsureUserCoinsExists(userID int) error {
	query := `
	INSERT INTO user_coins (user_id, total_coins)
	VALUES ($1, 0)
	ON CONFLICT (user_id) DO NOTHING
	`

	_, err := config.DBPool.Exec(context.Background(), query, userID)
	return err
}

// GetUserCoins retrieves a user's coin balance
func (r *CoinRepository) GetUserCoins(userID int) (*models.UserCoins, error) {
	// Try to ensure user has a coin record
	if err := r.EnsureUserCoinsExists(userID); err != nil {
		return nil, err
	}

	query := `
	SELECT id, user_id, total_coins, updated_at
	FROM user_coins
	WHERE user_id = $1
	`

	var coins models.UserCoins
	var updatedAt time.Time

	err := config.DBPool.QueryRow(context.Background(), query, userID).Scan(
		&coins.ID,
		&coins.UserID,
		&coins.TotalCoins,
		&updatedAt,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("user coins not found")
		}
		return nil, err
	}

	coins.UpdatedAt = updatedAt
	return &coins, nil
}

// AddCoins adds coins to a user's balance and records the transaction
func (r *CoinRepository) AddCoins(userID int, amount int, transactionType string, referenceID int, referenceType string) error {
	// Start a transaction
	tx, err := config.DBPool.Begin(context.Background())
	if err != nil {
		return err
	}
	defer tx.Rollback(context.Background())

	// Try to ensure user has a coin record
	ensureQuery := `
	INSERT INTO user_coins (user_id, total_coins)
	VALUES ($1, 0)
	ON CONFLICT (user_id) DO NOTHING
	`
	_, err = tx.Exec(context.Background(), ensureQuery, userID)
	if err != nil {
		return err
	}

	// Update user's coin balance
	updateQuery := `
	UPDATE user_coins
	SET total_coins = total_coins + $1, updated_at = NOW()
	WHERE user_id = $2
	`
	_, err = tx.Exec(context.Background(), updateQuery, amount, userID)
	if err != nil {
		return err
	}

	// Record the transaction
	transactionQuery := `
	INSERT INTO coin_transactions (user_id, amount, transaction_type, reference_id, reference_type, created_at)
	VALUES ($1, $2, $3, $4, $5, NOW())
	`
	_, err = tx.Exec(
		context.Background(),
		transactionQuery,
		userID,
		amount,
		transactionType,
		referenceID,
		referenceType,
	)
	if err != nil {
		return err
	}

	// Commit the transaction
	return tx.Commit(context.Background())
}

// SpendCoins deducts coins from a user's balance and records the transaction
func (r *CoinRepository) SpendCoins(userID int, amount int, transactionType string, referenceID int, referenceType string) error {
	// First check if user has enough coins
	coins, err := r.GetUserCoins(userID)
	if err != nil {
		return err
	}

	if coins.TotalCoins < amount {
		return errors.New("insufficient coins")
	}

	// Start a transaction
	tx, err := config.DBPool.Begin(context.Background())
	if err != nil {
		return err
	}
	defer tx.Rollback(context.Background())

	// Update user's coin balance
	updateQuery := `
	UPDATE user_coins
	SET total_coins = total_coins - $1, updated_at = NOW()
	WHERE user_id = $2
	`
	_, err = tx.Exec(context.Background(), updateQuery, amount, userID)
	if err != nil {
		return err
	}

	// Record the transaction (negative amount for spending)
	transactionQuery := `
	INSERT INTO coin_transactions (user_id, amount, transaction_type, reference_id, reference_type, created_at)
	VALUES ($1, $2, $3, $4, $5, NOW())
	`
	_, err = tx.Exec(
		context.Background(),
		transactionQuery,
		userID,
		-amount, // Negative amount for spending
		transactionType,
		referenceID,
		referenceType,
	)
	if err != nil {
		return err
	}

	// Commit the transaction
	return tx.Commit(context.Background())
}

// GetTransactionHistory retrieves a user's coin transaction history
func (r *CoinRepository) GetTransactionHistory(userID int) ([]models.CoinTransaction, error) {
	query := `
	SELECT id, user_id, amount, transaction_type, reference_id, reference_type, created_at
	FROM coin_transactions
	WHERE user_id = $1
	ORDER BY created_at DESC
	`

	rows, err := config.DBPool.Query(context.Background(), query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var transactions []models.CoinTransaction

	for rows.Next() {
		var tx models.CoinTransaction
		var createdAt time.Time
		var referenceIDNull, referenceTypeNull interface{}

		err := rows.Scan(
			&tx.ID,
			&tx.UserID,
			&tx.Amount,
			&tx.TransactionType,
			&referenceIDNull,
			&referenceTypeNull,
			&createdAt,
		)
		if err != nil {
			return nil, err
		}

		// Handle nullable fields
		if refID, ok := referenceIDNull.(int); ok {
			tx.ReferenceID = refID
		}

		if refType, ok := referenceTypeNull.(string); ok {
			tx.ReferenceType = refType
		}

		tx.CreatedAt = createdAt
		transactions = append(transactions, tx)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return transactions, nil
}
