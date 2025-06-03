package userControllers

import (
	"api/database"
	"api/models"
	"api/services"
	"fmt"
	"os" // Added for MkdirAll
	"github.com/dgrijalva/jwt-go"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid" // Tambahkan impor ini
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"path/filepath"
	"regexp"
	"strconv"
	"time"
)

var UserSecretKey = "USER_SECRET_KEY"

type UserController struct {
	userService *services.UserService
}

func NewUserController(userService *services.UserService) *UserController {
	return &UserController{userService: userService}
}

// RegisterUser handles user registration
func (uc *UserController) RegisterUser(ctx *fiber.Ctx) error {
	var data struct {
		Name     string `json:"name"`
		Email    string `json:"email"`
		PhoneNo  string `json:"phone_no"`
		Password string `json:"password"`
	}

	// Parse request body
	if err := ctx.BodyParser(&data); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Format request tidak valid",
			"error":   err.Error(),
		})
	}

	// Validasi input
	if data.Name == "" || data.Email == "" || data.PhoneNo == "" || data.Password == "" {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Semua field harus diisi",
		})
	}

	// Validasi email format
	if !regexp.MustCompile(`^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$`).MatchString(data.Email) {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Format email tidak valid",
		})
	}

	// Cek apakah email sudah digunakan
	var existingUser models.User
	if err := database.DB.Where("email = ?", data.Email).First(&existingUser).Error; err == nil {
		return ctx.Status(fiber.StatusConflict).JSON(fiber.Map{
			"message": "Email sudah terdaftar",
		})
	}

	// Validasi nomor telepon
	if !regexp.MustCompile(`^\d{10,15}$`).MatchString(data.PhoneNo) {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Format nomor telepon tidak valid",
		})
	}

	// Enkripsi password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(data.Password), bcrypt.DefaultCost)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Gagal mengenkripsi password",
		})
	}

	newUser := models.User{
		Name:     data.Name,
		Email:    data.Email,
		Phone:    data.PhoneNo,
		Password: string(hashedPassword),
	}

	if err := database.DB.Create(&newUser).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Gagal menyimpan data pengguna",
			"error":   err.Error(),
		})
	}

	return ctx.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Pendaftaran berhasil",
		"email":   newUser.Email,
	})
}

func (uc *UserController) LoginUser(ctx *fiber.Ctx) error {
	var data map[string]string
	if err := ctx.BodyParser(&data); err != nil {
		return ctx.Status(http.StatusBadRequest).JSON(fiber.Map{
			"message": "Format request tidak valid",
		})
	}

	// Debug log
	fmt.Println("Input email:", data["email"])
	fmt.Println("Password input:", data["password"])

	var user models.User
	if err := database.DB.Where("email = ?", data["email"]).First(&user).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "User tidak ditemukan",
		})
	}

	// Debug log
	fmt.Println("Password dari database (hashed):", user.Password)

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(data["password"])); err != nil {
		return ctx.Status(http.StatusUnauthorized).JSON(fiber.Map{
			"message": "Password salah",
		})
	}

	// Pastikan UserSecretKey sudah didefinisikan
	if UserSecretKey == "" {
		return ctx.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Token secret key belum didefinisikan",
		})
	}

	token, err := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.StandardClaims{
		Issuer:    strconv.Itoa(int(user.Id)),
		ExpiresAt: time.Now().Add(30 * time.Minute).Unix(),
		Subject:   "user",
	}).SignedString([]byte(UserSecretKey))

	if err != nil {
		return ctx.Status(http.StatusInternalServerError).JSON(fiber.Map{
			"message": "Gagal membuat token",
		})
	}

	ctx.Cookie(&fiber.Cookie{
		Name:     "jwtUser",
		Value:    token,
		Expires:  time.Now().Add(30 * time.Minute),
		HTTPOnly: true,
		Secure:   true,
	})

	return ctx.JSON(fiber.Map{
		"status":  "success",
		"message": "Login berhasil",
		"token":   token,
		"user": fiber.Map{
			"id":       user.Id,
			"name":     user.Name,
			"email":    user.Email,
			"phone":    user.Phone,
		},
	})
}

