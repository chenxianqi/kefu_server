package robotlbrary

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/astaxie/beego"
)

// NewTokenHandler ...
func NewTokenHandler(appAccount string) *TokenHandler {
	tokenHandler := new(TokenHandler)
	tokenHandler.httpURL = beego.AppConfig.String("mimc_HttpUrl")
	tokenHandler.AppID, _ = beego.AppConfig.Int64("mimc_appId")
	tokenHandler.AppKey = beego.AppConfig.String("mimc_appKey")
	tokenHandler.AppSecret = beego.AppConfig.String("mimc_appSecret")
	tokenHandler.AppAccount = appAccount
	return tokenHandler
}

// FetchToken ...
func (c *TokenHandler) FetchToken() *string {
	jsonBytes, err := json.Marshal(*c)
	if err != nil {
		return nil
	}
	requestJSONBodygo := bytes.NewBuffer(jsonBytes).String()
	request, err := http.Post(c.httpURL, "application/json", strings.NewReader(requestJSONBodygo))
	if err != nil {
		return nil
	}
	defer request.Body.Close()
	body, err := ioutil.ReadAll(request.Body)
	if err != nil {
		return nil
	}
	token := string(body)
	return &token
}
