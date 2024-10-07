package models

// Participant représente un participant à un événement
type Kermesse struct {
	ID     uint   `gorm:"primaryKey" json:"id"`
	Name   string `json:"name"`
	Profit int    `json:"profit" gorm:"default:0"`
}