func (uc *UserController) UpdateUserProfile(ctx *fiber.Ctx) error {
	// Ambil token dari header Authorization
	authHeader := ctx.Get("Authorization")
	tokenString := ""

	if authHeader != "" && len(authHeader) > 7 && authHeader[:7] == "Bearer " {
		tokenString = authHeader[7:]
	} else {
		tokenString = ctx.Cookies("jwtUser")
	}

	if tokenString == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "Token tidak ditemukan",
		})
	}

	// Parse dan validasi token
	token, err := jwt.ParseWithClaims(tokenString, &jwt.StandardClaims{}, func(t *jwt.Token) (interface{}, error) {
		return []byte(UserSecretKey), nil
	})

	if err != nil || !token.Valid {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "Unauthenticated",
		})
	}

	claims := token.Claims.(*jwt.StandardClaims)
	userID, err := strconv.Atoi(claims.Issuer)
	if err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "ID pengguna tidak valid",
		})
	}

	// Parse data dari body
	var data struct {
		Name     string `json:"name"`
		Email    string `json:"email"`
		Phone    string `json:"phone"`
		ImageUrl string `json:"image_url"`
	}

	if err := ctx.BodyParser(&data); err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Format request tidak valid",
			"error":   err.Error(),
		})
	}

	// Validasi input
	if data.Name == "" || data.Email == "" || data.Phone == "" {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Semua field harus diisi",
		})
	}

	// Validasi email
	if !regexp.MustCompile(`^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$`).MatchString(data.Email) {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Format email tidak valid",
		})
	}

	// Validasi nomor telepon
	if !regexp.MustCompile(`^\d{10,15}$`).MatchString(data.Phone) {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Format nomor telepon tidak valid",
		})
	}

	// Cek apakah email sudah digunakan oleh pengguna lain
	var existingUser models.User
	if err := database.DB.Where("email = ? AND id != ?", data.Email, userID).First(&existingUser).Error; err == nil {
		return ctx.Status(fiber.StatusConflict).JSON(fiber.Map{
			"message": "Email sudah terdaftar",
		})
	}

	// Ambil pengguna dari database
	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "User tidak ditemukan",
		})
	}

	// Perbarui data pengguna
	user.Name = data.Name
	user.Email = data.Email
	user.Phone = data.Phone
	if data.ImageUrl != "" {
		user.ImageUrl = data.ImageUrl
	}
	user.UpdatedAt = time.Now()

	// Simpan perubahan ke database
	if err := database.DB.Save(&user).Error; err != nil {
		return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Gagal memperbarui profil",
			"error":   err.Error(),
		})
	}

	return ctx.JSON(fiber.Map{
		"status":  "success",
		"message": "Profil berhasil diperbarui",
		"data":    user,
	})
}

func (uc *UserController) UserProfile(ctx *fiber.Ctx) error {
	// Ambil token dari header Authorization
	authHeader := ctx.Get("Authorization")
	tokenString := ""

	if authHeader != "" && len(authHeader) > 7 && authHeader[:7] == "Bearer " {
		tokenString = authHeader[7:]
	} else {
		tokenString = ctx.Cookies("jwtUser")
	}

	if tokenString == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "Token tidak ditemukan",
		})
	}

	// Parse dan validasi token
	token, err := jwt.ParseWithClaims(tokenString, &jwt.StandardClaims{}, func(t *jwt.Token) (interface{}, error) {
		return []byte(UserSecretKey), nil
	})

	if err != nil || !token.Valid {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "Unauthenticated",
		})
	}

	claims := token.Claims.(*jwt.StandardClaims)

	// Ambil data pengguna
	var user models.User
	if err := database.DB.First(&user, claims.Issuer).Error; err != nil {
		return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"message": "User tidak ditemukan",
		})
	}

	return ctx.JSON(fiber.Map{
		"status": "success",
		"data":   user,
	})
}

