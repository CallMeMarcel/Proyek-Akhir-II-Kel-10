package controllers

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/midtrans/midtrans-go"
	"github.com/midtrans/midtrans-go/snap"
)

type CreateTransactionRequest struct {
	OrderID      string `json:"orderId"`
	Amount       int64  `json:"amount"`
	CustomerName string `json:"customerName"`
}

func CreateTransaction(c *fiber.Ctx) error {
	var reqBody CreateTransactionRequest

	if err := c.BodyParser(&reqBody); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if reqBody.OrderID == "" || reqBody.Amount <= 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid order ID or amount"})
	}

	serverKey := os.Getenv("MIDTRANS_SERVER_KEY")
    if serverKey == "" {
        log.Fatal("MIDTRANS_SERVER_KEY not found in .env")
    }
	if serverKey == "" {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Midtrans Server Key is not set"})
	}

	// Inisialisasi Snap client
	snapClient := snap.Client{}
	snapClient.New(serverKey, midtrans.Production)

	// Buat request Snap
	snapReq := &snap.Request{
		TransactionDetails: midtrans.TransactionDetails{
			OrderID:  reqBody.OrderID,
			GrossAmt: reqBody.Amount,
		},
		CustomerDetail: &midtrans.CustomerDetails{
			FName: reqBody.CustomerName,
			Email: "pedromhutagaol@gmail.com",
		},
		Expiry: &snap.ExpiryDetails{
			StartTime: time.Now().Format("2006-01-02 15:04:05 -0700"),
			Unit:      "minutes",
			Duration:  30,
		},
	}

	fmt.Println(snapReq.TransactionDetails.OrderID)
	fmt.Println(snapReq.TransactionDetails.GrossAmt)
	fmt.Println(snapReq.CustomerDetail.FName)

	// Buat transaksi
	resp, err := snapClient.CreateTransaction(snapReq)
	if err != nil {
		log.Printf("Midtrans Error: %+v\n", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to create transaction"})
	}

	if resp == nil || resp.Token == "" {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Invalid response from Midtrans"})
	}

	return c.JSON(fiber.Map{
		"snapToken": resp.Token,
	})

}

