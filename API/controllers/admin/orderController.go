package controllers

import (
	"api/database" // ✅ import database
	"api/models"
	"fmt"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"

)

    func generateOrderToken(orderID uint) (string, error) {
    claims := jwt.MapClaims{
        "order_id": orderID,
        "exp":      time.Now().Add(time.Hour * 24).Unix(), // token berlaku 24 jam
    }

    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte("secret")) // Ganti "secret" dengan secret key kamu
}

 func CreateOrder(c *fiber.Ctx) error {
    var input struct {
        UserID uint `json:"user_id"`
        Items  []struct {
            ProductID uint `json:"product_id"`
            Quantity  int  `json:"quantity"`
        } `json:"items"`
    }

    if err := c.BodyParser(&input); err != nil {
        return c.Status(http.StatusBadRequest).JSON(fiber.Map{
            "message": "Invalid input",
            "error":   err.Error(),
        })
    }

    var total float64
    var orderItems []models.OrderItem

    for _, item := range input.Items {
        var product models.Product
        if err := database.DB.First(&product, item.ProductID).Error; err != nil {
            return c.Status(http.StatusBadRequest).JSON(fiber.Map{
                "message":    "Product not found",
                "product_id": item.ProductID,
            })
        }

        subtotal := float64(item.Quantity) * product.Price
        total += subtotal

        orderItems = append(orderItems, models.OrderItem{
            ProductID: item.ProductID,
            Quantity:  item.Quantity,
            Price:     product.Price,
        })
    }

    order := models.Order{
        UserID:     input.UserID,
        TotalPrice: total,
        Status:     "pending",
        Items:      orderItems,
    }

    if err := database.DB.Create(&order).Error; err != nil {
        return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
            "message": "Failed to create order",
            "error":   err.Error(),
        })
    }

    // Buat token setelah order berhasil
    token, err := generateOrderToken(order.ID)
    if err != nil {
        return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
            "message": "Failed to generate token",
            "error":   err.Error(),
        })
    }

    return c.Status(http.StatusCreated).JSON(fiber.Map{
        "message":  "Order created successfully",
        "order_id": order.ID,
        "token":    token,
    })
}


func GetAllOrders(c *fiber.Ctx) error {
    var orders []models.Order

    
    result := database.DB.
        Preload("User").
        Preload("Items.Product").
        Find(&orders)

 
    if result.Error != nil {
        return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
            "message": "Failed to fetch orders",
        })
    }
    
    // Menyiapkan response yang lebih terstruktur
    var formattedOrders []fiber.Map
    for _, order := range orders {
        var products []fiber.Map
        for _, item := range order.Items {
            var productDetail models.Product
            err := database.DB.First(&productDetail, item.ProductID).Error
            if err != nil {
                productDetail.Title = "Unknown"
            }
            products = append(products, fiber.Map{
                "product_id":   item.ProductID,
                "product_name": productDetail.Title,
                "quantity":     item.Quantity,
                "price":        item.Price,
            })

            fmt.Println("Product Name:", item.Product.Title)
        }
    
        formattedOrders = append(formattedOrders, fiber.Map{
            "order_id":     order.ID,
            "customer_name": order.User.Name,
            "status":       order.Status,
            "products":     products,
        })
    }
    

    return c.JSON(fiber.Map{
        "orders": formattedOrders,        
    })
    
}

func UpdateOrderStatusToSelesai(c *fiber.Ctx) error {
    orderID := c.Params("id")

    var order models.Order
    if err := database.DB.First(&order, orderID).Error; err != nil {
        return c.Status(http.StatusNotFound).JSON(fiber.Map{
            "message": "Order not found",
        })
    }

    order.Status = "selesai"

    if err := database.DB.Save(&order).Error; err != nil {
        return c.Status(http.StatusInternalServerError).JSON(fiber.Map{
            "message": "Failed to update order status",
        })
    }

    return c.JSON(fiber.Map{
        "message": "Order status updated to selesai",
        "order_id": order.ID,
        "status": order.Status,
    })
}

