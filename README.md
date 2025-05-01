# Go React SSR Template

一个基于Go和React的服务端渲染(SSR)项目模板，提供高性能的Web应用开发框架。

## 项目简介

该项目结合了Go后端和React前端，实现了服务端渲染(SSR)功能，具有以下特点：

- 基于Go后端服务，提供高性能API和渲染服务
- 使用React前端框架，支持组件化开发
- 内置TailwindCSS支持，便于快速构建UI
- 多语言国际化支持
- 包含热重载开发环境
- Docker容器化部署支持

## 技术栈

- **后端**：Go、Gin框架
- **前端**：React、TailwindCSS
- **构建工具**：npm、air
- **其他**：Docker、Git子模块

## 开发环境搭建

### 前提条件

- 安装Node.js和npm
- 安装Go开发环境
- 安装Git

### 初始化项目

1. 克隆仓库

```bash
git clone -b ssr --recurse-submodules git@github.com:xxxx.git
```

2. 安装依赖

```bash
npm i
```

3. 安装Go热重载工具

```bash
go install github.com/air-verse/air@latest
```

## 开发流程

### 1. CSS构建与监视

启动CSS构建监视，自动编译TailwindCSS：

```bash
npm run watch:css
```

### 2. 启动开发服务器

使用air启动Go开发服务器：

```bash
air
```

### 3. 子模块管理

更新所有子模块：

```bash
git submodule update --init --recursive
```

拉取最新子模块代码：

```bash
git pull --recurse-submodules
```

### 4. 代码提交

提交子模块修改：

```bash
cd core
git add .
git commit -m "提交信息"
git push
cd ..
```

提交主项目修改：

```bash
git add .
git commit -m "提交信息"
git push
```

## 目录结构

```
├── app/              # Go应用逻辑代码
│   ├── api/          # API接口
│   └── pages/        # 页面路由和处理
├── build/            # 构建输出目录
├── cmd/              # 命令行工具
├── conf/             # 配置文件
├── core/             # 核心模块(子模块)
├── dao/              # 数据访问层
├── frontend/         # 前端代码
│   ├── app/          # React应用组件
│   ├── css/          # 样式文件
│   ├── pages/        # 前端页面组件
│   └── server/       # 服务端渲染相关代码
├── locales/          # 国际化翻译文件
└── node_modules/     # NPM依赖
```

## 部署说明

### 使用Docker部署

1. 构建Docker镜像

```bash
docker build -t go-react-ssr .
```

2. 运行容器

```bash
docker run -p 8080:8080 go-react-ssr
```

### 使用Docker Compose部署

```bash
docker-compose up -d
```

## 配置文件

项目使用YAML格式的配置文件，可参考`conf.example.yaml`创建自己的配置：

```bash
cp conf.example.yaml conf.yaml
```

## 许可证

MIT
