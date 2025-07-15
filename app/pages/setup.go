package pages

import (
	"github.com/daodao97/goreact/base"
	"github.com/daodao97/goreact/i18n"
	"github.com/gin-gonic/gin"
)

func SetupRouter(app *gin.RouterGroup) {
	registerMultiLangRoutes(app, func(group *gin.RouterGroup) {
		group.GET("", IndexPage)
		group.GET("/terms", base.TermsOfService)
		group.GET("/privacy", base.Privacy)
	})
}

func registerMultiLangRoutes(app *gin.RouterGroup, registerRoutes func(group *gin.RouterGroup)) {
	groups := append([]string{""}, i18n.SupportedLanguages...)

	for _, lang := range groups {
		group := app.Group("/" + lang)
		registerRoutes(group)
	}
}
