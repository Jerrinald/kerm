package controllers

import (
	"encoding/json"
	"log"
	"net/http"
)

func CreatePaymentIntent(w http.ResponseWriter, r *http.Request) {
	// Parse request body to get the number of tickets and total amount
	var req struct {
		NbJeton int `json:"nbJeton"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	amount := req.NbJeton * 1

	log.Printf("Amount: %v", amount)

	// Set your secret API key for Stripe
	// stripe.Key = "your_stripe_secret_key"

	// params := &stripe.PaymentIntentParams{
	// 	Amount:   stripe.Int64(int64(amount)),
	// 	Currency: stripe.String(string(stripe.CurrencyEUR)),
	// }

	// pi, err := paymentintent.New(params)
	// if err != nil {
	// 	http.Error(w, "Payment Intent creation failed", http.StatusInternalServerError)
	// 	return
	// }

	// json.NewEncoder(w).Encode(map[string]string{
	// 	"clientSecret": pi.ClientSecret,
	// })
}
