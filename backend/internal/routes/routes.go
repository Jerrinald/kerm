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
			endpoint.Response(http.StatusCreated, "Successfully registered user", endpoint.SchemaResponseOption(models.User{})),
			endpoint.Tags("Auth"),
		),
		endpoint.New(
			http.MethodPost, "/login",
			endpoint.Handler(http.HandlerFunc(controllers.LoginUser(db))),
			endpoint.Summary("Login a user"),
			endpoint.Description("Login a user and get a token"),
			endpoint.Body(models.User{}, "User credentials", true),
			endpoint.Response(http.StatusOK, "Successfully logged in", endpoint.SchemaResponseOption(map[string]string{"token": ""})),
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
			endpoint.Response(http.StatusOK, "OTP sent to email", endpoint.SchemaResponseOption(map[string]string{"message": "OTP sent to your email"})),
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
			endpoint.Response(http.StatusOK, "Password reset successful", endpoint.SchemaResponseOption(map[string]string{"message": "Password reset successful"})),
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
			http.MethodGet, "/users",
			endpoint.Handler(http.HandlerFunc(controllers.GetAllUsers(db))),
			endpoint.Summary("Get all users"),
			endpoint.Description("Retrieve all users"),
			endpoint.Response(http.StatusOK, "Successfully retrieved users", endpoint.SchemaResponseOption([]models.User{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodGet, "/users/{userId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetUserByID(db))),
			endpoint.Summary("Get user by ID"),
			endpoint.Description("Retrieve a user by their ID"),
			endpoint.Path("userId", "integer", "ID of the user to retrieve", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved user", endpoint.SchemaResponseOption(models.User{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodPatch, "/users/{userId}",
			endpoint.Handler(http.HandlerFunc(controllers.UpdateUserByID(db))),
			endpoint.Summary("Update user by ID"),
			endpoint.Description("Update a user by their ID"),
			endpoint.Path("userId", "integer", "ID of the user to update", true),
			endpoint.Body(map[string]interface{}{}, "Fields to update in user object", true),
			endpoint.Response(http.StatusOK, "Successfully updated user", endpoint.SchemaResponseOption(models.User{})),
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
			http.MethodGet, "/users-emails/{eventId}",
			endpoint.Handler(controllers.GetAllUserEmails(db)),
			endpoint.Summary("Get all user emails"),
			endpoint.Path("eventId", "integer", "ID of event", true),
			endpoint.Description("Retrieve all user emails from the store"),
			endpoint.Response(http.StatusOK, "Successfully retrieved user emails", endpoint.SchemaResponseOption([]string{})),
			endpoint.Tags("Users"),
		),

		endpoint.New(
			http.MethodGet, "/users-email/{email}",
			endpoint.Handler(http.HandlerFunc(controllers.GetUserByEmail(db))),
			endpoint.Summary("Get user by email"),
			endpoint.Description("Retrieve a user by the email"),
			endpoint.Path("email", "string", "Email of the user to retrieve", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved user", endpoint.SchemaResponseOption(models.User{})),
			endpoint.Tags("Users"),
		),
		endpoint.New(
			http.MethodGet, "/events",
			endpoint.Handler(controllers.GetAllEvents(db)),
			endpoint.Summary("Get all events"),
			endpoint.Description("Retrieve all events from the store"),
			endpoint.Response(http.StatusOK, "Successfully retrieved events", endpoint.SchemaResponseOption([]models.Event{})),
			endpoint.Tags("Events"),
		),
		endpoint.New(
			http.MethodPost, "/events",
			endpoint.Handler(http.HandlerFunc(controllers.AuthenticatedAddEvent(db))),
			endpoint.Summary("Add a new event"),
			endpoint.Description("Add a new event to the store"),
			endpoint.Body(models.EventAdd{}, "Event object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully added event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Events"),
		),
		endpoint.New(
			http.MethodGet, "/events/{eventId}",
			endpoint.Handler(http.HandlerFunc(controllers.AuthenticatedFindEventByID(db))),
			endpoint.Summary("Find event by ID"),
			endpoint.Path("eventId", "integer", "ID of event to return", true),
			endpoint.Response(http.StatusOK, "successful operation", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Events"),
		),
		endpoint.New(
			http.MethodPatch, "/events/{eventId}",
			endpoint.Handler(http.HandlerFunc(controllers.AuthenticatedUpdateEventByID(db))),
			endpoint.Path("eventId", "integer", "ID of the event to update", true),
			endpoint.Body(map[string]interface{}{}, "Fields to update in the event object", true),
			endpoint.Response(http.StatusOK, "Successfully updated event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Events"),
		),
		endpoint.New(
			http.MethodDelete, "/events/{eventId}",
			endpoint.Handler(http.HandlerFunc(controllers.AuthenticatedDeleteEventByID(db))),
			endpoint.Summary("Delete event by ID"),
			endpoint.Description("Delete an event by its ID"),
			endpoint.Path("eventId", "integer", "ID of the event to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted event"),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Events"),
		),
		endpoint.New(
			http.MethodPatch, "/events/{id}/activate-transport",
			endpoint.Handler(http.HandlerFunc(controllers.ActivateTransport(db))),
			endpoint.Summary("Activate transport for an event"),
			endpoint.Description("Update the transport active status for a given event"),
			endpoint.Path("id", "string", "ID of the event", true),
			endpoint.Body(models.EventTransportUpdate{}, "Transport update object", true),
			endpoint.Response(http.StatusOK, "Successfully updated event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodPost, "/participants",
			endpoint.Handler(http.HandlerFunc(controllers.AddParticipant(db))),
			endpoint.Summary("Add a new participant"),
			endpoint.Description("Add a new participant to an event"),
			endpoint.Body(models.ParticipantAdd{}, "Participant object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully added participant", endpoint.SchemaResponseOption(models.Participant{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Participants"),
		),
		endpoint.New(
			http.MethodPatch, "/participants/{participantId}",
			endpoint.Handler(http.HandlerFunc(controllers.UpdateParticipant(db))),
			endpoint.Summary("Modifier un participant"),
			endpoint.Description("Modifier participant d'un événement"),
			endpoint.Path("participantId", "integer", "ID du particpant", true),
			endpoint.Body(models.Participant{}, "Data Participant", true),
			endpoint.Response(http.StatusCreated, "Participant modifié avec succès", endpoint.SchemaResponseOption(models.Participant{})),
			endpoint.Tags("Participants"),
		),
		endpoint.New(
			http.MethodGet, "/participants/{participantId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetParticipantByID(db))),
			endpoint.Summary("Get participant by ID"),
			endpoint.Description("Retrieve a participant by their ID"),
			endpoint.Path("participantId", "integer", "ID of the participant to retrieve", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved participant", endpoint.SchemaResponseOption(models.Participant{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Participants"),
		),
		endpoint.New(
			http.MethodDelete, "/participants/{participantId}",
			endpoint.Handler(http.HandlerFunc(controllers.DeleteParticipantByID(db))),
			endpoint.Summary("Delete participant by ID"),
			endpoint.Description("Delete a participant by their ID"),
			endpoint.Path("participantId", "integer", "ID of the participant to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted participant"),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Participants"),
		),
		endpoint.New(
			http.MethodGet, "/participants-event/{eventId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetParticipantsByEventID(db))),
			endpoint.Summary("Get participants by event ID"),
			endpoint.Description("Retrieve participants associated with a specific event"),
			endpoint.Path("eventId", "integer", "ID of the event", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved participants", endpoint.SchemaResponseOption([]models.Participant{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Participants"),
		),
		endpoint.New(
			http.MethodGet, "/get-participant/{eventId}",
			endpoint.Handler(controllers.GetParticipantByEventId(db)),
			endpoint.Summary("Get participant by user ID and event ID"),
			endpoint.Path("eventId", "string", "ID of the event", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved participant", endpoint.SchemaResponseOption(models.Participant{})),
			endpoint.Tags("Participants"),
		),

		endpoint.New(
			http.MethodPost, "/items",
			endpoint.Handler(http.HandlerFunc(controllers.AddItem(db))),
			endpoint.Summary("Add a new item"),
			endpoint.Description("Add a new item to an event"),
			endpoint.Body(models.ItemEvent{}, "Item object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully added item", endpoint.SchemaResponseOption(models.ItemEvent{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Items"),
		),
		endpoint.New(
			http.MethodGet, "/items",
			endpoint.Handler(http.HandlerFunc(controllers.GetAllItems(db))),
			endpoint.Summary("Get all items"),
			endpoint.Description("Retrieve all items"),
			endpoint.Response(http.StatusOK, "Successfully retrieved items", endpoint.SchemaResponseOption([]models.ItemEvent{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Items"),
		),
		endpoint.New(
			http.MethodGet, "/items/{itemId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetItemByID(db))),
			endpoint.Summary("Get item by ID"),
			endpoint.Description("Retrieve an item by its ID"),
			endpoint.Path("itemId", "integer", "ID of the item to retrieve", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved item", endpoint.SchemaResponseOption(models.ItemEvent{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Items"),
		),
		endpoint.New(
			http.MethodDelete, "/items/{itemId}",
			endpoint.Handler(http.HandlerFunc(controllers.DeleteItemByID(db))),
			endpoint.Summary("Delete item by ID"),
			endpoint.Description("Delete an item by its ID"),
			endpoint.Path("itemId", "integer", "ID of the item to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted item"),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Items"),
		),
		endpoint.New(
			http.MethodPatch, "/items/{itemId}",
			endpoint.Handler(http.HandlerFunc(controllers.UpdateItemByID(db))),
			endpoint.Summary("Update item by ID"),
			endpoint.Description("Update an item's details by its ID"),
			endpoint.Path("itemId", "integer", "ID of the item to update", true),
			endpoint.Body(models.ItemEvent{}, "Updated item details", true),
			endpoint.Response(http.StatusOK, "Successfully updated item", endpoint.SchemaResponseOption(models.ItemEvent{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Items"),
		),
		endpoint.New(
			http.MethodGet, "/items-event/{eventId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetItemsByEventID(db))),
			endpoint.Summary("Get items by event ID"),
			endpoint.Description("Retrieve items associated with a specific event"),
			endpoint.Path("eventId", "integer", "ID of the event", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved items", endpoint.SchemaResponseOption([]models.ItemEvent{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Items"),
		),
		endpoint.New(
			http.MethodPost, "/event/{eventId}/add-food",
			endpoint.Handler(http.HandlerFunc(controllers.AddFoodToEvent(db))),
			endpoint.Summary("Ajouter de la nourriture à un événement"),
			endpoint.Description("Permettre à un participant d'ajouter de la nourriture à un événement"),
			endpoint.Path("eventId", "integer", "ID de l'événement", true),
			endpoint.Body(struct {
				Food string `json:"food"`
			}{}, "Nourriture à ajouter à l'événement", true),
			endpoint.Response(http.StatusCreated, "Nourriture ajoutée avec succès à l'événement", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Food"),
		),
		endpoint.New(
			http.MethodPost, "/event/{eventId}/transportations",
			endpoint.Handler(http.HandlerFunc(controllers.AddTransportationToEvent(db))),
			endpoint.Summary("Ajouter un moyen de transport à un événement"),
			endpoint.Description("Permettre à un participant d'ajouter un moyen de transport à un événement"),
			endpoint.Path("eventId", "integer", "ID de l'événement", true),
			endpoint.Body(models.Transportation{}, "transportation that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Transport ajouté avec succès à l'événement", endpoint.SchemaResponseOption(models.Transportation{})),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodGet, "/transportations",
			endpoint.Handler(http.HandlerFunc(controllers.GetAllTransportations(db))),
			endpoint.Summary("Get all transportations"),
			endpoint.Description("Retrieve all transportation records"),
			endpoint.Response(http.StatusOK, "Successfully retrieved all transportations", endpoint.SchemaResponseOption([]models.Transportation{})),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodGet, "/transportations/{transportationId}",
			endpoint.Handler(http.HandlerFunc(controllers.GetTransportationByID(db))),
			endpoint.Summary("Get transportation by ID"),
			endpoint.Description("Retrieve a transportation by its ID"),
			endpoint.Path("transportationId", "integer", "ID of the transportation to retrieve", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved transportation", endpoint.SchemaResponseOption(models.Transportation{})),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodPatch, "/transportations/{transportationId}",
			endpoint.Handler(http.HandlerFunc(controllers.UpdateTransportationByID(db))),
			endpoint.Summary("Update transportation by ID"),
			endpoint.Description("Update a transportation's details by its ID"),
			endpoint.Path("transportationId", "integer", "ID of the transportation to update", true),
			endpoint.Body(models.Transportation{}, "Updated transportation details", true),
			endpoint.Response(http.StatusOK, "Successfully updated transportation", endpoint.SchemaResponseOption(models.Transportation{})),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodDelete, "/transportations/{transportationId}",
			endpoint.Handler(http.HandlerFunc(controllers.DeleteTransportationByID(db))),
			endpoint.Summary("Delete transportation by ID"),
			endpoint.Description("Delete a transportation by its ID"),
			endpoint.Path("transportationId", "integer", "ID of the transportation to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted transportation"),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodGet, "/event/{eventId}/transportations",
			endpoint.Handler(controllers.GetTransportationsByEvent(db)),
			endpoint.Summary("Get transportation by event ID"),
			endpoint.Path("eventId", "integer", "ID of event to return transportation details for", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved transportation details", endpoint.SchemaResponseOption([]models.Transportation{})),
			endpoint.Tags("Transportations"),
		),
		endpoint.New(
			http.MethodGet, "/transportation/{transportationId}/participants",
			endpoint.Handler(controllers.GetParticipantsWithUserByTransportationID(db)),
			endpoint.Summary("Get transportation by transportation ID"),
			endpoint.Path("transportationId", "integer", "ID of transportation to return participant details for", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved participants for transportation", endpoint.SchemaResponseOption([]models.ParticipantWithUser{})),
			endpoint.Body(struct {
				Transportation string `json:"transportation"`
			}{}, "Moyen de transport à ajouter à l'événement", true),
			endpoint.Response(http.StatusCreated, "Transport ajouté avec succès à l'événement", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Transportation"),
		),
		endpoint.New(
			http.MethodPost, "/event/{eventId}/add-food",
			endpoint.Handler(http.HandlerFunc(controllers.AddFoodToEvent(db))),
			endpoint.Summary("Ajouter de la nourriture à un événement"),
			endpoint.Description("Permettre à un participant d'ajouter de la nourriture à un événement"),
			endpoint.Path("eventId", "integer", "ID de l'événement", true),
			endpoint.Body(struct {
				Food string `json:"food"`
			}{}, "Nourriture à ajouter à l'événement", true),
			endpoint.Response(http.StatusCreated, "Nourriture ajoutée avec succès à l'événement", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Events"),
		),
		endpoint.New(
			http.MethodPost, "/event/{eventId}/add-activity",
			endpoint.Handler(http.HandlerFunc(controllers.AddActivityToEvent(db))),
			endpoint.Summary("Ajouter une activité à un événement"),
			endpoint.Description("Permettre à un participant d'ajouter une activité à un événement"),
			endpoint.Path("eventId", "integer", "ID de l'événement", true),
			endpoint.Body(struct {
				Activity string `json:"activity"`
			}{}, "Activité à ajouter à l'événement", true),
			endpoint.Response(http.StatusCreated, "Activité ajoutée avec succès à l'événement", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Activities"),
		),
		endpoint.New(
			http.MethodPost, "/event/{eventId}/chat",
			endpoint.Handler(http.HandlerFunc(controllers.AddMessageToChat(db))),
			endpoint.Summary("Envoyer un message dans la salle de chat de l'événement"),
			endpoint.Description("Envoyer un message dans la salle de chat de l'événement"),
			endpoint.Path("eventId", "integer", "ID de l'événement de la salle de chat", true),
			endpoint.Body(models.MessageAdd{}, "Message object", true),
			endpoint.Response(http.StatusCreated, "Message sent", endpoint.SchemaResponseOption(models.Message{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Chat"),
		),
		endpoint.New(
			http.MethodGet, "/chat-rooms/{chatRoomId}/messages",
			endpoint.Handler(http.HandlerFunc(controllers.GetMessagesByChatRoom(db))),
			endpoint.Summary("Get messages"),
			endpoint.Description("Retrieve messages from the event chat room"),
			endpoint.Path("chatRoomId", "integer", "ID of the chat room", true),
			endpoint.Response(http.StatusOK, "Messages retrieved", endpoint.SchemaResponseOption([]models.MessageResponse{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Chat"),
		),
		endpoint.New(
			http.MethodGet, "/invitations/{email}",
			endpoint.Handler(http.HandlerFunc(controllers.GetInvitationsByUser(db))),
			endpoint.Summary("Get invitations by user"),
			endpoint.Description("Retrieve participant items where the user ID matches the provided parameter and response is true"),
			endpoint.Path("email", "string", "Email of the user", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved participants", endpoint.SchemaResponseOption([]models.Invitation{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Invitations"),
		),
		endpoint.New(
			http.MethodPost, "/answer-invitation",
			endpoint.Handler(http.HandlerFunc(controllers.AnswerInvitation(db))),
			endpoint.Summary("Response to invitation"),
			endpoint.Description("Response to an invitation"),
			endpoint.Body(models.InvitationAnswer{}, "Message object", true),
			endpoint.Response(http.StatusOK, "Successfully answered invitation", endpoint.SchemaResponseOption(models.Participant{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Invitations"),
		),
		endpoint.New(
			http.MethodPatch, "/events/{id}/activate-transport",
			endpoint.Handler(http.HandlerFunc(controllers.ActivateTransport(db))),
			endpoint.Summary("Activate transport for an event"),
			endpoint.Description("Update the transport active status for a given event"),
			endpoint.Path("id", "string", "ID of the event", true),
			endpoint.Body(models.EventTransportUpdate{}, "Transport update object", true),
			endpoint.Response(http.StatusOK, "Successfully updated event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Transportations"),
		),

		endpoint.New(
			http.MethodPost, "/event/{eventId}/cagnotte",
			endpoint.Handler(controllers.AuthMiddleware(controllers.AddCagnotte(db))),
			endpoint.Summary("Ajouter une cagnotte"),
			endpoint.Description("Ajouter une cagnotte à un événement"),
			endpoint.Path("eventId", "integer", "ID de l'événement", true),
			endpoint.Response(http.StatusCreated, "Cagnotte ajoutée avec succès", endpoint.SchemaResponseOption(models.Cagnotte{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Cagnotte"),
		),
		endpoint.New(
			http.MethodPost, "/cagnotte/{cagnotteId}/contribution",
			endpoint.Handler(controllers.AuthMiddleware(controllers.ContributeToCagnotte(db))),
			endpoint.Summary("Contribuer à une cagnotte"),
			endpoint.Description("Contribuer à une cagnotte existante"),
			endpoint.Path("cagnotteId", "integer", "ID de la cagnotte", true),
			endpoint.Response(http.StatusCreated, "Contribution ajoutée avec succès", endpoint.SchemaResponseOption(models.Contribution{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Cagnotte"),
		),
		endpoint.New(
			http.MethodGet, "/cagnotte/{cagnotteId}/contributors",
			endpoint.Handler(controllers.AuthMiddleware(controllers.GetContributorsByCagnotteID(db))),
			endpoint.Summary("Voir les contributeurs d'une cagnotte"),
			endpoint.Description("Voir la liste des personnes ayant contribué à une cagnotte"),
			endpoint.Path("cagnotteId", "integer", "ID de la cagnotte", true),
			endpoint.Response(http.StatusOK, "Liste des contributeurs récupérée avec succès", endpoint.SchemaResponseOption([]models.Contribution{})),
			endpoint.Security("BearerAuth"),
			endpoint.Tags("Cagnotte"),
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
