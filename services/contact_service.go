package services

import (
	"encoding/base64"
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// ContactRepositoryInterface interface
type ContactRepositoryInterface interface {
	GetContact(id int64) *models.Contact
	GetContacts(uid int64) ([]models.ContactDto, error)
	UpdateIsSessionEnd(usersID []int64, isSessionEnd int) (int64, error)
	Update(id int64, params *orm.Params) (int64, error)
	Delete(id int64, uid int64) (int64, error)
	DeleteAll(uid int64) (int64, error)
	Add(contact *models.Contact) (int64, error)
	GetContactWithIds(ids ...int64) (*models.Contact, error)
}

// ContactRepository struct
type ContactRepository struct {
	BaseRepository
}

// GetContactRepositoryInstance get instance
func GetContactRepositoryInstance() *ContactRepository {
	instance := new(ContactRepository)
	instance.Init(new(models.Contact))
	return instance
}

// Add add a Contact
func (r *ContactRepository) Add(contact *models.Contact) (int64, error) {
	row, err := r.o.Insert(contact)
	if err != nil {
		logs.Warn("Add add a Contact------------", err)
	}
	return row, err
}

// GetContact get one Contact
func (r *ContactRepository) GetContact(id int64) *models.Contact {
	var contact models.Contact
	if err := r.q.Filter("id", id).One(&contact); err != nil {
		logs.Warn("Contact get one Contact------------", err)
		return nil
	}
	return &contact
}

// GetContactWithIds get one Contact with ids
func (r *ContactRepository) GetContactWithIds(ids ...int64) (*models.Contact, error) {
	var contact models.Contact
	err := r.q.Filter("from_account__in", ids).Filter("to_account__in", ids).One(&contact)
	if err != nil {
		logs.Warn("GetContactWithIds get one Contact with ids------------", err)
	}
	return &contact, err
}

// UpdateIsSessionEnd update
func (r *ContactRepository) UpdateIsSessionEnd(usersID []int64, isSessionEnd int) (int64, error) {
	res, err := r.o.Raw("UPDATE contact SET is_session_end = 1 WHERE to_account IN(?,?) AND from_account IN(?,?)", usersID, usersID).Exec()
	rows, _ := res.RowsAffected()
	if err != nil {
		logs.Warn(" UpdateIsSessionEnd update------------", err)
		return 0, err
	}
	return rows, nil
}

// GetContacts get Contacts
func (r *ContactRepository) GetContacts(uid int64) ([]models.ContactDto, error) {
	var contactDto []models.ContactDto
	_, err := r.o.Raw("SELECT c.id AS cid,c.to_account,c.is_session_end, c.last_message,c.last_message_type,c.from_account, c.create_at AS contact_create_at,u.*, IFNULL(m.`count`,0) AS `read` FROM  `contact` c LEFT JOIN `user` u ON c.from_account = u.id LEFT JOIN (SELECT to_account,from_account, COUNT(*) as `count` FROM message WHERE `read` = 1 GROUP BY to_account,from_account) m ON m.to_account = c.to_account AND m.from_account = c.from_account WHERE c.to_account = ? AND c.delete = 0 ORDER BY c.create_at DESC", uid).QueryRows(&contactDto)
	if err != nil {
		logs.Warn("GetContacts get Contacts------------", err)
		return nil, err
	}
	// content base 64 decode
	for index, contact := range contactDto {
		payload, _ := base64.StdEncoding.DecodeString(contact.LastMessage)
		contactDto[index].LastMessage = string(payload)
	}
	return contactDto, nil
}

// Delete delete a Contact
func (r *ContactRepository) Delete(id int64, uid int64) (int64, error) {
	res, err := r.o.Raw("UPDATE `contact` SET `delete` = 1 WHERE id = ? AND to_account = ?", id, uid).Exec()
	rows, _ := res.RowsAffected()
	if err != nil {
		logs.Warn("GetContacts get Contacts err------------", err)
	}
	return rows, err

}

// DeleteAll delete all Contact
func (r *ContactRepository) DeleteAll(uid int64) (int64, error) {
	res, err := r.o.Raw("UPDATE `contact` SET `delete` = 1 WHERE to_account = ?", uid).Exec()
	rows, _ := res.RowsAffected()
	if err != nil {
		logs.Warn("DeleteAll delete all Contact error------------", err)
	}
	return rows, err

}

// Update contact
func (r *ContactRepository) Update(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update contact------------", err)
	}
	return index, err
}
