package models

// Participant représente un participant à un événement
type StatStand struct {
	ID      uint `gorm:"primaryKey" json:"id"`
	ActorID uint `json:"actor_id" gorm:"not null"`
	StandID uint `json:"stand_id" gorm:"not null"`
	NbJeton int  `json:"nb_jeton" gorm:"not null"`
	NbPoint int  `json:"nb_joint" gorm:"default:0"`
}
