package controllers

import (
	"api/database"
	"api/models"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"time"

	"github.com/gofiber/fiber/v2"
)

const ImageProduct = "./storage/products/"

const BaseImageURL = "http://192.168.79.183:8000/storage/products"

func init() {

	if _, err := os.Stat(ImageProduct); os.IsNotExist(err) {
		os.MkdirAll(ImageProduct, os.ModePerm)
	}
}

func CreateProduct(ctx *fiber.Ctx) error {

	name := ctx.FormValue("name")
	description := ctx.FormValue("description")
	status := ctx.FormValue("status")
	title := ctx.FormValue("title")
	priceStr := ctx.FormValue("price")
	idCategoryStr := ctx.FormValue("id_category")

	if name == "" || description == "" || status == "" || title == "" || priceStr == "" || idCategoryStr == "" {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "All fields are required",
		})
	}

	price, err := strconv.Atoi(priceStr)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid price format",
		})
	}
	idCategory, err := strconv.Atoi(idCategoryStr)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid category format",
		})
	}

	image, err := ctx.FormFile("image")
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Image is required",
		})
	}
	filename := fmt.Sprintf("%d_%s", time.Now().Unix(), image.Filename)
	if err := ctx.SaveFile(image, filepath.Join(ImageProduct, filename)); err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to save image",
		})
	}

	imageURL := fmt.Sprintf("%s/%s", BaseImageURL, filename)

	product := models.Product{
		Name:        name,
		Description: description,
		Status:      status,
		Title:       title,
		Price:       float64(price),
		Image:       imageURL,
		CategoryID:  uint(idCategory),
	}

	database.DB.Create(&product)

	return ctx.JSON(fiber.Map{
		"status":  "success",
		"message": "Product successfully created.",
		"data":    product,
	})
}

func IndexProduct(ctx *fiber.Ctx) error {
	var products []models.Product

	if err := database.DB.Preload("Category").Find(&products).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to retrieve products",
			"error":   err.Error(),
		})
	}

	for i := range products {
		products[i].Image = fmt.Sprintf("%s/%s", BaseImageURL, filepath.Base(products[i].Image))
	}

	if len(products) == 0 {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "No products found",
		})
	}

	return ctx.JSON(fiber.Map{
		"status":  "success",
		"message": "Products retrieved successfully.",
		"data":    products,
	})
}

func ShowProduct(ctx *fiber.Ctx) error {

	productIDStr := ctx.Params("id")
	productID, err := strconv.Atoi(productIDStr)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid product ID",
		})
	}

	var product models.Product
	result := database.DB.Preload("Category").Where("id = ?", productID).First(&product)

	if result.Error != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "Product not found",
		})
	}

	product.Image = fmt.Sprintf("%s/%s", BaseImageURL, filepath.Base(product.Image))

	return ctx.JSON(fiber.Map{
		"status":  "success",
		"message": "Product retrieved successfully.",
		"data":    product,
	})
}

func UpdateProduct(ctx *fiber.Ctx) error {

	productIDStr := ctx.Params("id")
	productID, err := strconv.Atoi(productIDStr)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid product ID",
		})
	}

	var product models.Product
	if err := database.DB.First(&product, productID).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "Product not found",
		})
	}

	name := ctx.FormValue("name")
	description := ctx.FormValue("description")
	status := ctx.FormValue("status")
	title := ctx.FormValue("title")
	priceStr := ctx.FormValue("price")
	idCategoryStr := ctx.FormValue("id_category")

	price, err := strconv.Atoi(priceStr)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid price format",
		})
	}
	idCategory, err := strconv.Atoi(idCategoryStr)
	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid category format",
		})
	}

	newImage, err := ctx.FormFile("image")
	if err == nil {

		if product.Image != "" {
			oldImagePath := filepath.Join(ImageProduct, filepath.Base(product.Image))
			os.Remove(oldImagePath)
		}

		filename := fmt.Sprintf("%d_%s", time.Now().Unix(), newImage.Filename)
		if err := ctx.SaveFile(newImage, filepath.Join(ImageProduct, filename)); err != nil {
			return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Failed to save image",
			})
		}

		product.Image = fmt.Sprintf("%s/%s", BaseImageURL, filename)
	}

	product.Name = name
	product.Description = description
	product.Status = status
	product.Title = title
	product.Price = float64(price)
	product.CategoryID = uint(idCategory)

	database.DB.Save(&product)

	return ctx.JSON(fiber.Map{
		"status":  "success",
		"message": "Product updated successfully.",
		"data":    product,
	})
}

func DeleteProduct(ctx *fiber.Ctx) error {
	productIDStr := ctx.Params("id")

	productID, err := strconv.Atoi(productIDStr)

	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid product ID",
		})
	}

	var product models.Product

	if err := database.DB.Where("id = ?", productID).First(&product).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "Product not found",
		})
	}

	if product.Image != "" {
		imagePath := filepath.Join(ImageProduct, filepath.Base(product.Image))
		if err := os.Remove(imagePath); err != nil {
			fmt.Printf("Failed to delete image file: %v\n", err)
		}
	}

	if err := database.DB.Delete(&product).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to delete product",
		})
	}

	return ctx.JSON(fiber.Map{
		"message": "Product deleted successfully",
	})
}
