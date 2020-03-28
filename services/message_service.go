package services

import (
	"encoding/base64"
	"kefu_server/models"
	"strconv"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// MessageRepositoryInterface interface
type MessageRepositoryInterface interface {
	GetAdminMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error)
	GetUserMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error)
	Delete(removeRequestDto models.RemoveMessageRequestDto) (int64, error)
	Add(message *models.Message) (int64, error)
	GetReadCount(uid int64) (int64, error)
	ClearRead(uid int64) (int64, error)
	DeleteWhiteMessage(uids []int) int
	Cancel(fromAccount int64, toAccount int64, key int64) error
}

// MessageRepository struct
type MessageRepository struct {
	BaseRepository
}

// GetMessageRepositoryInstance get instance
func GetMessageRepositoryInstance() *MessageRepository {
	instance := new(MessageRepository)
	instance.Init(new(models.Message))
	return instance
}

// DeleteWhiteMessage delete white user
func (r *MessageRepository) DeleteWhiteMessage(uids orm.ParamsList) int {
	_, err := r.q.Filter("from_account__in", uids).Delete()
	if err != nil {
		logs.Warn("DeleteWhiteMessage delete white user------------", err)
	}
	_, err = r.q.Filter("to_account__in", uids).Delete()
	if err != nil {
		logs.Warn("DeleteWhiteMessage delete white user1------------", err)
	}
	return len(uids)
}

// Add add a message
func (r *MessageRepository) Add(message *models.Message) (int64, error) {
	row, err := r.o.Insert(message)
	if err != nil {
		logs.Warn("Add add a message------------", err)
	}
	return row, err
}

// ClearRead Clear message read
func (r *MessageRepository) ClearRead(uid int64) (int64, error) {
	index, err := r.q.Filter("to_account", uid).Update(orm.Params{
		"Read": 0,
	})
	if err != nil {
		logs.Warn("ClearRead Clear message read------------", err)
	}
	return index, err
}

// GetReadCount message read count
func (r *MessageRepository) GetReadCount(uid int64) (int64, error) {
	count, err := r.q.Filter("to_account", uid).Filter("read", 1).Count()
	if err != nil {
		logs.Warn("Add add a message------------", err)
	}
	return count, err
}

// Delete delete a message
func (r *MessageRepository) Delete(removeRequestDto models.RemoveMessageRequestDto) (int64, error) {
	res, err := r.o.Raw("DELETE FROM `message` WHERE from_account = ? AND to_account = ? AND `key` = ?", removeRequestDto.FromAccount, removeRequestDto.ToAccount, removeRequestDto.Key).Exec()
	row, _ := res.RowsAffected()
	if err != nil {
		logs.Warn("Delete delete a message------------", err)
		return 0, err
	}
	return row, nil
}

// GetUserMessages get user messages
func (r *MessageRepository) GetUserMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error) {
	// join string
	var messages []*models.Message
	uid := strconv.FormatInt(messagePaginationDto.Account, 10)
	timestamp := strconv.FormatInt(messagePaginationDto.Timestamp, 10)
	type MessageCount struct {
		Count int64
	}
	var messageCount MessageCount
	err := r.o.Raw("SELECT COUNT(*) AS `count` FROM `message` WHERE (`to_account` = ? OR `from_account` = ?) AND `timestamp` < ? ", uid, uid, timestamp).QueryRow(&messageCount)
	if err != nil {
		logs.Warn("GetUserMessages get user messages0------------", err)
		return nil, err
	}
	if messagePaginationDto.PageSize == 0 {
		messagePaginationDto.PageSize = 20
	}
	var end = messageCount.Count
	start := int(messageCount.Count) - messagePaginationDto.PageSize
	if start <= 0 {
		start = 0
	}
	if messageCount.Count > 0 {
		_, err := r.o.Raw("SELECT * FROM `message` WHERE (`to_account` = ? OR `from_account` = ?) AND `timestamp` < ? ORDER BY `timestamp` ASC	LIMIT ?,?", uid, uid, timestamp, start, end).QueryRows(&messages)
		if err != nil {
			logs.Warn("GetUserMessages get user messages1------------", err)
			return nil, err
		}
		_, _ = r.q.Filter("from_account", uid).Update(orm.Params{"read": 0})
		if err != nil {
			logs.Warn("GetUserMessages get user messages2------------", err)
			return nil, err
		}
		r.o.Raw("SELECT COUNT(*) AS `count` FROM `message` WHERE (`to_account` = ? OR `from_account` = ?) ", uid, uid).QueryRow(&messageCount)
		messagePaginationDto.List = messages
		messagePaginationDto.Total = messageCount.Count
	} else {
		messagePaginationDto.List = []models.Message{}
		messagePaginationDto.Total = 0
	}
	for index, msg := range messages {
		payload, _ := base64.StdEncoding.DecodeString(msg.Payload)
		messages[index].Payload = string(payload)
	}
	return &messagePaginationDto, nil
}

// GetAdminMessages get admin messages
func (r *MessageRepository) GetAdminMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error) {

	var err error
	var msgCount int64
	var messages []*models.Message

	// join string
	accounts := []int64{messagePaginationDto.Account, messagePaginationDto.Service}
	inExp := "?,?"

	// get all robot
	robotRepository := GetRobotRepositoryInstance()
	robots, err := robotRepository.GetRobots()
	if err != nil {
		logs.Warn("GetMessages get one service message list0------------", err)
	}
	for _, robot := range robots {
		accounts = append(accounts, robot.ID)
		inExp = inExp + ",?"
	}

	msgCount, err = r.q.Filter("timestamp__lt", messagePaginationDto.Timestamp).Filter("to_account__in", accounts).Filter("from_account__in", accounts).Count()
	if err != nil {
		logs.Warn("GetMessages get one service message list1------------", err)
	}

	// Paging
	end := msgCount
	start := int(msgCount) - messagePaginationDto.PageSize
	if start <= 0 {
		start = 0
	}

	if msgCount > 0 {
		_, err = r.o.Raw("SELECT * FROM `message` WHERE to_account IN ("+inExp+") AND from_account IN ("+inExp+") AND `timestamp` < ? ORDER BY `timestamp` ASC LIMIT ?,?", accounts, accounts, messagePaginationDto.Timestamp, start, end).QueryRows(&messages)
		if err != nil {
			logs.Warn("GetMessages get one service message list2------------", err)
			return nil, err
		}
		_, err = r.q.Filter("from_account", messagePaginationDto.Account).Update(orm.Params{"read": 0})
		if err != nil {
			logs.Warn("GetMessages get one service message list3------------", err)
			return nil, err
		}
		total, _ := r.q.Filter("to_account__in", accounts).Filter("from_account__in", accounts).Count()
		messagePaginationDto.List = messages
		messagePaginationDto.Total = total
	} else {
		messagePaginationDto.List = []models.Message{}
		messagePaginationDto.Total = 0
	}
	for index, msg := range messages {
		payload, _ := base64.StdEncoding.DecodeString(msg.Payload)
		messages[index].Payload = string(payload)
	}
	return &messagePaginationDto, nil
}
