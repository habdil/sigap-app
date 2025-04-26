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

	// Membuat tabel jika belum ada
	createTables()
}

// createTables membuat tabel yang diperlukan untuk aplikasi
func createTables() {
	// Membuat tabel users dengan kolom tambahan
	_, err := DBPool.Exec(context.Background(), `
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		username VARCHAR(50) UNIQUE NOT NULL,
		email VARCHAR(100) UNIQUE NOT NULL,
		password_hash VARCHAR(100) NOT NULL,
		google_id TEXT,
		age INTEGER,
		height DECIMAL,
		weight DECIMAL,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	)
	`)
	if err != nil {
		log.Fatalf("Error creating users table: %v", err)
	}

	// Membuat tabel user_assessments
	_, err = DBPool.Exec(context.Background(), `
	CREATE TABLE IF NOT EXISTS user_assessments (
		id SERIAL PRIMARY KEY,
		user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
		screen_time_hours INTEGER NOT NULL,
		exercise_hours INTEGER NOT NULL,
		late_night_frequency INTEGER NOT NULL,
		diet_quality INTEGER NOT NULL,
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		CONSTRAINT user_assessments_screen_time_hours_check CHECK (screen_time_hours BETWEEN 1 AND 4),
		CONSTRAINT user_assessments_exercise_hours_check CHECK (exercise_hours BETWEEN 1 AND 4),
		CONSTRAINT user_assessments_late_night_frequency_check CHECK (late_night_frequency BETWEEN 1 AND 4),
		CONSTRAINT user_assessments_diet_quality_check CHECK (diet_quality BETWEEN 1 AND 4)
	)
	`)
	if err != nil {
		log.Fatalf("Error creating user_assessments table: %v", err)
	}

	// Membuat tabel risk_assessment_results
	_, err = DBPool.Exec(context.Background(), `
	CREATE TABLE IF NOT EXISTS risk_assessment_results (
		id SERIAL PRIMARY KEY,
		user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
		assessment_id INTEGER NOT NULL REFERENCES user_assessments(id) ON DELETE CASCADE,
		risk_percentage INTEGER NOT NULL,
		risk_factors TEXT[] NOT NULL,
		recommendations TEXT[],
		created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
	)
	`)
	if err != nil {
		log.Fatalf("Error creating risk_assessment_results table: %v", err)
	}

	// Create index for faster lookups
	_, err = DBPool.Exec(context.Background(), `
	CREATE INDEX IF NOT EXISTS idx_risk_assessment_results_user_created
	ON risk_assessment_results(user_id, created_at DESC)
	`)
	if err != nil {
		log.Printf("Warning: Error creating index: %v", err)
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
