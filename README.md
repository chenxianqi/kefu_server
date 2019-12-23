# 欢迎使用本客服系统

![客服系统](http://qiniu.cmp520.com/kefuxitonh.jpg)

**本系统** 是基于小米消息云实现的一款简单实用的面向多终端的客服系统，本系统简单易用，易扩展，易整合现有的业务系统，无缝对接自有业务。

**[小米消息云][7]（MIMC）** 是小米自研的一种安全、可靠、易用的分布式IM云服务。为广大开发者提供免费快捷的即时通讯接入服务

## 当前客服系统支持功能
- 支持多客服坐席
- 支持实时预览用户的输入内容
- 支持知识库，可按终端平台设置相应的知识库
- 支持多机器人协同工作，可设置多个的机器人处理不同平台的知识库
- 支持消息撤回
- 支持快捷回复语设置
- 支持客户输入文本后对知识库的检索，以便提供可能需要提问的问题
- 支持查看服务记录，可按日期某个客服，都服务了哪些客户，和服务聊天记录
- 支持七牛云与自带上传功能的切换
- 支持统计各个平台的服务量
- 支持统计各个客服人员的服务量
- 支持实时查看各个平台当天独立用户访问量
- 支持用户管理
- 支持客服管理

## 本项目关联GIT项目资源连接
- **[客服端-工作台][10]**         客服端工作台，支持WEB，或使用Electron打包成二进制安装包
- **[客户端-移动端H5][11]**       万能的H5支持嵌入任何webview使用
- **[客户端-Flutter版][12]**     Flutter版客户端，可打包提供给原生应用使用
- **[插件-Flutter-Mimc][13]**   本插件是对小米消息云Android和IOS的一个flutter版移植

## 未来将考虑实现
- 客服端工作台APP的实现（已进入开发阶段）
- 微信小程序版客户端 （待定）
- 支付宝小程序版客户端（待定）

## 体验客服系统
客服端工作台网页版：[马上体验][1]

MAC版下载：[马上体验][3]

Windows版下载：[马上体验][4]

客户端 H5网页版：[马上体验][2]

Example PC网页版：[马上体验][5]

### 客服测试账号
| 账号      |    密码 |
| :-------- | --------: |
| test1  | qwe123456 |
| test2  | qwe123456 |
| test3  | qwe123456 |
| test4  | qwe123456 |
| test5  | qwe123456 |

> **Note:** 目前仅提供5组客服账号供喜欢本系统的小伙伴测试，如需深度测试与管理员权限，建议亲自搭建测试，每个测试账号的登录周期30分钟，每30分钟系统会统一清退测试账号



## 如何使用本系统
##### 1.GO环境变量配置
GO 》》》》》 [移步去GO官网][8]
##### 2.clone 本项目到 $GOPATH/src 目录下
    cd $GOPATH/src && git clone https://github.com/chenxianqi/kefu_server
##### 3.安装依赖库
安装 beego框架 [移步去beego官网][9]

    * go get github.com/astaxie/beego
    * go get github.com/beego/bee

安装 MIMC GO sdk [移步去MIMC官网][7]

    * go get github.com/Xiaomi-mimc/mimc-go-sdk
    * cd $GOPATH/src/github.com/Xiaomi-mimc/mimc-go-sdk
    * go build
    * go install 

安装 protobuf

    * go get github.com/golang/protobuf/proto
    * cd $GOPATH/src/github.com/golang/protobuf/proto
    * go build
    * go install

安装 其他依赖库

    * go get github.com/astaxie/beego/cache
    * go get -u github.com/qiniu/api.v7

##### 4.去小米开发平台申请APPID 
GO 》》》》》 [小米开放平台][6]

##### 5.配置文件产考 kefu_server/conf/app.conf
``` go
    appname = kefu_server
    runmode = "dev"
    httpport = 8080
    copyrequestbody = true
    viewspath = "public"

    # 使用本地存储时使用的地址
    static_host = "http://localhost:8080/static/uploads/images"

    # 小米mimc open api URL
    mimc_HttpUrl = "https://mimc.chat.xiaomi.net/api/account/token"

    [dev]
    httpaddr = "localhost"
    # 小米mimc配置信息(小米开放平台创建)
    mimc_appId = 
    mimc_appKey = ""
    mimc_appSecret = ""
    # IM数据库信息
    im_alias_name = "default"
    im_driver_name= "mysql"
    im_mysql_host = "localhost"
    im_mysql_user = "root"
    im_mysql_db   = "kefu_server"
    im_mysql_pwd  = "keith"

```
> **Note:** 根据beego的配置文件配置，填写从小米开放平台获得的appId，appKey, appSecret， 以及您的数据库连接，账号，密码


##### 7.创建一个数据库,导入初始数据
    登录上面配置的数据库，创建一个名为kefu_server的数据库，将[kefu_server/kefu_server.sql]初始数据，导入即可

##### 8.运行项目
    bee run


##### 9.打包发布
    bee pack -be GOOS=linux

> **静态资源目录:** 
    本项目默认配置已打开静态资源目录，PC工作台与H5可直接打包放进相应的目录使用，也可以独立开设站点使用
    本项目demo直接使用内置静态资源目录、
    public/admin  工作台
    public/client 客户端


  [1]: http://kf.aissz.com:666/admin/ 
  [2]: http://kf.aissz.com:666
  [3]: http://kf.aissz.com:666/static/app/mac-0.0.1.dmg
  [4]: http://kf.aissz.com:666/static/app/win-0.0.1.exe
  [5]: http://kf.aissz.com:666/example/
  [6]: https://dev.mi.com/console/appservice/mimc.html
  [7]: https://admin.mimc.chat.xiaomi.net/docs/
  [8]: https://golang.org/
  [9]: https://beego.me/
  [10]: https://github.com/chenxianqi/kefu_admin
  [11]: https://github.com/chenxianqi/kefu_client
  [12]: https://github.com/chenxianqi/kefu_flutter
  [13]: https://github.com/chenxianqi/flutter_mimc


