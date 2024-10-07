package controllers

import (
	"backend/internal/database"
	"backend/internal/models"
	"encoding/json"
	"log"
	"net/http"

	"gorm.io/gorm"
)

// BuyTicket handles the purchasing of tickets
func BuyTicket(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		database.MigrateAll(db)

		// Decode the request body into TombolaRequest model
		var tombolaRequest models.TombolaRequest
		if err := json.NewDecoder(r.Body).Decode(&tombolaRequest); err != nil {
			log.Printf("Error decoding request body: %v", err)
			http.Error(w, "Invalid request payload", http.StatusBadRequest)
			return
		}
		log.Printf("Received tombola request: %+v", tombolaRequest)

		// Retrieve the user from the token
		log.Println("Verifying user role...")
		user, err := GetUserFromToken(r, db)
		if err != nil {
			log.Printf("Error getting user from token: %v", err)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Retrieve the actor associated with the user and kermesse
		var actor models.Actor
		if err := db.Where("user_id = ? AND kermesse_id = ?", user.ID, tombolaRequest.KermesseID).First(&actor).Error; err != nil {
			log.Printf("Error finding actor for user %d: %v", user.ID, err)
			http.Error(w, "Actor not found", http.StatusNotFound)
			return
		}

		// Loop to create a Tombola entry for each ticket
		for i := 0; i < tombolaRequest.NbTicket; i++ {
			tombola := models.Tombola{
				ActorID:    actor.ID,
				KermesseID: tombolaRequest.KermesseID,
			}

			result := db.Create(&tombola)
			if result.Error != nil {
				log.Printf("Error creating tombola ticket %d for user %d: %v", i+1, user.ID, result.Error)
				http.Error(w, "Internal server error", http.StatusInternalServerError)
				return
			}
			log.Printf("Tombola ticket %d created successfully: %+v", i+1, tombola)
		}

		// Respond with a success message
		response := map[string]string{"message": "Tickets created successfully"}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	}
}
