package services

import (
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// CompanyRepositoryInterface interface
type CompanyRepositoryInterface interface {
	GetCompany(id int64) *models.Company
	UpdateParams(id int64, params *orm.Params) (int64, error)
}

// CompanyRepository struct
type CompanyRepository struct {
	BaseRepository
}

// GetCompany get one company
func (r *CompanyRepository) GetCompany(id int64) *models.Company {
	var company models.Company
	if err := r.q.Filter("id", id).One(&company); err != nil {
		logs.Warn("GetCompany get one company------------", err)
		return nil
	}
	return &company
}

// UpdateParams update company
func (r *CompanyRepository) UpdateParams(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("UpdateParams update company------------", err)
	}
	return index, err
}
