package models

// Participant représente un participant à un événement
type Stand struct {
	ID         uint   `gorm:"primaryKey" json:"id"`
	ActorID    uint   `json:"actor_id" gorm:"not null"`
	KermesseID uint   `json:"kermesse_id" gorm:"not null"`
	Name       string `json:"name"`
	Type       string `json:"type"`
	MaxPoint   int    `json:"max_point" gorm:"default:0"`
}
