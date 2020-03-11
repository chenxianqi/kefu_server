package configs

// Some global static configuration information can be put here

// ResponseStatusType enum type
type ResponseStatusType int

// const Response status
const (
	ResponseError    ResponseStatusType = 500
	ResponseSucess   ResponseStatusType = 200
	ResponseFail     ResponseStatusType = 400
	ResponseNotFound ResponseStatusType = 404
)
