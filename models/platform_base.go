package models

// Platform struct
type Platform struct {
	ID     int64  `orm:"auto;pk;type(bigint);column(id)" json:"id"`    // ID
	Title  string `orm:"unique;type(char);column(title)" json:"title"` // 平台名称
	Alias  string `orm:"unique;type(char);column(alias)" json:"alias"` //  平台别名
	System int    `orm:"default(0);column(system)" json:"system"`      // 是否是系统设定
}

// System seting
//INSERT INTO `kefu_server`.`platform`(`id`, `title`, `alias`, `system`) VALUES (0, '全平台', 'all', 1);
//INSERT INTO `kefu_server`.`platform`(`id`, `title`, `alias`, `system`) VALUES (1, 'IOS', 'ios', 1);
//INSERT INTO `kefu_server`.`platform`(`id`, `title`, `alias`, `system`) VALUES (2, '小程序', 'small', 1);
//INSERT INTO `kefu_server`.`platform`(`id`, `title`, `alias`, `system`) VALUES (3, 'PC网页', 'pc', 1);
//INSERT INTO `kefu_server`.`platform`(`id`, `title`, `alias`, `system`) VALUES (4, '移动网页', 'mobile', 1);
//INSERT INTO `kefu_server`.`platform`(`id`, `title`, `alias`, `system`) VALUES (5, 'Android', 'android', 1);
