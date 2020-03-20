package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// CompanyRepositoryInterface interface
type CompanyRepositoryInterface interface {
	GetCompany() *models.Company
	Update(id int64, params *orm.Params) (int64, error)
}

// CompanyRepository struct
type CompanyRepository struct {
	BaseRepository
}

// GetCompanyRepositoryInstance get instance
func GetCompanyRepositoryInstance() *CompanyRepository {
	instance := new(CompanyRepository)
	instance.Init(new(models.Company))
	return instance
}

// GetCompany get one company
func (r *CompanyRepository) GetCompany() *models.Company {
	var company models.Company
	if err := r.q.Filter("id", 1).One(&company); err != nil {
		logs.Warn("GetCompany get one company------------", err)
		return nil
	}
	return &company
}

// Update company
func (r *CompanyRepository) Update(params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", 1).Update(params)
	if err != nil {
		logs.Warn("Update company------------", err)
	}
	return index, err
}
