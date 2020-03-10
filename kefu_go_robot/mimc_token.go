package robotlbrary

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/astaxie/beego"
)

// TokenHandler ...
type TokenHandler struct {
	httpURL    string
	AppID      int64  `json:"appId"`
	AppKey     string `json:"appKey"`
	AppSecret  string `json:"appSecret"`
	AppAccount string `json:"appAccount"`
}

// GetMiMcToken ...
func GetMiMcToken(accountID string) (string, error) {
	tokenHandler := new(TokenHandler)
	tokenHandler.httpURL = beego.AppConfig.String("mimc_HttpUrl")
	tokenHandler.AppID, _ = beego.AppConfig.Int64("mimc_appId")
	tokenHandler.AppKey = beego.AppConfig.String("mimc_appKey")
	tokenHandler.AppSecret = beego.AppConfig.String("mimc_appSecret")
	tokenHandler.AppAccount = accountID
	jsonBytes, err := json.Marshal(*tokenHandler)
	if err != nil {
		return "", err
	}
	requestJSONBody := bytes.NewBuffer(jsonBytes).String()
	request, err := http.Post(tokenHandler.httpURL, "application/json", strings.NewReader(requestJSONBody))
	if err != nil {
		return "", err
	}
	defer request.Body.Close()
	body, err := ioutil.ReadAll(request.Body)
	if err != nil {
		return "", err
	}
	token := string(body)
	return token, nil
}
