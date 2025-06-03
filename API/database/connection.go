package database

import (
	"api/models"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func Connect() {
	// Tambahkan parameter parseTime dan loc pada DSN
	dsn := "root:@tcp(localhost:3306)/laravel?charset=utf8mb4&parseTime=True&loc=Local"
	
	// Tambahkan konfigurasi tambahan untuk GORM
	conn, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
		NowFunc: func() time.Time {
			return time.Now().Local()
		},
	})
	
	if err != nil {
		panic("could not connect to database: " + err.Error())
	}

	// Dapatkan koneksi database SQL underlying
	sqlDB, err := conn.DB()
	if err != nil {
		panic("failed to get database instance: " + err.Error())
	}

	// Konfigurasi connection pool
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetConnMaxLifetime(time.Hour)

	DB = conn

	

	// AutoMigrate dengan penanganan error
	err = conn.AutoMigrate(
		&models.Admin{}, &models.Category{}, &models.Product{}, 
		&models.User{}, &models.ProductDetail{}, &models.Review{},
		&models.Wishlist{}, &models.Cart{}, &models.Order{}, 
		&models.BuktiPembayaran{},
	)
	
	if err != nil {
		panic("failed to migrate database: " + err.Error())
	}
}