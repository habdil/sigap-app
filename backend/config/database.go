// config/database.go
package config

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joho/godotenv"
)

// DBPool adalah koneksi database yang digunakan oleh aplikasi
var DBPool *pgxpool.Pool

// InitDB menginisialisasi koneksi database
func InitDB() {
	// Load environment variables
	err := godotenv.Load()
	if err != nil {
		log.Printf("Error loading .env file: %v", err)
	}

	// Mendapatkan connection string dari environment variable
	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		log.Fatalf("DATABASE_URL environment variable is not set")
	}

	// Konfigurasi connection pool
	poolConfig, err := pgxpool.ParseConfig(databaseURL)
	if err != nil {
		log.Fatalf("Failed to parse pool configuration: %v", err)
	}

	// Set pengaturan pool yang optimal
	poolConfig.MaxConns = 10
	poolConfig.MinConns = 2
	poolConfig.MaxConnLifetime = time.Hour
	poolConfig.MaxConnIdleTime = 30 * time.Minute
	poolConfig.HealthCheckPeriod = 1 * time.Minute

	// Untuk mengatasi masalah prepared statement
	poolConfig.ConnConfig.DefaultQueryExecMode = pgx.QueryExecModeSimpleProtocol

	// Membuat pool koneksi
	DBPool, err = pgxpool.NewWithConfig(context.Background(), poolConfig)
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}

	// Verifikasi koneksi dengan ping
	if err := DBPool.Ping(context.Background()); err != nil {
		log.Fatalf("Error pinging database: %v", err)
	}

	log.Println("Database connection established successfully")

	// Tidak perlu membuat tabel lagi karena sudah di-migrate menggunakan Prisma
	// verifyDatabaseSchema()
}

// CloseDB menutup koneksi database
func CloseDB() {
	if DBPool != nil {
		DBPool.Close()
		log.Println("Database connection closed")
	}
}
