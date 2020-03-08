package models

// IMTokenDto struct
type IMTokenDto struct {
	Code    int            `json:"code"`
	Message string         `json:"message"`
	Data    IMTokenDataDto `json:"data"`
}

// IMTokenDataDto struct
type IMTokenDataDto struct {
	AppID             string `json:"appId"`
	AppPackage        string `json:"appPackage"`
	AppAccount        string `json:"appAccount"`
	MiChid            int64  `json:"miChid"`
	MiUserID          string `json:"miUserId"`
	MiUserSecurityKey string `json:"miUserSecurityKey"`
	Token             string `json:"token"`
	RegionBucket      int64  `json:"regionBucket"`
	FeDomainName      string `json:"feDomainName"`
	RelayDomainName   string `json:"relayDomainName"`
}
