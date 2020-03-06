package models

// RemoveMessageRequestData struct
type RemoveMessageRequestData struct {
	FromAccount int64 `json:"from_account"`
	ToAccount   int64 `json:"to_account"`
	Key         int64 `json:"key"`
}
