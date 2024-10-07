package database

import (
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type DB interface {
	Create(value interface{}) error
	Find(out interface{}, where ...interface{}) error
	Where(query interface{}, args ...interface{}) DB
	First(out interface{}, where ...interface{}) error
	Delete(value interface{}, where ...interface{}) error
	Update(column string, value interface{}) error
}
type GormDB struct {
	DB *gorm.DB
}

func (g *GormDB) Create(value interface{}) error {
	return g.DB.Create(value).Error
}

func (g *GormDB) Find(out interface{}, where ...interface{}) error {
	return g.DB.Find(out, where...).Error
}

func ConnectDB() (*gorm.DB, error) {
	dsn := "user=janire password=password dbname=articlesDB port=5432 sslmode=disable host=database"
	var db *gorm.DB
	var err error
	for i := 0; i < 20; i++ { // retry 20 times with 10s delay
		db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
		if err == nil {
			return db, nil
		}
		time.Sleep(10 * time.Second) // increased sleep time
	}
	return nil, err // Return the last error after retries
}

func NewGormDB(db *gorm.DB) *GormDB {
	return &GormDB{DB: db}
}
