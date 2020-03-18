package models

// TransferDto struct
type TransferDto struct {
	ToAccount   int64 `json:"to_account"`   // 转接给谁
	UserAccount int64 `json:"user_account"` // 用户ID
}
