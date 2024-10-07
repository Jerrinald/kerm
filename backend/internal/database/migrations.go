package database

import (
	"backend/internal/models"

	"gorm.io/gorm"
)

// MigrateUser migre la table User
func MigrateUser(db *gorm.DB) {
	db.AutoMigrate(&models.User{})
}

func MigrateKermesse(db *gorm.DB) {
	db.AutoMigrate(&models.Kermesse{})
}

func MigrateActor(db *gorm.DB) {
	db.AutoMigrate(&models.Actor{})
}

func MigrateStand(db *gorm.DB) {
	db.AutoMigrate(&models.Stand{})
}

func MigrateStatStand(db *gorm.DB) {
	db.AutoMigrate(&models.StatStand{})
}

func MigrateTombola(db *gorm.DB) {
	db.AutoMigrate(&models.Tombola{})
}

// MigrateAll migre toutes les tables
func MigrateAll(db *gorm.DB) {
	MigrateUser(db)
	MigrateKermesse(db)
	MigrateActor(db)
	MigrateStand(db)
	MigrateStatStand(db)
	MigrateTombola(db)
}
