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
	// Load .env
	if err := godotenv.Load(); err != nil {
		log.Fatal("❌ Error loading .env file")
	}

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

	


	// Setup semua route yang ada di folder routes/
	routes.Setup(app)

	// Tambahkan route untuk Midtrans
	app.Post("/api/create-transaction", admin.CreateTransaction)

	// Jalankan server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	log.Println("Server running at http://0.0.0.0:" + port)
	if err := app.Listen("0.0.0.0:" + port); err != nil {
		log.Fatal("Failed to start server: ", err)
	}
}
