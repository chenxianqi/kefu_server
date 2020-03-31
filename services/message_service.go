package services

import (
	"kefu_server/models"
	"strconv"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// MessageRepositoryInterface interface
type MessageRepositoryInterface interface {
	GetAdminMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error)
	GetAdminHistoryMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error)
	GetUserMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error)
	Delete(removeRequestDto models.RemoveMessageRequestDto) (int64, error)
	Add(message *models.Message) (int64, error)
	GetReadCount(uid int64) (int64, error)
	ClearRead(uid int64) (int64, error)
	DeleteWhiteMessage(uids []int) int
	MoveMessageToHistory() int64
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

// GetReadCount message read count
func (r *MessageRepository) GetReadCount(uid int64) (int64, error) {
	count, err := r.q.Filter("to_account", uid).Filter("read", 1).Count()
	if err != nil {
		logs.Warn("Add add a message------------", err)
	}
	return count, err
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

// MoveMessageToHistory move message history table
func (r *MessageRepository) MoveMessageToHistory() int64 {
	fields := "`from_account`,`to_account`,`biz_type`,`version`,`timestamp`,`sequence`,`key`,`transfer_account`,`platform`,`payload`,`read`"
	timestampMax := time.Now().Unix() - int64(60*60*24*30) // 30 day
	res, err := r.o.Raw("INSERT INTO message_history("+fields+") SELECT "+fields+" FROM message WHERE timestamp < ?", timestampMax).Exec()
	if err != nil {
		logs.Warn("MoveMessageToHistory move message history table1------------", err)
	}
	rows, _ := res.RowsAffected()
	if rows > 0 {
		r.q.Filter("timestamp__lt", timestampMax).Delete()
	}
	if err != nil {
		logs.Warn("MoveMessageToHistory move message history table2------------", err)
	}
	return rows
}

// Delete delete a message
func (r *MessageRepository) Delete(removeRequestDto models.RemoveMessageRequestDto) (int64, error) {

	res, err := r.o.Raw("DELETE FROM `message` WHERE from_account = ? AND to_account = ? AND `key` = ?", removeRequestDto.FromAccount, removeRequestDto.ToAccount, removeRequestDto.Key).Exec()
	row, _ := res.RowsAffected()
	if row == 0 {
		r.o.Raw("DELETE FROM `message_history` WHERE from_account = ? AND to_account = ? AND `key` = ?", removeRequestDto.FromAccount, removeRequestDto.ToAccount, removeRequestDto.Key).Exec()
	}
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
		_, err := r.o.Raw("SELECT * FROM `message` WHERE (`to_account` = ? OR `from_account` = ?) AND `timestamp` < ? ORDER BY `sequence` ASC	LIMIT ?,?", uid, uid, timestamp, start, end).QueryRows(&messages)
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
	return &messagePaginationDto, nil
}

// getAdminMessages
func getAdminMessages(r *MessageRepository, table string, messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error) {
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
	type MessageCount struct {
		Count int64
	}
	var messageCount MessageCount
	err = r.o.Raw("SELECT COUNT(*) AS `count` FROM `"+table+"` WHERE `timestamp` < ? AND to_account IN("+inExp+") AND  from_account IN("+inExp+")", messagePaginationDto.Timestamp, accounts, accounts).QueryRow(&messageCount)
	if err != nil {
		logs.Warn("GetMessages get one service message list1------------", err)
	}
	msgCount = messageCount.Count

	// Paging
	end := msgCount
	start := int(messageCount.Count) - messagePaginationDto.PageSize
	if start <= 0 {
		start = 0
	}

	if msgCount > 0 {
		_, err = r.o.Raw("SELECT * FROM `"+table+"` WHERE to_account IN ("+inExp+") AND from_account IN ("+inExp+") AND `timestamp` < ? ORDER BY `sequence` ASC LIMIT ?,?", accounts, accounts, messagePaginationDto.Timestamp, start, end).QueryRows(&messages)
		if err != nil {
			logs.Warn("GetMessages get one service message list2------------", err)
			return nil, err
		}
		_, err = r.q.Filter("from_account", messagePaginationDto.Account).Update(orm.Params{"read": 0})
		if err != nil {
			logs.Warn("GetMessages get one service message list3------------", err)
			return nil, err
		}
		var messageCount1 MessageCount
		r.o.Raw("SELECT COUNT(*) AS `count` FROM `"+table+"` WHERE to_account IN("+inExp+") AND  from_account IN("+inExp+")", accounts, accounts).QueryRow(&messageCount1)
		messagePaginationDto.List = messages
		messagePaginationDto.Total = messageCount1.Count
	} else {
		messagePaginationDto.List = []models.Message{}
		messagePaginationDto.Total = 0
	}
	return &messagePaginationDto, nil
}

// GetAdminHistoryMessages get admin messages history
func (r *MessageRepository) GetAdminHistoryMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error) {
	return getAdminMessages(r, "message_history", messagePaginationDto)
}

// GetAdminMessages get admin messages
func (r *MessageRepository) GetAdminMessages(messagePaginationDto models.MessagePaginationDto) (*models.MessagePaginationDto, error) {
	return getAdminMessages(r, "message", messagePaginationDto)
}
