package main

import (
	"net/http"
	"os"
	"strings"

	"shipnow/app"
	"shipnow/conf"
	"shipnow/dao"

	"github.com/daodao97/goreact/i18n"
	"github.com/daodao97/goreact/server"
	"github.com/daodao97/xgo/xapp"
	"github.com/daodao97/xgo/xredis"
)

func init() {
	buildEnvironmentJS("build")
	// if os.Getenv("APP_ENV") != "dev" {
	// 	xlog.SetLogger(xlog.StdoutJson(xlog.WithLevel(slog.LevelDebug)))
	// }
}

func main() {
	app := xapp.NewApp().
		AddStartup(i18n.InitI18n, conf.Init, func() error {
			return xredis.Inits(conf.Get().Redis)
		}, dao.Init).
		AddServer(xapp.NewHttp(xapp.Args.Bind, h))

	if err := app.Run(); err != nil {
		panic(err)
	}
}

func h() http.Handler {
	r := server.Gin()
	app.LoadApp(r)
	return r
}

func buildEnvironmentJS(folder string) error {
	var environment = "if (!window.env) { window.env = {} } \n"
	for _, e := range os.Environ() {
		if strings.Contains(e, "REACT_APP_") {
			pair := strings.SplitN(e, "=", 2)
			environment = environment + "window.env." + pair[0] + "='" + pair[1] + "';"
		}
	}

	return os.WriteFile(folder+"/environment.js", []byte(environment), 0644)
}
