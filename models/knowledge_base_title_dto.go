package models

// KnowledgeBaseTitleDto struct
type KnowledgeBaseTitleDto struct {
	Title string `json:"title"`
}

// KnowledgeBaseTitleRequestDto struct
type KnowledgeBaseTitleRequestDto struct {
	Payload     string `json:"payload"`
	KeyWords    string `json:"keyWords"`
	IsSerachSub bool   `json:"isSerachSub"`
	Platform    int64  `json:"platform"`
	Limit       int64  `json:"limit"`
}
