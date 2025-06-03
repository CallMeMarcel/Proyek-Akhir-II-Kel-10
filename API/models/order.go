package models

import "time"

type Order struct {
	ID         uint        `json:"id" gorm:"primaryKey"`
	UserID     uint        `json:"user_id"`
	User       User        `json:"user" gorm:"foreignKey:UserID;references:Id"`
	Status     string      `json:"status"` // e.g., "pending", "completed", "cancelled"
	TotalPrice float64     `json:"total_price"`
	PaymentURL string      `json:"payment_url"` // URL dari Midtrans
	Items      []OrderItem `json:"items" gorm:"foreignKey:OrderID"`
	CreatedAt  time.Time   `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt  time.Time   `json:"updated_at" gorm:"autoUpdateTime"`

	OrderItems []OrderItem `json:"order_items" gorm:"foreignKey:OrderID"`
}

type OrderItem struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	OrderID   uint      `json:"order_id"`
	ProductID uint      `json:"product_id"`
	Product   Product   `json:"product" gorm:"foreignKey:ProductID;"`
	Quantity  int       `json:"quantity" gorm:"default:1"`
	Price     float64   `json:"price"` // Harga saat checkout (untuk arsip)
	CreatedAt time.Time `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt time.Time `json:"updated_at" gorm:"autoUpdateTime"`
}
