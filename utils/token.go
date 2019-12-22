package utils

import (
	"fmt"
	"kefu_server/models"
	"time"

	"github.com/astaxie/beego/logs"
	"github.com/dgrijalva/jwt-go"
)

// KEY ...
// DEFAULT_EXPIRE_SECONDS ...
const (
	KEY                    string = "JWT-ARY-STARK"
	DEFAULT_EXPIRE_SECONDS int    = 259200
)

// MyCustomClaims JWT -- json web token
// HEADER PAYLOAD SIGNATURE
// This struct is the PAYLOAD
type MyCustomClaims struct {
	models.Admin
	jwt.StandardClaims
}

// RefreshToken 刷新token
func RefreshToken(tokenString string) (string, error) {
	// first get previous token
	token, err := jwt.ParseWithClaims(
		tokenString, &MyCustomClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(KEY), nil
		})
	claims, ok := token.Claims.(*MyCustomClaims)
	if !ok || !token.Valid {
		return "", err
	}
	mySigningKey := []byte(KEY)
	expireAt := time.Now().Add(time.Second * time.Duration(DEFAULT_EXPIRE_SECONDS)).Unix()
	newClaims := MyCustomClaims{
		claims.Admin,
		jwt.StandardClaims{
			ExpiresAt: expireAt,
			Issuer:    claims.Admin.UserName,
			IssuedAt:  time.Now().Unix(),
		},
	}
	// generate new token with new claims
	newToken := jwt.NewWithClaims(jwt.SigningMethodHS256, newClaims)
	tokenStr, err := newToken.SignedString(mySigningKey)
	if err != nil {
		logs.Error("generate new fresh json web token failed !! error :", err)
		return "", err
	}
	return "Bearer " + tokenStr, err
}

// ValidateToken 验证token
func ValidateToken(tokenString string) error {
	token, err := jwt.ParseWithClaims(
		tokenString,
		&MyCustomClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(KEY), nil
		})

	if err != nil && !token.Valid {
		logs.Error("validate tokenString failed !!!", err)
		return err
	}
	return nil
}

// DecodeToken 解析token
func DecodeToken(token string) (map[string]interface{}, error) {
	parseAuth, err := jwt.Parse(token, func(*jwt.Token) (interface{}, error) {
		return []byte(KEY), nil
	})
	//将token中的内容存入parmMap
	claim := parseAuth.Claims.(jwt.MapClaims)
	var parmMap map[string]interface{}
	parmMap = make(map[string]interface{})
	for key, val := range claim {
		parmMap[key] = val
	}
	return parmMap, err
}

// GenerateToken 生成token
func GenerateToken(admin models.Admin) (tokenString string) {
	var expiredSeconds int
	expiredSeconds = 259200
	if expiredSeconds == 0 {
		expiredSeconds = DEFAULT_EXPIRE_SECONDS
	}
	// Create the Claims
	mySigningKey := []byte(KEY)
	expireAt := time.Now().Add(time.Second * time.Duration(expiredSeconds)).Unix()
	fmt.Println("token will be expired at ", time.Unix(expireAt, 0))
	// pass parameter to this func or not
	claims := MyCustomClaims{
		admin,
		jwt.StandardClaims{
			ExpiresAt: expireAt,
			Issuer:    admin.UserName,
			IssuedAt:  time.Now().Unix(),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenStr, err := token.SignedString(mySigningKey)
	if err != nil {
		fmt.Println("generate json web token failed !! error :", err)
	}
	return "Bearer " + tokenStr

}

// return this result to client then all later request should have header "Authorization: Bearer <token> "
func getHeaderTokenValue(tokenString string) string {
	//Authorization: Bearer <token>
	return fmt.Sprintf("Bearer %s", tokenString)
}
