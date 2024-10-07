package models

// Participant représente un participant à un événement
type Tombola struct {
	ID         uint `gorm:"primaryKey" json:"id"`
	ActorID    uint `json:"actor_id" gorm:"not null"`
	KermesseID uint `json:"kermesse_id" gorm:"not null"`
}

// Participant représente un participant à un événement
type TombolaRequest struct {
	ID         uint `gorm:"primaryKey" json:"id"`
	ActorID    uint `json:"actor_id" gorm:"not null"`
	KermesseID uint `json:"kermesse_id" gorm:"not null"`
	NbTicket   int  `json:"nb_ticket" gorm:"not null"`
}