func (uc *UserController) LogoutUser(ctx *fiber.Ctx) error {
	ctx.Cookie(&fiber.Cookie{
		Name:     "jwtUser",
		Value:    "",
		Expires:  time.Now().Add(-time.Hour),
		HTTPOnly: true,
		Secure:   true,
	})

	return ctx.JSON(fiber.Map{
		"message": "Logout berhasil",
	})
}

func (uc *UserController) UploadProfileImage(ctx *fiber.Ctx) error {
    // Ambil token dari header Authorization atau cookie
    authHeader := ctx.Get("Authorization")
    tokenString := ""
    if authHeader != "" && len(authHeader) > 7 && authHeader[:7] == "Bearer " {
        tokenString = authHeader[7:]
    } else {
        tokenString = ctx.Cookies("jwtUser")
    }

    if tokenString == "" {
        return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
            "message": "Token tidak ditemukan",
        })
    }

    // Parse dan validasi token
    token, err := jwt.ParseWithClaims(tokenString, &jwt.StandardClaims{}, func(t *jwt.Token) (interface{}, error) {
        return []byte(UserSecretKey), nil
    })

    if err != nil || !token.Valid {
        return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
            "message": "Unauthenticated",
        })
    }

    claims := token.Claims.(*jwt.StandardClaims)
    userID, err := strconv.Atoi(claims.Issuer)
    if err != nil {
        return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "message": "ID pengguna tidak valid",
        })
    }

    // Ambil file dari form-data
    file, err := ctx.FormFile("image")
    if err != nil {
        return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "message": "Gagal mengambil file",
            "error":   err.Error(),
        })
    }

    // Validasi format file
    allowedExtensions := map[string]bool{".jpg": true, ".jpeg": true, ".png": true}
    ext := filepath.Ext(file.Filename)
    if !allowedExtensions[ext] {
        return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "message": "Format file tidak didukung. Gunakan JPG, JPEG, atau PNG",
        })
    }

    // Validasi ukuran file (maks 5MB)
    if file.Size > 5*1024*1024 {
        return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "message": "Ukuran file terlalu besar. Maksimum 5MB",
        })
    }

    // Buat nama file unik
    filename := fmt.Sprintf("%d_%s%s", userID, uuid.New().String(), ext)
    storageDir := "storage/app/public/profile"
    storagePath := filepath.Join(storageDir, filename)

    // Log untuk debugging
    fmt.Printf("Attempting to save file to: %s\n", storagePath)

    // Buat direktori jika belum ada
    if err := os.MkdirAll(storageDir, 0755); err != nil {
        fmt.Printf("Failed to create directory: %v\n", err)
        return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "message": "Gagal membuat direktori",
            "error":   err.Error(),
        })
    }

    // Simpan file ke direktori
    if err := ctx.SaveFile(file, storagePath); err != nil {
        fmt.Printf("Failed to save file: %v\n", err)
        return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "message": "Gagal menyimpan file",
            "error":   err.Error(),
        })
    }

    // Buat URL untuk akses gambar
    imageUrl := fmt.Sprintf("/storage/profile/%s", filename)

    // Perbarui image_url di database
    var user models.User
    if err := database.DB.First(&user, userID).Error; err != nil {
        return ctx.Status(fiber.StatusNotFound).JSON(fiber.Map{
            "message": "User tidak ditemukan",
        })
    }

    user.ImageUrl = imageUrl
    user.UpdatedAt = time.Now()
    if err := database.DB.Save(&user).Error; err != nil {
        return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "message": "Gagal memperbarui profil",
            "error":   err.Error(),
        })
    }

    return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
        "status":  "success",
        "message": "Foto profil berhasil diunggah",
        "data": fiber.Map{
            "image_url": imageUrl,
        },
    })
}