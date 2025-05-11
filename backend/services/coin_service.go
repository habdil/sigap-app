// services/coin_service.go
package services

import (
	"github.com/habdil/sigap-app/backend/models"
	"github.com/habdil/sigap-app/backend/repository"
)

// CoinService handles coin-related business logic
type CoinService struct {
	coinRepo *repository.CoinRepository
}

// NewCoinService creates a new CoinService instance
func NewCoinService() *CoinService {
	return &CoinService{
		coinRepo: repository.NewCoinRepository(),
	}
}

// GetUserCoins retrieves a user's coin balance
func (s *CoinService) GetUserCoins(userID int) (*models.UserCoins, error) {
	return s.coinRepo.GetUserCoins(userID)
}

// AddCoins adds coins to a user's balance
func (s *CoinService) AddCoins(userID int, req *models.AddCoinsRequest) error {
	return s.coinRepo.AddCoins(userID, req.Amount, req.TransactionType, req.ReferenceID, req.ReferenceType)
}

// SpendCoins deducts coins from a user's balance
func (s *CoinService) SpendCoins(userID int, req *models.SpendCoinsRequest) error {
	return s.coinRepo.SpendCoins(userID, req.Amount, req.TransactionType, req.ReferenceID, req.ReferenceType)
}

// GetTransactionHistory retrieves a user's coin transaction history
func (s *CoinService) GetTransactionHistory(userID int) ([]models.CoinTransaction, error) {
	return s.coinRepo.GetTransactionHistory(userID)
}
