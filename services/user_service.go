package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
)

// UserRepositoryInterface interface
type UserRepositoryInterface interface {
	GetUser(id int64) *models.User
}

// UserRepository struct
type UserRepository struct {
	BaseRepository
}

// GetUser get one User
func (r *UserRepository) GetUser(id int64) *models.User {
	var user models.User
	if err := r.q.Filter("id", id).One(&user); err != nil {
		logs.Warn("GetUser get one User------------", err)
		return nil
	}
	return &user
}
