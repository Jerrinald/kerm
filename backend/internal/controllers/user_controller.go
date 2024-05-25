package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/sessions"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

// User représente la structure d'un utilisateur
type User struct {
	ID       int64  `gorm:"primaryKey" json:"id"`
	Username string `json:"username" validate:"required"`
	Password string `json:"password" validate:"required"`
}

// MigrateUser crée la table User si elle n'existe pas
func MigrateUser(db *gorm.DB) {
	db.AutoMigrate(&User{})
}

// RegisterUser gère l'enregistrement d'un nouvel utilisateur
func RegisterUser(db *gorm.DB, store *sessions.CookieStore) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Initialiser la table User si elle n'existe pas
		MigrateUser(db)

		var user User
		if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}
		user.Password = string(hashedPassword)

		result := db.Create(&user)
		if result.Error != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(user)
	}
}

// LoginUser gère la connexion d'un utilisateur
func LoginUser(db *gorm.DB, store *sessions.CookieStore) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Initialiser la table User si elle n'existe pas
		MigrateUser(db)

		var credentials User
		if err := json.NewDecoder(r.Body).Decode(&credentials); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var user User
		result := db.Where("username = ?", credentials.Username).First(&user)
		if result.Error != nil {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		if bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(credentials.Password)) != nil {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		session, err := store.Get(r, "session")
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		session.Values["authenticated"] = true
		if err := session.Save(r, w); err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(map[string]string{"message": "Successfully logged in"})
	}
}

// AuthMiddleware vérifie si l'utilisateur est authentifié
func AuthMiddleware(store *sessions.CookieStore, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		session, err := store.Get(r, "session")
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		if auth, ok := session.Values["authenticated"].(bool); !ok || !auth {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		next.ServeHTTP(w, r)
	})
}
