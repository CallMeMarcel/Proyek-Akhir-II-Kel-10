package database

import (
	"fmt"
	"os"
	"time"

	"api/models"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func Connect() {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASS"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	conn, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
		NowFunc: func() time.Time {
			return time.Now().Local()
		},
	})

	if err != nil {
		panic("could not connect to database: " + err.Error())
	}

	sqlDB, err := conn.DB()
	if err != nil {
		panic("failed to get database instance: " + err.Error())
	}

	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetConnMaxLifetime(time.Hour)

	DB = conn

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
