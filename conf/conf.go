package conf

import (
	"github.com/daodao97/goreact/base/login"
	core_conf "github.com/daodao97/goreact/conf"
	"github.com/daodao97/goreact/util/mail"
	"github.com/daodao97/xgo/xapp"
	"github.com/daodao97/xgo/xdb"
	"github.com/daodao97/xgo/xlog"
	"github.com/daodao97/xgo/xredis"
)

var (
	GitTag string
)

type Conf struct {
	Database       []xdb.Config     `json:"database" yaml:"database" envPrefix:"DATABASE"`
	Redis          []xredis.Options `json:"redis" yaml:"redis" envPrefix:"REDIS"`
	SendGrid       SendGridConfig   `json:"sendgrid" yaml:"sendgrid"`
	core_conf.Conf `yaml:"core"`
}

type SendGridConfig struct {
	APIKey string `json:"api_key" yaml:"api_key" envPrefix:"SENDGRID"`
}

var ConfInstance *Conf

func Init() error {
	ConfInstance = &Conf{}

	err := xapp.InitConf(ConfInstance)
	if err != nil {
		return err
	}

	ConfInstance.GitTag = GitTag

	xlog.Debug("GitTag", xlog.Any("GitTag", GitTag))

	sender := mail.NewSendGridMailSender(ConfInstance.SendGrid.APIKey)

	mail.SetMailSender(sender)

	login.SetVerificationCodeMailSender(&login.CodeSender{
		MailSender:       sender,
		From:             "noreply@shipnow.com",
		Subject:          "ShipNow - 注册验证码",
		PlainTextContent: "您好，邮箱验证码为: %s\n验证码10分钟有效期。如非本人操作，请忽略本邮件",
	})
	core_conf.SetConf(&ConfInstance.Conf)

	return nil
}

func Get() *Conf {
	return ConfInstance
}
