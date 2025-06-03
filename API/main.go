package main

import (
	"log"
	"os"

	"api/database"
	"api/routes"
	admin "api/controllers/admin"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
)

func main() {
	// Load .env hanya jika tersedia (untuk lokal)
	if err := godotenv.Load(); err != nil {
		log.Println("⚠️ .env file not found, using system environment variables")
	}

	log.Println("✅ Starting API service...")

	// Koneksi ke database
	database.Connect()

	// Inisialisasi Fiber
	app := fiber.New()

	// Middleware CORS
	app.Use(cors.New(cors.Config{
		AllowCredentials: true,
		AllowMethods:     "GET, POST, PUT, DELETE",
		AllowHeaders:     "Content-Type, Authorization, Origin, Accept",
		AllowOrigins:     "*",
	}))

	// Setup semua route
	routes.Setup(app)

	// Route khusus Midtrans
	app.Post("/api/create-transaction", admin.CreateTransaction)

	// Jalankan server di port dari ENV atau default 8000
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}
	log.Println("🚀 Server running at http://0.0.0.0:" + port)
	if err := app.Listen("0.0.0.0:" + port); err != nil {
		log.Fatal("🔥 Failed to start server:", err)
	}
}
