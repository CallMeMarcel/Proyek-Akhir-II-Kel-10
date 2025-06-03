package userControllers

import (
	"api/models"
	"api/database"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Helper untuk mengambil user ID dari token JWT
func getUserID(c *fiber.Ctx) (uint, error) {
	user := c.Locals("user")
	if user == nil {
		return 0, fmt.Errorf("user not found in token")
	}

	token, ok := user.(*jwt.Token)
	if !ok {
		return 0, fmt.Errorf("failed to assert user as *jwt.Token")
	}

	claims := token.Claims.(jwt.MapClaims)
	id := uint(claims["id"].(float64))
	return id, nil
}


func AddToWishlist(c *fiber.Ctx) error {
	type Request struct {
		ProductID uint `json:"product_id"`
	}

	var body Request
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid input"})
	}

	userID, err := getUserID(c)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
	}

	wishlist := models.Wishlist{
		UserID:    userID,
		ProductID: body.ProductID,
	}

	if err := database.DB.Create(&wishlist).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to add wishlist"})
	}

	return c.JSON(fiber.Map{"message": "Wishlist added successfully"})
}

func GetWishlist(c *fiber.Ctx) error {
	userID, err := getUserID(c)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
	}

	var wishlist []models.Wishlist
	if err := database.DB.Where("user_id = ?", userID).Find(&wishlist).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to fetch wishlist"})
	}

	return c.JSON(wishlist)
}


func RemoveWishlist(c *fiber.Ctx) error {
	userID, err := getUserID(c)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "Unauthorized"})
	}

	// Ambil ID dari parameter URL, ini bisa berupa ID produk atau ID wishlist
	id := c.Params("id")

	// Gunakan database.DB untuk operasi database
	if err := database.DB.Where("user_id = ? AND product_id = ?", userID, id).Delete(&models.Wishlist{}).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to delete wishlist"})
	}

	return c.JSON(fiber.Map{"message": "Wishlist removed successfully"})
}
