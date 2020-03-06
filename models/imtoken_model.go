package models

// IMToken struct
type IMToken struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    IMTokenData `json:"data"`
}

// IMTokenData struct
type IMTokenData struct {
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
