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

func GetAllStands(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("GetAllKermesses called")

		database.MigrateAll(db) // Initialiser toutes les tables si elles n'existent pas
		fmt.Println("Database migration completed")

		var stands []models.Stand
		result := db.Find(&stands)
		if result.Error != nil {
			fmt.Println("Error retrieving kermesses from database:", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("stands retrieved successfully:", stands)

		w.WriteHeader(http.StatusOK)
		err := json.NewEncoder(w).Encode(stands)
		if err != nil {
			fmt.Println("Error encoding kermesses to JSON:", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("stands encoded and sent successfully")
	}
}

// AddEvent gère l'ajout d'un nouvel événement
func AddStand(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		database.MigrateAll(db)

		// Decode the request body into Stand model
		var standRequest models.Stand
		if err := json.NewDecoder(r.Body).Decode(&standRequest); err != nil {
			log.Printf("Error decoding request body: %v", err)
			http.Error(w, "Invalid request payload", http.StatusBadRequest)
			return
		}
		log.Printf("Received stand req: %+v", standRequest)

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
		if err := db.Where("user_id = ? AND kermesse_id = ?", user.ID, standRequest.KermesseID).First(&actor).Error; err != nil {
			log.Printf("Error finding actor for user %d: %v", user.ID, err)
			http.Error(w, "Actor not found", http.StatusNotFound)
			return
		}

		// Create the new Stand
		stand := models.Stand{
			ActorID:    actor.ID, // Use actor ID
			Type:       standRequest.Type,
			MaxPoint:   standRequest.MaxPoint,
			KermesseID: standRequest.KermesseID,
			Name:       standRequest.Name,
		}

		result := db.Create(&stand)
		if result.Error != nil {
			log.Printf("Error creating stand: %v", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		log.Printf("Stand created successfully: %+v", stand)
		w.WriteHeader(http.StatusCreated)
	}
}

// GetStandsByKermesseID retrieves all stands associated with a given KermesseID
func GetStandsByKermesseID(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Retrieve the KermesseID from query parameters
		kermesseID := r.URL.Query().Get("kermesse_id")
		if kermesseID == "" {
			log.Println("kermesse_id not provided in query parameters")
			http.Error(w, "kermesse_id is required", http.StatusBadRequest)
			return
		}

		var stands []models.Stand
		result := db.Where("kermesse_id = ?", kermesseID).Find(&stands)
		if result.Error != nil {
			log.Printf("Error retrieving stands for kermesse_id %s: %v", kermesseID, result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		if len(stands) == 0 {
			log.Printf("No stands found for kermesse_id %s", kermesseID)
			http.Error(w, "No stands found", http.StatusNotFound)
			return
		}

		log.Printf("Stands retrieved successfully for kermesse_id %s: %+v", kermesseID, stands)

		w.WriteHeader(http.StatusOK)
		err := json.NewEncoder(w).Encode(stands)
		if err != nil {
			log.Printf("Error encoding stands to JSON: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		log.Println("Stands encoded and sent successfully")
	}
}

func GetStandByID(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["standId"])
		if err != nil {
			http.Error(w, "Invalid stand ID", http.StatusBadRequest)
			return
		}

		var stand models.Stand
		result := db.First(&stand, id)
		if result.Error != nil {
			http.Error(w, "stand not found", http.StatusNotFound)
			return
		}

		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(stand)
	}
}

// GetStandByActorAndKermesse retrieves a stand by actor_id and kermesse_id
func GetStandByActorAndKermesse(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Retrieve the user from the token
		log.Println("Verifying user...")
		user, err := GetUserFromToken(r, db)
		if err != nil {
			log.Printf("Error getting user from token: %v", err)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Retrieve the KermesseID from the query parameters
		kermesseID := r.URL.Query().Get("kermesse_id")
		if kermesseID == "" {
			log.Println("kermesse_id not provided in query parameters")
			http.Error(w, "kermesse_id is required", http.StatusBadRequest)
			return
		}

		// Retrieve the actor based on user_id and kermesse_id
		var actor models.Actor
		if err := db.Where("user_id = ? AND kermesse_id = ?", user.ID, kermesseID).First(&actor).Error; err != nil {
			log.Printf("Error finding actor for user %d and kermesse %s: %v", user.ID, kermesseID, err)
			http.Error(w, "Actor not found", http.StatusNotFound)
			return
		}

		// Retrieve the stand for the actor and kermesse
		var stand models.Stand
		if err := db.Where("actor_id = ? AND kermesse_id = ?", actor.ID, kermesseID).First(&stand).Error; err != nil {
			log.Printf("Error finding stand for actor %d and kermesse %s: %v", actor.ID, kermesseID, err)
			http.Error(w, "Stand not found", http.StatusNotFound)
			return
		}

		log.Printf("Stand retrieved successfully for actor %d and kermesse %s: %+v", actor.ID, kermesseID, stand)

		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(stand)
		if err != nil {
			log.Printf("Error encoding stand to JSON: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		log.Println("Stand encoded and sent successfully")
	}
}
