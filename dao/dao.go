package dao

import (
	"shipnow/conf"

	coreDao "github.com/daodao97/goreact/dao"

	"github.com/daodao97/xgo/xdb"
	_ "github.com/go-sql-driver/mysql"
)

func Init() error {
	err := xdb.Inits(conf.Get().Database)
	if err != nil {
		return err
	}

	coreDao.Init()

	return nil
}
