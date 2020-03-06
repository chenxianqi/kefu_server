package services

import (
	"encoding/base64"
	"kefu_server/models"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// MessageRepositoryInterface interface
type MessageRepositoryInterface interface {
	GetMessages(serviceID int64, messagePaginationData models.MessagePaginationData) (*models.MessagePaginationData, error)
	Delete(removeRequestData models.RemoveMessageRequestData) (int64, error)
	Add(message *models.Message) (int64, error)
}

// MessageRepository struct
type MessageRepository struct {
	BaseRepository
}

// Add add a message
func (r *MessageRepository) Add(message *models.Message) (int64, error) {
	row, err := r.o.Insert(&message)
	if err != nil {
		logs.Warn("Add add a message------------", err)
	}
	return row, err
}

// Delete delete a message
func (r *MessageRepository) Delete(removeRequestData models.RemoveMessageRequestData) (int64, error) {
	res, err := r.o.Raw("UPDATE message SET `delete` = 1 WHERE from_account = ? AND to_account = ? AND `key` = ?", removeRequestData.FromAccount, removeRequestData.ToAccount, removeRequestData.Key).Exec()
	row, _ := res.RowsAffected()
	if err != nil {
		return 0, err
	}
	return row, nil
}

// GetMessages get one service message list
func (r *MessageRepository) GetMessages(serviceID int64, messagePaginationData models.MessagePaginationData) (*models.MessagePaginationData, error) {

	var err error
	var msgCount int64
	var messages []*models.Message

	// join string
	accounts := []int64{messagePaginationData.Account, serviceID}
	inExp := "?,?"

	// get all robot
	robotRepository := new(RobotRepository)
	robotRepository.Init(new(models.Robot))
	robots, err := robotRepository.GetRobots()
	if err != nil {
		logs.Warn("GetMessages get one service message list0------------", err)
	}
	for _, robot := range robots {
		accounts = append(accounts, robot.ID)
		inExp = inExp + ",?"
	}

	msgCount, err = r.q.Filter("timestamp__lt", messagePaginationData.Timestamp).Filter("to_account__in", accounts).Filter("from_account__in", accounts).Filter("delete", 0).Count()
	if err != nil {
		logs.Warn("GetMessages get one service message list1------------", err)
	}

	// Paging
	end := msgCount
	start := int(msgCount) - messagePaginationData.PageSize
	if start <= 0 {
		start = 0
	}

	if msgCount > 0 {
		_, err = r.o.Raw("SELECT * FROM `message` WHERE to_account IN ("+inExp+") AND `delete` = 0 AND from_account IN ("+inExp+") AND `timestamp` < ? ORDER BY `timestamp` ASC LIMIT ?,?", accounts, accounts, messagePaginationData.Timestamp, start, end).QueryRows(&messages)
		if err != nil {
			logs.Warn("GetMessages get one service message list2------------", err)
			return nil, err
		}
		_, err = r.q.Filter("from_account", messagePaginationData.Account).Update(orm.Params{"read": 0})
		if err != nil {
			logs.Warn("GetMessages get one service message list3------------", err)
			return nil, err
		}
		total, _ := r.q.Filter("to_account__in", accounts).Filter("from_account__in", accounts).Filter("delete", 0).Count()
		messagePaginationData.List = messages
		messagePaginationData.Total = total
	} else {
		messagePaginationData.List = []models.Message{}
		messagePaginationData.Total = 0
	}
	for index, msg := range messages {
		payload, _ := base64.StdEncoding.DecodeString(msg.Payload)
		messages[index].Payload = string(payload)
	}
	return &messagePaginationData, nil
}
