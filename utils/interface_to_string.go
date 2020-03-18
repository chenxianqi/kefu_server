package utils

import (
	"encoding/base64"
	"encoding/json"
	"strings"

	"github.com/astaxie/beego/logs"
)

// InterfaceToString to string
func InterfaceToString(data interface{}) string {
	byteData, err := json.Marshal(data)
	if err != nil {
		logs.Info("InterfaceToString to string error == ", err)
		return ""
	}
	return base64.StdEncoding.EncodeToString(byteData)
}

// StringToInterface to Interface
func StringToInterface(s string, v interface{}) error {
	byteData, err := base64.StdEncoding.DecodeString(strings.Replace(s, "\"", "", -1))
	if err != nil {
		logs.Info("StringToInterface to Interface error == ", err)
		return err
	}
	json.Unmarshal(byteData, &v)
	return nil
}
