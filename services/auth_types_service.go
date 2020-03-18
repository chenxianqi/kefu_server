package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
)

// AuthTypesRepositoryInterface interface
type AuthTypesRepositoryInterface interface {
	GetAuthType(id int64) *models.AuthTypes
}

// AuthTypesRepository struct
type AuthTypesRepository struct {
	BaseRepository
}

// GetAuthTypesRepositoryInstance get instance
func GetAuthTypesRepositoryInstance() *AuthTypesRepository {
	instance := new(AuthTypesRepository)
	instance.Init(new(models.AuthTypes))
	return instance
}

// GetAuthType get a authType
func (r *AuthTypesRepository) GetAuthType(id int64) *models.AuthTypes {
	var authType models.AuthTypes
	if err := r.q.Filter("id", id).One(&authType); err != nil {
		logs.Warn("GetAuthType get a authType------------", err)
		return nil
	}
	return &authType
}
