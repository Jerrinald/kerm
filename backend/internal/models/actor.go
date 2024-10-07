package models

// Participant représente un participant à un événement
type Actor struct {
	ID         uint `gorm:"primaryKey" json:"id"`
	UserID     uint `json:"user_id" gorm:"not null"`
	KermesseID uint `json:"kermesse_id" gorm:"not null"`
	Active     bool `json:"active" gorm:"default:false"` // New active field
	Response   bool `json:"response" gorm:"default:false"`
	NbJeton    int  `json:"nb_jeton" gorm:"default:0"`
}

// Participant représente un participant à un événement
type ActorUser struct {
	ID         uint   `gorm:"primaryKey" json:"id"`
	UserID     uint   `json:"user_id" gorm:"not null"`
	KermesseID uint   `json:"kermesse_id" gorm:"not null"`
	Active     bool   `json:"active" gorm:"default:false"` // New active field
	Response   bool   `json:"response" gorm:"default:false"`
	NbJeton    int    `json:"nb_jeton" gorm:"default:0"`
	Email      string `json:"email"`
	Firstname  string `json:"firstname" required:""`
	Lastname   string `json:"lastname" required:""`
}
