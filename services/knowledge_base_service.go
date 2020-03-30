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
	GetKnowledgeBases(request models.KnowledgePaginationDto) (*models.KnowledgePaginationDto, error)
	GetKnowledgeBaseWithTitle(title string) *models.KnowledgeBase
	Add(knowledgeBase *models.KnowledgeBase, col1 string) (bool, int64, error)
	Update(id int64, params *orm.Params) (int64, error)
	Delete(id int64) (int64, error)
	SearchKnowledgeTitles(request models.KnowledgeBaseTitleRequestDto) []models.KnowledgeBaseTitleDto
	GetKnowledgeBaseWithTitleAndPlatform(title string, platform int64) *models.KnowledgeBase
	GetKnowledgeBasePlatformsTotal() []orm.Params
}

// KnowledgeBaseRepository struct
type KnowledgeBaseRepository struct {
	BaseRepository
}

// GetKnowledgeBaseRepositoryInstance get instance
func GetKnowledgeBaseRepositoryInstance() *KnowledgeBaseRepository {
	instance := new(KnowledgeBaseRepository)
	instance.Init(new(models.KnowledgeBase))
	return instance
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

// SearchKnowledgeTitles Search Knowledge Titles
// payload = "key1"
// keyWords = "key1|key2|key3"
func (r *KnowledgeBaseRepository) SearchKnowledgeTitles(request models.KnowledgeBaseTitleRequestDto) []models.KnowledgeBaseTitleDto {
	if request.Payload == "" {
		return []models.KnowledgeBaseTitleDto{}
	}
	var knowledgeBaseTitleDto []models.KnowledgeBaseTitleDto
	subTitle := ""
	fields := "title"
	if request.IsSerachSub {
		fields = "title,sub_title"
	}
	roobtKeyWords := strings.Split(strings.Trim(request.KeyWords, "|"), "|")
	if request.KeyWords == "" {
		subTitle := ""
		for _, value := range roobtKeyWords {
			if strings.Contains(value, request.Payload) {
				subTitle += subTitle + " sub_title LIKE \"%" + value + "%\" OR "
			}
		}
	}
	if request.IsSerachSub && request.KeyWords != "" {
		for _, value := range roobtKeyWords {
			subTitle += " sub_title LIKE \"%" + value + "%\" OR "
		}
	}
	subTitle += " sub_title LIKE \"%" + request.Payload + "%\" "
	_, err := r.o.Raw("SELECT "+fields+" FROM knowledge_base WHERE ( "+subTitle+" ) AND platform IN (?,?) ORDER by rand() limit ?", 1, request.Platform, request.Limit).QueryRows(&knowledgeBaseTitleDto)
	if err != nil {
		logs.Warn("Search Knowledge Titles------------", err)
		return []models.KnowledgeBaseTitleDto{}
	}
	return knowledgeBaseTitleDto

}

// Update knowledgeBase
func (r *KnowledgeBaseRepository) Update(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update knowledgeBase------------", index, err)
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
func (r *KnowledgeBaseRepository) GetKnowledgeBases(request *models.KnowledgePaginationDto) (*models.KnowledgePaginationDto, error) {

	if request.PageSize < MinPageSize {
		request.PageSize = MinPageSize
	}
	if request.PageSize > MaxPageSize {
		request.PageSize = MaxPageSize
	}

	// query
	var lists []models.KnowledgeBase
	like := " "
	k := request.Keyword
	if k != "" {
		like = ("sub_title LIKE '%" + k + "%' OR title LIKE '%" + k + "%' OR content LIKE '%" + k + "%' AND")
	}
	_, err := r.o.Raw("SELECT * FROM knowledge_base WHERE "+like+" `platform` = ? ORDER BY create_at DESC LIMIT ? OFFSET ?", request.Platform, request.PageSize, (request.PageOn-1)*request.PageSize).QueryRows(&lists)
	if err != nil {
		logs.Warn("GetKnowledgeBases get one KnowledgeBases------------", err)
		return nil, err
	}

	if request.PageSize < MinPageSize {
		request.PageSize = MinPageSize
	}
	if request.PageSize > MaxPageSize {
		request.PageSize = MaxPageSize
	}

	for index := range lists {
		lists[index].SubTitle = strings.Trim(lists[index].SubTitle, "|")
	}
	type KnowledgeBaseCount struct {
		Count int64
	}
	var knowledgeBaseCount KnowledgeBaseCount
	r.o.Raw("SELECT COUNT(*) AS `count` FROM knowledge_base WHERE "+like+" `platform` = ?", request.Platform).QueryRow(&knowledgeBaseCount)

	request.Total = knowledgeBaseCount.Count
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

// GetKnowledgeBaseWithTitleAndPlatform get one KnowledgeBase with title and platform
func (r *KnowledgeBaseRepository) GetKnowledgeBaseWithTitleAndPlatform(title string, platform int64) *models.KnowledgeBase {
	var knowledge models.KnowledgeBase
	if err := r.q.Filter("title", title).Filter("platform__in", 1, platform).One(&knowledge); err != nil {
		logs.Warn("GetKnowledgeBaseWithTitle get one KnowledgeBase with title------------", err)
		return nil
	}
	knowledge.SubTitle = strings.Trim(knowledge.SubTitle, "|")
	return &knowledge
}

// Delete delete a KnowledgeBase
func (r *KnowledgeBaseRepository) Delete(id int64) (int64, error) {
	index, err := r.q.Filter("id", id).Delete()
	if err != nil {
		logs.Warn("Delete delete a KnowledgeBase------------", err)
	}
	return index, err
}

// GetKnowledgeBasePlatformsTotal get Group count
func (r *KnowledgeBaseRepository) GetKnowledgeBasePlatformsTotal() []orm.Params {
	var maps []orm.Params
	_, err := r.o.Raw("SELECT P.id,p.title,IFNULL(k.count,0) as count FROM platform p LEFT JOIN (SELECT  platform,COUNT(*) AS count FROM `knowledge_base` GROUP BY platform) k ON k.platform = p.id").Values(&maps)
	if err != nil {
		logs.Warn("GetKnowledgeBasePlatformsTotal get Group count------------", err)
		return []orm.Params{}
	}
	return maps
}
