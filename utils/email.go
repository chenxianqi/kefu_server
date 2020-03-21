package utils

import (
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"gopkg.in/gomail.v2"
)

// SendMail send email
func SendMail(mailTo []string, subject string, body string) {
	mailConn := map[string]string{
		"user": beego.AppConfig.String("email_user"),
		"pass": beego.AppConfig.String("email_pass"),
		"host": beego.AppConfig.String("email_host"),
		"port": beego.AppConfig.String("email_port"),
	}
	port, _ := strconv.Atoi(mailConn["port"])
	m := gomail.NewMessage()
	m.SetHeader("From", m.FormatAddress(mailConn["user"], beego.AppConfig.String("email_name")))
	m.SetHeader("To", mailTo...)
	m.SetHeader("Subject", subject)
	m.SetBody("text/html", body)

	d := gomail.NewDialer(mailConn["host"], port, mailConn["user"], mailConn["pass"])
	err := d.DialAndSend(m)
	if err != nil {
		logs.Error("SendMail send email error------------", err)
	}
	logs.Info("SendMail send email success------------", mailTo)

}
