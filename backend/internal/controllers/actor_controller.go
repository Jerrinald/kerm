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

// GetActorByKermesse returns the actor for the authenticated user and a given kermesse ID
func GetActorByKermesse(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Get the user from the token (authentication)
		user, err := GetUserFromToken(r, db)
		if err != nil {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Get the kermesseId from query parameters
		kermesseIDParam := r.URL.Query().Get("kermesse_id")
		if kermesseIDParam == "" {
			http.Error(w, "kermesse_id query parameter is required", http.StatusBadRequest)
			return
		}

		// Convert the kermesseId string to uint
		kermesseID, err := strconv.ParseUint(kermesseIDParam, 10, 32)
		if err != nil {
			http.Error(w, "Invalid kermesse_id", http.StatusBadRequest)
			return
		}

		// Find the actor matching the user_id and kermesse_id
		var actor models.Actor
		if err := db.Where("user_id = ? AND kermesse_id = ?", user.ID, uint(kermesseID)).First(&actor).Error; err != nil {
			if err == gorm.ErrRecordNotFound {
				http.Error(w, "Actor not found", http.StatusNotFound)
				return
			}
			http.Error(w, "Error retrieving actor", http.StatusInternalServerError)
			return
		}

		// Return the actor in JSON format
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(actor)
	}
}

// UpdateActorNbJeton updates only the nbJeton field of the actor identified by actorId
func UpdateActorNbJeton(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		// Get the actorId from the path parameters
		actorIDParam := mux.Vars(r)["actorId"]
		actorID, err := strconv.ParseUint(actorIDParam, 10, 32)
		if err != nil {
			http.Error(w, "Invalid actorId", http.StatusBadRequest)
			return
		}

		// Find the actor based on actorId and userId to ensure ownership
		var actor models.Actor
		if err := db.Where("id = ?", uint(actorID)).First(&actor).Error; err != nil {
			if err == gorm.ErrRecordNotFound {
				http.Error(w, "Actor not found", http.StatusNotFound)
				return
			}
			http.Error(w, "Error retrieving actor", http.StatusInternalServerError)
			return
		}

		// Parse the request body to get the new nbJeton value
		var updatedActor struct {
			NbJeton int `json:"nb_jeton"`
		}
		if err := json.NewDecoder(r.Body).Decode(&updatedActor); err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}

		// Update the actor's nbJeton field
		actor.NbJeton = actor.NbJeton + updatedActor.NbJeton
		if err := db.Save(&actor).Error; err != nil {
			http.Error(w, "Error updating actor", http.StatusInternalServerError)
			return
		}

		// Return the updated actor
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(actor)
	}
}

// UpdateActorResponseAndActive updates the response and active fields of the actor identified by actorId
func UpdateActorResponseAndActive(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		// Get the actorId from the path parameters
		actorIDParam := mux.Vars(r)["actorId"]
		actorID, err := strconv.ParseUint(actorIDParam, 10, 32)
		if err != nil {
			http.Error(w, "Invalid actorId", http.StatusBadRequest)
			return
		}

		// Find the actor based on actorId
		var actor models.Actor
		if err := db.Where("id = ?", uint(actorID)).First(&actor).Error; err != nil {
			if err == gorm.ErrRecordNotFound {
				http.Error(w, "Actor not found", http.StatusNotFound)
				return
			}
			http.Error(w, "Error retrieving actor", http.StatusInternalServerError)
			return
		}

		// Parse the request body to get the new response and active values
		var updatedActor struct {
			Response bool `json:"response"`
			Active   bool `json:"active"`
		}
		if err := json.NewDecoder(r.Body).Decode(&updatedActor); err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}

		// Update the actor's response and active fields
		actor.Response = updatedActor.Response
		actor.Active = updatedActor.Active
		if err := db.Save(&actor).Error; err != nil {
			http.Error(w, "Error updating actor", http.StatusInternalServerError)
			return
		}

		// Return the updated actor
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(actor)
	}
}

// CreateActor creates a new actor for a given user and kermesse if one doesn't already exist
func AddActor(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Get the user from the token (authentication)
		user, err := GetUserFromToken(r, db)
		if err != nil {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Get the kermesseId from query parameters
		kermesseIDParam := r.URL.Query().Get("kermesse_id")
		if kermesseIDParam == "" {
			http.Error(w, "kermesse_id query parameter is required", http.StatusBadRequest)
			return
		}

		// Convert the kermesseId string to uint
		kermesseID, err := strconv.ParseUint(kermesseIDParam, 10, 32)
		if err != nil {
			http.Error(w, "Invalid kermesse_id", http.StatusBadRequest)
			return
		}

		// Create the new actor
		actor := models.Actor{
			UserID:     user.ID,
			KermesseID: uint(kermesseID),
		}

		// Save the new actor to the database
		if err := db.Create(&actor).Error; err != nil {
			http.Error(w, "Error creating actor", http.StatusInternalServerError)
			return
		}

		// Return the created actor in JSON format
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(actor)
	}
}

func GetActorsWithMyKermesses(db *gorm.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("GetMyKermessesWithActors called")

		database.MigrateAll(db) // Initialize all tables if they don't exist

		// Retrieve the user from the token
		user, err := GetUserFromToken(r, db)
		if err != nil {
			log.Printf("Error getting user from token: %v", err)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		// Find all Kermesses where the user is an actor
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

		// Collect all kermesse IDs
		var kermesseIDs []uint
		for _, k := range kermesses {
			kermesseIDs = append(kermesseIDs, k.ID)
		}

		// Retrieve all actors for the kermesses and include user info (email, firstname, lastname)
		var actorUsers []models.ActorUser
		result = db.Table("actors").
			Select("actors.id, actors.user_id, actors.kermesse_id, actors.active, actors.response, actors.nb_jeton, users.email, users.firstname, users.lastname").
			Joins("JOIN users ON users.id = actors.user_id").
			Where("actors.kermesse_id IN ? AND ((actors.response = ? AND actors.active = ?) OR (actors.response = ? AND actors.active = ?))", kermesseIDs, true, true, false, false).
			Find(&actorUsers)

		if result.Error != nil {
			fmt.Println("Error retrieving actors from database:", result.Error)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("Actors with user info retrieved successfully:", actorUsers)
		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(actorUsers)
		if err != nil {
			fmt.Println("Error encoding response to JSON:", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		fmt.Println("Response encoded and sent successfully")
	}
}
