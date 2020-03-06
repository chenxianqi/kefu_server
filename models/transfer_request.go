package models

// TransferRequestData struct
type TransferRequestData struct {
	ToAccount   int64 `json:"to_account"`   // 转接给谁
	UserAccount int64 `json:"user_account"` // 用户ID
}
