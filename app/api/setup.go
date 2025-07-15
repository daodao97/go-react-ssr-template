package api

import (
	"github.com/daodao97/goreact/auth"
	"github.com/gin-gonic/gin"
)

func SetupRouter(app *gin.RouterGroup) {
	api := app.Group("/api")
	api.Use(auth.AuthMiddleware())
}
