package config

import (
	"context"
	"log"
	"os"

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
	config, err := pgxpool.ParseConfig(databaseURL)
	if err != nil {
		log.Fatalf("Failed to parse pool configuration: %v", err)
	}

	// Set pengaturan pool
	config.MaxConns = 10

	// Membuat pool koneksi
	DBPool, err = pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}

	// Verifikasi koneksi dengan ping
	if err := DBPool.Ping(context.Background()); err != nil {
		log.Fatalf("Error pinging database: %v", err)
	}

	log.Println("Database connection established successfully")

	// Membuat tabel jika belum ada
	createTables()
}

// createTables membuat tabel yang diperlukan untuk aplikasi
func createTables() {
	// Membuat tabel users
	_, err := DBPool.Exec(context.Background(), `
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		username VARCHAR(50) UNIQUE NOT NULL,
		email VARCHAR(100) UNIQUE NOT NULL,
		password_hash VARCHAR(100) NOT NULL,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	)
	`)
	if err != nil {
		log.Fatalf("Error creating users table: %v", err)
	}

	log.Println("Tables created successfully")
}

// CloseDB menutup koneksi database
func CloseDB() {
	if DBPool != nil {
		DBPool.Close()
		log.Println("Database connection closed")
	}
}
