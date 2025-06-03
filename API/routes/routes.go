package routes

import (
	// Admin
	adminControllers "api/controllers/admin"
	controllers "api/controllers/admin"

	// User
	userControllers "api/controllers/user"

	adminPayment "api/controllers/admin"

	// Service
	"api/services"

	"github.com/gofiber/fiber/v2"
)

func Setup(app *fiber.App) {
	// ------------------- ADMIN ROUTES -------------------
	admin := app.Group("/admin")

	// Auth Admin
	admin.Post("/register", adminControllers.Register)
	admin.Post("/login", adminControllers.Login)
	admin.Get("/profile", adminControllers.Profile)
	admin.Post("/logout", adminControllers.Logout)

	// Category Management
	admin.Post("/category", adminControllers.CreateCategory)
	admin.Get("/category/index", adminControllers.IndexCategory)
	admin.Get("/category/:id", adminControllers.ShowCategory)
	admin.Put("/category/:id", adminControllers.UpdateCategory)
	admin.Delete("/category/:id", adminControllers.DeleteCategory)

	// Order Management
	admin.Get("/orders/index", controllers.GetAllOrders)
	admin.Post("/orders", controllers.CreateOrder)
	admin.Put("/orders/:id/complete", controllers.UpdateOrderStatusToSelesai)

	// Midtrans Payment Routes
	admin.Post("/payment", adminPayment.CreateTransaction)

	// Product Management
	admin.Post("/product", adminControllers.CreateProduct)
	admin.Get("/product/index", adminControllers.IndexProduct)
	admin.Get("/product/:id", adminControllers.ShowProduct)
	admin.Put("/product/:id", adminControllers.UpdateProduct)
	admin.Delete("/product/:id", adminControllers.DeleteProduct)

	//STATIC
	app.Static("/storage", "../PA2/storage/app/public")
	app.Static("/storage", "./storage/app/public") // Serve from API's storage directory
	// ------------------- USER ROUTES -------------------
	user := app.Group("/user")

	// Inisialisasi service dan controller user
	userService := services.NewUserService()
	userController := userControllers.NewUserController(userService)

	// Auth User
	user.Post("/register", userController.RegisterUser)
	user.Post("/login", userController.LoginUser)
	user.Get("/profile", userController.UserProfile)
	user.Put("/profile", userController.UpdateUserProfile)                // Tambahkan rute untuk update profil
	user.Post("/upload-profile-image", userController.UploadProfileImage) // Tambahkan rute ini
	user.Post("/logout", userController.LogoutUser)

	// Wishlist Routes
	user.Post("/wishlist", userControllers.AddToWishlist)
	user.Get("/wishlist/index", userControllers.GetWishlist)
	user.Delete("/wishlist/:id", userControllers.RemoveWishlist)
	// Hapus wishlist berdasarkan ID produk atau wishlist
}
