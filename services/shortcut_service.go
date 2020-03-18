package services

import (
	"encoding/base64"
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// ShortcutRepositoryInterface interface
type ShortcutRepositoryInterface interface {
	Add(admin *models.Shortcut, col1 string, cols ...string) (bool, int64, error)
	GetShortcut(id int64) *models.Shortcut
	GetShortcuts(uid int64) []models.Shortcut
	Update(id int64, params *orm.Params) (int64, error)
	Delete(id int64, uid int64) (int64, error)
}

// ShortcutRepository struct
type ShortcutRepository struct {
	BaseRepository
}

// GetShortcutRepositoryInstance get instance
func GetShortcutRepositoryInstance() *ShortcutRepository {
	instance := new(ShortcutRepository)
	instance.Init(new(models.Shortcut))
	return instance
}

// Add create a shortcut
func (r *ShortcutRepository) Add(shortcut *models.Shortcut, col1 string, cols ...string) (bool, int64, error) {
	shortcut.Title = base64.StdEncoding.EncodeToString([]byte(shortcut.Title))
	shortcut.Content = base64.StdEncoding.EncodeToString([]byte(shortcut.Content))
	shortcut.CreateAt = time.Now().Unix()
	_bool, id, err := r.o.ReadOrCreate(shortcut, col1, cols...)
	if err != nil {
		logs.Warn("Add create a shortcut------------", err)
	}
	return _bool, id, err
}

// GetShortcuts get user shortcut List
func (r *ShortcutRepository) GetShortcuts(uid int64) []models.Shortcut {
	var shortcuts []models.Shortcut
	if _, err := r.q.Filter("uid", uid).OrderBy("-create_at").All(&shortcuts); err != nil {
		logs.Warn("GetShortcuts get user shortcut List------------", err)
		return []models.Shortcut{}
	}
	// base 64转换回来
	for index, shortcut := range shortcuts {
		title, _ := base64.StdEncoding.DecodeString(shortcut.Title)
		content, _ := base64.StdEncoding.DecodeString(shortcut.Content)
		shortcuts[index].Title = string(title)
		shortcuts[index].Content = string(content)
	}
	return shortcuts
}

// Delete delete a shortcut
func (r *ShortcutRepository) Delete(id int64, uid int64) (int64, error) {
	index, err := r.q.Filter("id", id).Filter("uid", uid).Delete()
	if err != nil {
		logs.Warn("Delete delete a shortcut------------", err)
	}
	return index, err
}

// GetShortcut get one Shortcut
func (r *ShortcutRepository) GetShortcut(id int64) *models.Shortcut {
	var shortcut models.Shortcut
	if err := r.q.Filter("id", id).One(&shortcut); err != nil {
		logs.Warn("GetShortcut get one shortcut------------", err)
		return nil
	}
	title, _ := base64.StdEncoding.DecodeString(shortcut.Title)
	content, _ := base64.StdEncoding.DecodeString(shortcut.Content)
	shortcut.Title = string(title)
	shortcut.Content = string(content)
	return &shortcut
}

// Update shortcut
func (r *ShortcutRepository) Update(id int64, params orm.Params) (int64, error) {
	params["Title"] = base64.StdEncoding.EncodeToString([]byte(params["Title"].(string)))
	params["Content"] = base64.StdEncoding.EncodeToString([]byte(params["Content"].(string)))
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update shortcut------------", err)
	}
	return index, err
}
