package routes

import (
	"backend/internal/controllers"
	"backend/internal/models"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"gorm.io/gorm"
)

func RegisterPublicRoutes(router *mux.Router, api *swag.API, db *gorm.DB) {
	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/register",
			endpoint.Handler(http.HandlerFunc(controllers.RegisterUser(db))),
			endpoint.Summary("Register a new user"),
			endpoint.Description("Register a new user with a username and password"),
			endpoint.Body(models.User{}, "User object that needs to be registered", true),
			endpoint.Response(http.StatusCreated, "Successfully registered user", endpoint.SchemaResponseOption(&models.User{})),
			endpoint.Tags("Auth"),
		),
		endpoint.New(
			http.MethodPost, "/login",
			endpoint.Handler(http.HandlerFunc(controllers.LoginUser(db))),
			endpoint.Summary("Login a user"),
			endpoint.Description("Login a user and get a token"),
			endpoint.Body(models.User{}, "User credentials", true),
			endpoint.Response(http.StatusOK, "Successfully logged in", endpoint.SchemaResponseOption(&map[string]string{"token": ""})),
			endpoint.Tags("Auth"),
		),
		endpoint.New(
			http.MethodPost, "/forgot-password",
			endpoint.Handler(http.HandlerFunc(controllers.ForgotPassword(db))),
			endpoint.Summary("Forgot password"),
			endpoint.Description("Request a password reset"),
			endpoint.Body(struct {
				Email string `json:"email"`
			}{}, "Email for password reset", true),
			endpoint.Response(http.StatusOK, "OTP sent to email", endpoint.SchemaResponseOption(&map[string]string{"message": "OTP sent to your email"})),
			endpoint.Tags("Auth"),
		),
		endpoint.New(
			http.MethodPost, "/reset-password",
			endpoint.Handler(http.HandlerFunc(controllers.ResetPassword(db))),
			endpoint.Summary("Reset password"),
			endpoint.Description("Reset the password using OTP"),
			endpoint.Body(struct {
				Email       string `json:"email"`
				OTP         string `json:"otp"`
				NewPassword string `json:"new_password"`
			}{}, "OTP and new password", true),
			endpoint.Response(http.StatusOK, "Password reset successful", endpoint.SchemaResponseOption(&map[string]string{"message": "Password reset successful"})),
			endpoint.Tags("Auth"),
		),
	)

	api.Walk(func(path string, e *swag.Endpoint) {
		h := e.Handler.(http.HandlerFunc)
		router.Path(path).Methods(e.Method).Handler(h)
	})
}

