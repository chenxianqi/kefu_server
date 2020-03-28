package services

import (
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
)

// UserRepositoryInterface interface
type UserRepositoryInterface interface {
	Add(admin *models.User) (int64, error)
	GetUser(id int64) *models.User
	GetUsers(usersPaginationDto *models.UsersPaginationDto) (*models.UsersPaginationDto, error)
	GetUserWithUID(uid int64) *models.User
	GetUserWithToken(token string) *models.User
	Update(id int64, params *orm.Params) (int64, error)
	Delete(id int64) (int64, error)
	GetOnlineCount() (int64, error)
	ClearWhiteUser() orm.ParamsList
	CheckUsersLoginTimeOutAndSetOffline(lastMessageUnixTimer int64) int64
}

// UserRepository struct
type UserRepository struct {
	BaseRepository
}

// GetUserRepositoryInstance get instance
func GetUserRepositoryInstance() *UserRepository {
	instance := new(UserRepository)
	instance.Init(new(models.User))
	return instance
}

// CheckUsersLoginTimeOutAndSetOffline Check if user login timeout
func (r *UserRepository) CheckUsersLoginTimeOutAndSetOffline(userOffLineUnixTimer int64) int64 {
	count, err := r.q.Filter("online__in", 1, 2).Filter("last_activity__lte", userOffLineUnixTimer).Update(orm.Params{
		"online":      0,
		"remote_addr": "",
		"token":       "",
		"is_window":   0,
	})
	if err != nil {
		logs.Warn("CheckUsersLoginTimeOutAndSetOffline  Check if user login timeout------------", err)
	}
	return count
}

// ClearWhiteUser clear white user
func (r *UserRepository) ClearWhiteUser() orm.ParamsList {
	var lists orm.ParamsList
	_, _ = r.o.Raw("SELECT id FROM `user` WHERE `is_service` = 0 AND `is_workorder` = 0").ValuesFlat(&lists)
	_, err := r.q.Filter("is_service", 0).Filter("is_workorder", 0).Delete()
	if err != nil {
		logs.Warn("ClearWhiteUser clear white user------------", err)
	}
	return lists
}

// Add create a user
func (r *UserRepository) Add(user *models.User) (int64, error) {
	id, err := r.o.Insert(user)
	if err != nil {
		logs.Warn("Add create a user------------", err)
	}
	return id, err
}

// GetUser get one User
func (r *UserRepository) GetUser(id int64) *models.User {
	var user models.User
	if err := r.q.Filter("id", id).One(&user); err != nil {
		logs.Warn("GetUser get one User------------", err)
		return nil
	}
	return &user
}

// GetOnlineCount online user count
func (r *UserRepository) GetOnlineCount() (int64, error) {
	rows, err := r.q.Filter("online", 1).Count()
	if err != nil {
		logs.Warn("GetOnlineCount online user count------------", err)
	}
	return rows, err
}

// GetUsers get Users
func (r *UserRepository) GetUsers(usersPaginationDto *models.UsersPaginationDto) (*models.UsersPaginationDto, error) {
	// orm instance
	qs := r.q
	cond := orm.NewCondition()
	var cond1 *orm.Condition
	var cond2 *orm.Condition
	if usersPaginationDto.Keyword != "" {
		cond1 = cond.Or("nickname__icontains", usersPaginationDto.Keyword).Or("phone__icontains", usersPaginationDto.Keyword).Or("remarks__icontains", usersPaginationDto.Keyword)
	}

	// exist platfrom id?
	if usersPaginationDto.Platform != 0 && usersPaginationDto.Platform != 1 {
		cond2 = cond.And("platform", usersPaginationDto.Platform)
	}
	// exist platfrom date?
	if usersPaginationDto.DateStart != "" && usersPaginationDto.DateEnd != "" {
		layoutDate := "2006-01-02 15:04:05"
		loc, _ := time.LoadLocation("Local")
		dateStartString := usersPaginationDto.DateStart + " 00:00:00"
		dateEndString := usersPaginationDto.DateEnd + " 23:59:59"
		dateStart, _ := time.ParseInLocation(layoutDate, dateStartString, loc)
		dateEnd, _ := time.ParseInLocation(layoutDate, dateEndString, loc)
		cond2 = cond2.And("create_at__gte", dateStart.Unix()).And("create_at__lte", dateEnd.Unix())
	}

	// query
	var lists []models.User
	cond3 := cond.AndCond(cond2).OrCond(cond1)
	qs = qs.SetCond(cond3)
	qs = qs.OrderBy("-online", "-create_at").Limit(usersPaginationDto.PageSize)
	if _, err := qs.Offset((usersPaginationDto.PageOn - 1) * usersPaginationDto.PageSize).All(&lists); err != nil {
		return nil, err
	}
	total, _ := qs.Count()
	usersPaginationDto.Total = total
	usersPaginationDto.List = &lists
	return usersPaginationDto, nil
}

// GetUserWithUID get one User with uid
func (r *UserRepository) GetUserWithUID(uid int64) *models.User {
	var user models.User
	if err := r.q.Filter("uid", uid).One(&user); err != nil {
		logs.Warn("GetUserWithUID get one User with uid------------", err)
		return nil
	}
	return &user
}

// GetUserWithToken get one User with uid
func (r *UserRepository) GetUserWithToken(token string) *models.User {
	var user models.User
	if err := r.q.Filter("token", token).One(&user); err != nil {
		logs.Warn("GetUserWithToken get one User with uid------------", err)
		return nil
	}
	return &user
}

// Update user
func (r *UserRepository) Update(id int64, params orm.Params) (int64, error) {
	index, err := r.q.Filter("id", id).Update(params)
	if err != nil {
		logs.Warn("Update user------------", err)
	}
	return index, err
}

// Delete user
func (r *UserRepository) Delete(id int64) (int64, error) {
	index, err := r.q.Filter("id", id).Delete()
	if err != nil {
		logs.Warn("Delete user------------", err)
	}
	return index, err
}
