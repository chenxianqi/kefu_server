package services

import (
	"github.com/astaxie/beego/orm"
)

// const val
var (
	MinPageSize = 1
	MaxPageSize = 50
)

// BaseRepository struct
// o is orm Object
// q is orm QuerySeter Object
type BaseRepository struct {
	q orm.QuerySeter
	o orm.Ormer
}

// Init BaseRepository
// Subsets must pass specific models join
func (r *BaseRepository) Init(ptrStructOrTableName interface{}) {
	var o = orm.NewOrm()
	var querySeter = o.QueryTable(ptrStructOrTableName)
	r.o = o
	r.q = querySeter
}
