package controllers

import (
	"backend/internal/database"
	"backend/internal/models"
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

// AddEvent gère l'ajout d'un nouvel événement
func AddStandSell(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		database.MigrateAll(db)

		// Decode the request body into Stand model
		var standRequest models.StatStand
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

		var stand models.Stand
		if err := db.Where("id = ?", standRequest.StandID).First(&stand).Error; err != nil {
			log.Printf("Error finding stand %d: %v", standRequest.StandID, err)
			http.Error(w, "Stand not found", http.StatusNotFound)
			return
		}

		// Retrieve the actor associated with the user and kermesse
		var actor models.Actor
		if err := db.Where("user_id = ? AND kermesse_id = ?", user.ID, stand.KermesseID).First(&actor).Error; err != nil {
			log.Printf("Error finding actor for user %d: %v", user.ID, err)
			http.Error(w, "Actor not found", http.StatusNotFound)
			return
		}

		// Create the new Stand
		statStand := models.StatStand{
			ActorID: actor.ID, // Use actor ID
			StandID: standRequest.StandID,
			NbJeton: standRequest.NbJeton,
			NbPoint: standRequest.NbPoint,
		}

		result := db.Create(&statStand)
		if result.Error != nil {
			log.Printf("Error creating stand statistic: %v", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		log.Printf("Stand statistic created successfully: %+v", statStand)

		actor.NbJeton = actor.NbJeton - standRequest.NbJeton
		if err := db.Save(&actor).Error; err != nil {
			http.Error(w, "Error updating actor", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(statStand)
	}
}

// GetStandTotals returns the total number of jetons and points for a specific stand
func GetStandTotals(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Extract StandID from the request URL or body using mux Vars
		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["standId"])
		if err != nil {
			http.Error(w, "Invalid stand ID", http.StatusBadRequest)
			return
		}

		// Struct to hold the result of the query
		type Totals struct {
			TotalJetons int `json:"total_jetons"`
			TotalPoints int `json:"total_points"`
		}
		var totals Totals

		// Query the database for the sum of NbJeton and NbPoint for the given stand
		err = db.Model(&models.StatStand{}).
			Select("COALESCE(SUM(nb_jeton), 0) as total_jetons, COALESCE(SUM(nb_point), 0) as total_points").
			Where("stand_id = ?", id).
			Scan(&totals).Error

		if err != nil {
			log.Printf("Error calculating totals for stand %d: %v", id, err)
			http.Error(w, "Error calculating totals", http.StatusInternalServerError)
			return
		}

		// Return the totals as JSON
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(totals)
	}
}
