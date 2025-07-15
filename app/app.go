package app

import (
	"net/http"
	"time"

	"shipnow/app/api"
	"shipnow/app/pages"

	"github.com/daodao97/goreact/base/login"
	"github.com/daodao97/goreact/conf"
	"github.com/daodao97/goreact/i18n"
	"github.com/gin-contrib/gzip"
	"github.com/gin-gonic/gin"
	"github.com/kataras/sitemap"
)

func LoadApp(r *gin.Engine) {
	app := r.Group("")
	app.Use(gzip.Gzip(gzip.DefaultCompression))
	app.Use(i18n.I18nMiddleware())

	pages.SetupRouter(app)
	login.SetupRouter(app)
	api.SetupRouter(app)

	if conf.Get().GoogleAdsTxt != "" {
		app.GET("/ads.txt", func(c *gin.Context) {
			c.String(http.StatusOK, conf.Get().GoogleAdsTxt)
		})
	}

	app.GET("/robots.txt", func(c *gin.Context) {
		c.String(http.StatusOK, "User-agent: *\nAllow: /\nDisallow: /assets\nDisallow: /static\n")
	})
	app.GET("/sitemap.xml", func(c *gin.Context) {
		sm := sitemap.New("https://go-react-ssr.com")
		sm.URL(sitemap.URL{
			Loc:        "/",
			LastMod:    time.Now(),
			ChangeFreq: sitemap.Daily,
		})
		c.XML(http.StatusOK, sm.Build()[0])
	})

	r.NoRoute(func(c *gin.Context) {
		c.HTML(http.StatusNotFound, "index.html:NotFound.js", nil)
	})
}
