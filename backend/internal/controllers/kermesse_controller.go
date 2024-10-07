package controllers

import (
	"backend/internal/database"
	"backend/internal/models"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

func GetAllKermesses(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("GetAllKermesses called")

		database.MigrateAll(db) // Initialiser toutes les tables si elles n'existent pas
		fmt.Println("Database migration completed")

		var kermesses []models.Kermesse
		result := db.Find(&kermesses)
		if result.Error != nil {
			fmt.Println("Error retrieving kermesses from database:", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("kermesses retrieved successfully:", kermesses)

		w.WriteHeader(http.StatusOK)
		err := json.NewEncoder(w).Encode(kermesses)
		if err != nil {
			fmt.Println("Error encoding kermesses to JSON:", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("kermesses encoded and sent successfully")
	}
}

// AddEvent gère l'ajout d'un nouvel événement
func AddKermesseOrganisateur(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		database.MigrateAll(db)
		// Décoder la requête
		var kermesse models.Kermesse
		if err := json.NewDecoder(r.Body).Decode(&kermesse); err != nil {
			log.Printf("Error decoding request body: %v", err)
			http.Error(w, "Invalid request payload", http.StatusBadRequest)
			return
		}
		log.Printf("Received eventAdd: %+v", kermesse)

		log.Println("Verifying user role...")
		user, err := GetUserFromToken(r, db)
		if err != nil {
			log.Printf("Error getting user from token: %v", err)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		result := db.Create(&kermesse)
		if result.Error != nil {
			log.Printf("Error creating kermesse: %v", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		log.Printf("kermesse created successfully: %+v", kermesse)

		participant := models.Actor{
			UserID:     user.ID,
			KermesseID: kermesse.ID,
			Active:     true,
			Response:   true,
		}

		log.Println("Creating actor...")
		if err := db.Create(&participant).Error; err != nil {
			log.Printf("Error creating actor: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		log.Printf("Actor created successfully: %+v", participant)

		// Répondre avec succès
		w.WriteHeader(http.StatusCreated)
		if err := json.NewEncoder(w).Encode(kermesse); err != nil {
			log.Printf("Error encoding response: %v", err)
		}
		log.Println("kermesse creation response sent.")
	}
}

func GetMyKermesses(db *gorm.DB) http.HandlerFunc {
	database.MigrateAll(db)
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("GetAllKermesses called")

		database.MigrateAll(db) // Initialiser toutes les tables si elles n'existent pas
		fmt.Println("Database migration completed")

		// Retrieve the user from the token
		user, err := GetUserFromToken(r, db)
		if err != nil {
			log.Printf("Error getting user from token: %v", err)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Find all Kermesses where the user is an Organisateur
		var kermesses []models.Kermesse
		result := db.Joins("JOIN actors ON actors.kermesse_id = kermesses.id").
			Where("actors.user_id = ?", user.ID).
			Find(&kermesses)

		if result.Error != nil {
			fmt.Println("Error retrieving kermesses from database:", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		if len(kermesses) == 0 {
			fmt.Println("No kermesses found for this user")
			http.Error(w, "No kermesses found", http.StatusNotFound)
			return
		}

		fmt.Println("Kermesses retrieved successfully:", kermesses)

		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(kermesses)
		if err != nil {
			fmt.Println("Error encoding kermesses to JSON:", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("Kermesses encoded and sent successfully")
	}
}

func GetKermessetByID(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["kermesseId"])
		if err != nil {
			http.Error(w, "Invalid kermesse ID", http.StatusBadRequest)
			return
		}

		var kermesse models.Kermesse
		result := db.First(&kermesse, id)
		if result.Error != nil {
			http.Error(w, "Kermesse not found", http.StatusNotFound)
			return
		}

		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(kermesse)
	}
}