func RegisterAuthRoutes(router *mux.Router, api *swag.API, db *gorm.DB) {
	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/registerAdmin",
			endpoint.Handler(http.HandlerFunc(controllers.RegisterUserAdmin(db))),
			endpoint.Summary("Register a new user"),
			endpoint.Description("Register a new user with a username and password"),
			endpoint.Body(models.User{}, "User object that needs to be registered", true),
			endpoint.Response(http.StatusCreated, "Successfully registered user", endpoint.SchemaResponseOption(&models.User{})),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodGet, "/users",
			endpoint.Handler(http.HandlerFunc(controllers.GetAllUsers(db))),
			endpoint.Summary("Get all users"),
			endpoint.Description("Retrieve all users"),
			endpoint.Response(http.StatusOK, "Successfully retrieved users", endpoint.SchemaResponseOption(&[]models.User{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodGet, "/my-user",
			endpoint.Handler(http.HandlerFunc(controllers.MyUser(db))),
			endpoint.Summary("Get my user info"),
			endpoint.Description("My user information"),
			endpoint.Response(http.StatusOK, "Successfully retrieved user", endpoint.SchemaResponseOption(&models.User{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodGet, "/users/{userId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetUserByID(db))),
			endpoint.Summary("Get user by ID"),
			endpoint.Description("Retrieve a user by their ID"),
			endpoint.Path("userId", "integer", "ID of the user to retrieve", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved user", endpoint.SchemaResponseOption(&models.User{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodPatch, "/users/{userId}",
			endpoint.Handler(http.HandlerFunc(controllers.UpdateUserByID(db))),
			endpoint.Summary("Update user by ID"),
			endpoint.Description("Update a user by their ID"),
			endpoint.Path("userId", "integer", "ID of the user to update", true),
			endpoint.Body(models.User{}, "Fields to update in user object", true),
			endpoint.Response(http.StatusOK, "Successfully updated user", endpoint.SchemaResponseOption(&models.User{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodDelete, "/users/{userId}",
			endpoint.Handler(http.HandlerFunc(controllers.DeleteUserByID(db))),
			endpoint.Summary("Delete user by ID"),
			endpoint.Description("Delete a user by their ID"),
			endpoint.Path("userId", "integer", "ID of the user to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted user"),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),

		endpoint.New(
			http.MethodGet, "/kermesses",
			endpoint.Handler(http.HandlerFunc(controllers.GetAllKermesses(db))),
			endpoint.Summary("Get all kermesses"),
			endpoint.Description("Get all kermesses"),
			endpoint.Response(http.StatusOK, "Successfully retrieved kermesses", endpoint.SchemaResponseOption(&[]models.Kermesse{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Kermesses"),
		),
		endpoint.New(
			http.MethodGet, "/kermesses/{kermesseId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetKermessetByID(db))),
			endpoint.Summary("Find kermesse by ID"),
			endpoint.Path("kermesseId", "integer", "ID of kermesse to return", true),
			endpoint.Response(http.StatusOK, "successful operation", endpoint.SchemaResponseOption(&models.Kermesse{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Kermesses"),
		),
		endpoint.New(
			http.MethodGet, "/my-kermesses",
			endpoint.Handler(http.HandlerFunc(controllers.GetMyKermesses(db))),
			endpoint.Summary("Get all kermesses"),
			endpoint.Description("Get all kermesses"),
			endpoint.Response(http.StatusOK, "Successfully retrieved kermesses", endpoint.SchemaResponseOption(&[]models.Kermesse{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Kermesses"),
		),
		endpoint.New(
			http.MethodPost, "/kermesses-orga",
			endpoint.Handler(http.HandlerFunc(controllers.AddKermesseOrganisateur(db))),
			endpoint.Summary("Add a new kermesse with organisateur"),
			endpoint.Description("Add a new kermesse with organisateur"),
			endpoint.Body(models.Kermesse{}, "Kermesse object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully added kermesse", endpoint.SchemaResponseOption(&models.Kermesse{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Kermesses"),
		),
		endpoint.New(
			http.MethodGet, "/stands",
			endpoint.Handler(http.HandlerFunc(controllers.GetAllStands(db))),
			endpoint.Summary("Get all stands"),
			endpoint.Description("Get all stands"),
			endpoint.Response(http.StatusOK, "Successfully retrieved kermesses", endpoint.SchemaResponseOption(&[]models.Stand{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Stands"),
		),
		endpoint.New(
			http.MethodPost, "/stands-kermesse",
			endpoint.Handler(http.HandlerFunc(controllers.AddStand(db))),
			endpoint.Summary("Add a new stand "),
			endpoint.Description("Add a new stand"),
			endpoint.Body(models.Stand{}, "stand object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully added stand", endpoint.SchemaResponseOption(&models.Stand{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Stands"),
		),
		endpoint.New(
			http.MethodGet, "/stands/{standId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetStandByID(db))),
			endpoint.Summary("Find stand by ID"),
			endpoint.Path("standId", "integer", "ID of standId to return", true),
			endpoint.Response(http.StatusOK, "successful operation", endpoint.SchemaResponseOption(&models.Stand{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Stands"),
		),
		endpoint.New(
			http.MethodGet, "/my-stand", // This is the endpoint URL
			endpoint.Handler(http.HandlerFunc(controllers.GetStandByActorAndKermesse(db))),
			endpoint.Summary("Find stand by actor and kermesse"),
			endpoint.Query("kermesse_id", "integer", "The ID of the Kermesse", true), // Ensure that kermesse_id is a required query parameter
			endpoint.Response(http.StatusOK, "successful operation", endpoint.SchemaResponseOption(&models.Stand{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Stands"),
		),
		endpoint.New(
			http.MethodGet, "/stands",
			endpoint.Handler(http.HandlerFunc(controllers.GetStandsByKermesseID(db))),
			endpoint.Summary("Get all stands by kermesses"),
			endpoint.Description("Get all stands by kermesses"),
			endpoint.Query("kermesse_id", "integer", "The ID of the Kermesse", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved stands", endpoint.SchemaResponseOption(&[]models.Stand{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Stands"),
		),
		// New endpoint for retrieving the total jetons and points for a stand
		endpoint.New(
			http.MethodGet, "/stands/{standId}/totals",
			endpoint.Handler(http.HandlerFunc(controllers.GetStandTotals(db))),
			endpoint.Summary("Get total jetons and points for a stand"),
			endpoint.Path("standId", "integer", "ID of the stand", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved totals", endpoint.SchemaResponseOption(&map[string]int{
				"total_jetons": 0,
				"total_points": 0,
			})),
			endpoint.Tags("StandStatistics"),
		),
		endpoint.New(
			http.MethodPost, "/stand-statistics",
			endpoint.Handler(http.HandlerFunc(controllers.AddStandSell(db))),
			endpoint.Summary("Add a new stand "),
			endpoint.Description("Add a new stand"),
			endpoint.Body(models.StatStand{}, "stand object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully added stand", endpoint.SchemaResponseOption(&models.StatStand{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("StandStatistics"),
		),
		endpoint.New(
			http.MethodPost, "/tombola",
			endpoint.Handler(http.HandlerFunc(controllers.BuyTicket(db))),
			endpoint.Summary("Buy a tombola ticket"),
			endpoint.Description("Buy a tombola ticket"),
			endpoint.Body(models.TombolaRequest{}, "Tombola request with number of tickets", true),
			endpoint.Response(http.StatusCreated, "Successfully buying ticket", endpoint.SchemaResponseOption(&map[string]string{
				"message": "Tickets created successfully"})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("StandStatistics"),
		),
		endpoint.New(
			http.MethodPost, "/actors", // Path to create an actor
			endpoint.Handler(http.HandlerFunc(controllers.AddActor(db))), // Handler function to create an actor
			endpoint.Summary("Create a new actor"),
			endpoint.Description("Create a new actor for the authenticated user and the specified kermesse"),
			endpoint.Query("kermesse_id", "integer", "The ID of the Kermesse", true), // Query parameter for kermesse ID
			endpoint.Response(http.StatusCreated, "Successfully created actor", endpoint.SchemaResponseOption(&models.Actor{})),
			endpoint.Security("BearerAuth"), // Require Bearer Authentication
			endpoint.Tags("Actors"),
		),
		endpoint.New(
			http.MethodGet, "/my-actor", // URL path to get actors by kermesse ID
			endpoint.Handler(http.HandlerFunc(controllers.GetActorByKermesse(db))), // Handler function for retrieving actors by kermesse ID
			endpoint.Summary("Get my actor by kermesse"),
			endpoint.Description("Retrieve the actor entry for the authenticated user and given kermesse ID"),
			endpoint.Query("kermesse_id", "integer", "The ID of the Kermesse", true), // Query parameter for kermesse ID
			endpoint.Response(http.StatusOK, "Successfully retrieved actor", endpoint.SchemaResponseOption(&models.Actor{})),
			endpoint.Security("BearerAuth"), // Require Bearer Authentication
			endpoint.Tags("Actors"),
		),
		endpoint.New(
			http.MethodPatch, "/actors-jeton/{actorId}", // URL path with actorId parameter
			endpoint.Handler(http.HandlerFunc(controllers.UpdateActorNbJeton(db))), // Handler function to update nbJeton
			endpoint.Summary("Update actor's nbJeton"),
			endpoint.Description("Update only the nbJeton field of an actor"),
			endpoint.Path("actorId", "integer", "ID of the actor to update", true),
			endpoint.Body(models.Actor{}, "Actor body", true),
			endpoint.Response(http.StatusOK, "Successfully updated actor", endpoint.SchemaResponseOption(&models.Actor{})),
			endpoint.Security("BearerAuth"), // Require Bearer Authentication
			endpoint.Tags("Actors"),
		),
		endpoint.New(
			http.MethodPatch, "/actors-active/{actorId}", // URL path with actorId parameter
			endpoint.Handler(http.HandlerFunc(controllers.UpdateActorResponseAndActive(db))), // Handler function to update nbJeton
			endpoint.Summary("Update actor's active"),
			endpoint.Description("Actor is active for the kermesse"),
			endpoint.Path("actorId", "integer", "ID of the actor to update", true),
			endpoint.Body(models.Actor{}, "Actor body", true),
			endpoint.Response(http.StatusOK, "Successfully updated actor", endpoint.SchemaResponseOption(&models.Actor{})),
			endpoint.Security("BearerAuth"), // Require Bearer Authentication
			endpoint.Tags("Actors"),
		),
		endpoint.New(
			http.MethodGet, "/actors-kermesse",
			endpoint.Handler(http.HandlerFunc(controllers.GetActorsWithMyKermesses(db))), // Reference to the new function
			endpoint.Summary("Get my kermesses with actors"),
			endpoint.Description("Get kermesses for the authenticated user with actors who either have both response = true and active = true, or both response = false and active = false."),
			endpoint.Response(http.StatusOK, "Successfully retrieved actors with user info", endpoint.SchemaResponseOption(&[]models.ActorUser{})),
			endpoint.Security("BearerAuth"), // Require Bearer Authentication
			endpoint.Tags("Kermesses", "Actors"),
		),
	)

	api.Walk(func(path string, e *swag.Endpoint) {
		h := e.Handler.(http.HandlerFunc)
		router.Path(path).Methods(e.Method).Handler(h)
	})
}

func RegisterSwaggerRoutes(router *mux.Router, api *swag.API) {
	// Ajout des routes Swagger
	router.Path("/swagger/json").Methods("GET").Handler(api.Handler())
	router.PathPrefix("/swagger/ui").Handler(swag.UIHandler("/swagger/ui", "/swagger/json", true))
}
