package services

import (
	"kefu_server/models"
	"strings"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// KnowledgeBaseRepositoryInterface interface
type KnowledgeBaseRepositoryInterface interface {
	GetKnowledgeBase(id int64) *models.KnowledgeBase
	GetKnowledgeBases(request models.PaginationData) (*models.PaginationData, error)
	GetKnowledgeBaseWithTitle(title string) *models.KnowledgeBase
	Add(knowledgeBase *models.KnowledgeBase, col1 string) (bool, int64, error)
	UpdateParams(id int64, params *orm.Params) (int64, error)
	Delete(id int64) (int64, error)
}

// KnowledgeBaseRepository struct
type KnowledgeBaseRepository struct {
	BaseRepository
}

// Add create a knowledgeBase
func (r *KnowledgeBaseRepository) Add(knowledgeBase *models.KnowledgeBase, col1 string) (bool, int64, error) {
	knowledgeBase.SubTitle = strings.Trim(knowledgeBase.SubTitle, "|")
	if knowledgeBase.SubTitle != "" {
		knowledgeBase.SubTitle = "|" + knowledgeBase.SubTitle + "|"
	}
	_bool, index, err := r.o.ReadOrCreate(knowledgeBase, col1)
	if err != nil {
		logs.Warn("Add create a Platform------------", err)
	}
	return _bool, index, err
}

// UpdateParams update knowledgeBase
func (r *KnowledgeBaseRepository) UpdateParams(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("UpdateParams update knowledgeBase------------", index, err)
	}
	return index, err
}

// GetKnowledgeBase get one KnowledgeBase
func (r *KnowledgeBaseRepository) GetKnowledgeBase(id int64) *models.KnowledgeBase {
	var base models.KnowledgeBase
	if err := r.q.Filter("id", id).One(&base); err != nil {
		logs.Warn("GetUser get one KnowledgeBase------------", err)
		return nil
	}
	base.SubTitle = strings.Trim(base.SubTitle, "|")
	return &base
}

// GetKnowledgeBases get one KnowledgeBases
func (r *KnowledgeBaseRepository) GetKnowledgeBases(request *models.PaginationData) (*models.PaginationData, error) {

	if request.PageSize < MinPageSize {
		request.PageSize = MinPageSize
	}
	if request.PageSize > MaxPageSize {
		request.PageSize = MaxPageSize
	}

	// query
	var lists []models.KnowledgeBase
	if _, err := r.q.OrderBy("-create_at").Limit(request.PageSize).Offset((request.PageOn - 1) * request.PageSize).All(&lists); err != nil {
		logs.Warn("GetKnowledgeBases get one KnowledgeBases------------", err)
		return nil, err
	}

	if request.PageSize < MinPageSize {
		request.PageSize = MinPageSize
	}
	if request.PageSize > MaxPageSize {
		request.PageSize = MaxPageSize
	}

	total, _ := r.q.Count()
	for index := range lists {
		lists[index].SubTitle = strings.Trim(lists[index].SubTitle, "|")
	}
	request.Total = total
	request.List = &lists

	return request, nil
}

// GetKnowledgeBaseWithTitle get one KnowledgeBase with title
func (r *KnowledgeBaseRepository) GetKnowledgeBaseWithTitle(title string) *models.KnowledgeBase {
	var base models.KnowledgeBase
	if err := r.q.Filter("title", title).One(&base); err != nil {
		logs.Warn("GetKnowledgeBaseWithTitle get one KnowledgeBase with title------------", err)
		return nil
	}
	base.SubTitle = strings.Trim(base.SubTitle, "|")
	return &base
}

// Delete delete a KnowledgeBase
func (r *KnowledgeBaseRepository) Delete(id int64) (int64, error) {
	index, err := r.q.Filter("id", id).Delete()
	if err != nil {
		logs.Warn("Delete delete a KnowledgeBase------------", err)
	}
	return index, err
}
