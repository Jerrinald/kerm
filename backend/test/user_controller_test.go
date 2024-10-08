package controllers_test

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"backend/internal/controllers"
	"backend/internal/database"
	"backend/internal/models"

	"github.com/gorilla/mux"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func setupTestDB() *gorm.DB {
	db, _ := gorm.Open(sqlite.Open("file::memory:?cache=shared"), &gorm.Config{})
	database.MigrateAll(db)
	return db
}

func TestRegisterUser(t *testing.T) {
	db := setupTestDB()
	handler := controllers.RegisterUser(db)

	user := models.User{
		Email:     "test@example.com",
		Firstname: "John",
		Lastname:  "Doe",
		Password:  "password",
	}

	jsonUser, _ := json.Marshal(user)
	req, _ := http.NewRequest("POST", "/register", bytes.NewBuffer(jsonUser))
	req.Header.Set("Content-Type", "application/json")

	rr := httptest.NewRecorder()
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusCreated {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusCreated)
	}

	var returnedUser models.User
	if err := json.NewDecoder(rr.Body).Decode(&returnedUser); err != nil {
		t.Errorf("handler returned invalid body: %v", err)
	}

	if returnedUser.Email != user.Email {
		t.Errorf("handler returned unexpected user: got %v want %v",
			returnedUser.Email, user.Email)
	}
}

func TestLoginUser(t *testing.T) {
	db := setupTestDB()
	controllers.RegisterUser(db).ServeHTTP(httptest.NewRecorder(), httptest.NewRequest("POST", "/register", bytes.NewBuffer([]byte(`{"email":"test@example.com","firstname":"John","lastname":"Doe","password":"password"}`))))

	handler := controllers.LoginUser(db)

	credentials := models.User{
		Email:    "test@example.com",
		Password: "password",
	}

	jsonCredentials, _ := json.Marshal(credentials)
	req, _ := http.NewRequest("POST", "/login", bytes.NewBuffer(jsonCredentials))
	req.Header.Set("Content-Type", "application/json")

	rr := httptest.NewRecorder()
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	var responseBody map[string]string
	if err := json.NewDecoder(rr.Body).Decode(&responseBody); err != nil {
		t.Errorf("handler returned invalid body: %v", err)
	}

	if _, exists := responseBody["token"]; !exists {
		t.Errorf("handler returned no token")
	}
}

func TestGetUserByID(t *testing.T) {
	db := setupTestDB()
	controllers.RegisterUser(db).ServeHTTP(httptest.NewRecorder(), httptest.NewRequest("POST", "/register", bytes.NewBuffer([]byte(`{"email":"test@example.com","firstname":"John","lastname":"Doe","password":"password"}`))))

	req, _ := http.NewRequest("GET", "/user/1", nil)
	rr := httptest.NewRecorder()

	router := mux.NewRouter()
	router.HandleFunc("/user/{userId}", controllers.GetUserByID(db)).Methods("GET")
	router.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	var user models.User
	if err := json.NewDecoder(rr.Body).Decode(&user); err != nil {
		t.Errorf("handler returned invalid body: %v", err)
	}

	if user.Email != "test@example.com" {
		t.Errorf("handler returned unexpected user: got %v want %v",
			user.Email, "test@example.com")
	}
}
