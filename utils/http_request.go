package utils

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/astaxie/beego/logs"
)

var userAgentList = []string{"Mozilla/5.0 (compatible, MSIE 10.0, Windows NT, DigExt)",
	"Mozilla/4.0 (compatible, MSIE 7.0, Windows NT 5.1, 360SE)",
	"Mozilla/4.0 (compatible, MSIE 8.0, Windows NT 6.0, Trident/4.0)",
	"Mozilla/5.0 (compatible, MSIE 9.0, Windows NT 6.1, Trident/5.0,",
	"Opera/9.80 (Windows NT 6.1, U, en) Presto/2.8.131 Version/11.11",
	"Mozilla/4.0 (compatible, MSIE 7.0, Windows NT 5.1, TencentTraveler 4.0)",
	"Mozilla/5.0 (Windows, U, Windows NT 6.1, en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
	"Mozilla/5.0 (Macintosh, Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
	"Mozilla/5.0 (Macintosh, U, Intel Mac OS X 10_6_8, en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
	"Mozilla/5.0 (Linux, U, Android 3.0, en-us, Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13",
	"Mozilla/5.0 (iPad, U, CPU OS 4_3_3 like Mac OS X, en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
	"Mozilla/4.0 (compatible, MSIE 7.0, Windows NT 5.1, Trident/4.0, SE 2.X MetaSr 1.0, SE 2.X MetaSr 1.0, .NET CLR 2.0.50727, SE 2.X MetaSr 1.0)",
	"Mozilla/5.0 (iPhone, U, CPU iPhone OS 4_3_3 like Mac OS X, en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
	"MQQBrowser/26 Mozilla/5.0 (Linux, U, Android 2.3.7, zh-cn, MB200 Build/GRJ22, CyanogenMod-7) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"}

// GetRandomUserAgent ...
func GetRandomUserAgent() string {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return userAgentList[r.Intn(len(userAgentList))]
}

// HTTPResponse struct
type HTTPResponse struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

// HTTPRequest ...
// url  访问的链接
// method post, get 等
// data  body 数据
// token 授权token
func HTTPRequest(path string, method string, data interface{}, token string) *HTTPResponse {
	client := &http.Client{}
	response := new(HTTPResponse)
	bodyJSON, err := json.Marshal(data)
	if err != nil {
		log.Println(err)
		response.Code = 400
		response.Message = "json error"
		return response
	}
	req, err := http.NewRequest(method, path, bytes.NewBuffer(bodyJSON))
	if err != nil {
		response.Code = 500
		response.Message = "链接错误"
		logs.Error(err)
	}
	req.Header.Add("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
	req.Header.Add("Accept-Language", "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3")
	req.Header.Add("Connection", "keep-alive")
	req.Header.Add("User-Agent", GetRandomUserAgent())
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Access-Control-Max-Age", "2592000")
	req.Header.Set("Authorization", token)
	req.Header.Set("usertype", "cmp_app")
	resp, err := client.Do(req)
	response.Code = resp.StatusCode
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		response.Code = 400
		response.Message = "请求错误"
		return response
	}
	if resp.StatusCode != 200 {
		response.Code = 400
		response.Message = "请求错误"
		return response
	}
	json.Unmarshal(body, response)
	// response.Data = string(body)
	return response
}
