客服系统开发者QQ交流群： 623661658

# 开源客服系统 v2.0.0
该项目的机器人仓库地址： [机器人仓库地址>>>][18]

## 以下是v2.0.0版本的重要更新
- 对前面版本进行重构，分离业务逻辑与机器人的混搭运行弊端
- 做了大量优化，在很大程度上提升了性能，并代码松耦合，
- 业务系统支持负载均衡了，这是对v1.0的重大里程碑更新, 对接海量客户不再愁了
- 增加工单系统能力，无在线客服接待？不用怕，工单来给您解决一切问题
- 代码可读性大大提高，初学者都能看懂的代码，还有什么理由不学习一下呢
- 定时清理无接入人工记录的用户，避免数据沉淀
- H5客户端增加了重连机制
- 客户端只保留30天聊天记录，已分表处理

本项目目前是基于[小米消息云][7]实现的一款简单实用的面向多终端的客服系统，支持H5，PC，桌面，小程序，APP，flutter, 所有源码开源，长期维护，快速接入，易扩展，易整合现有的业务，开箱即用，无缝对接。

## 目录文件结构说明
|       |     |
| :-------- | :-------- |
| - conf  | 项目配置文件 |
| - configs  | 项目静态信息配置 |
| - controllers  | 控制器集合 |
| - db  | 数据库配置 |
| - filters | 过滤器 |
| - grpcs | RPC 用于与机器人客户端交互 |
| - models | 数据模型 |
| - public | 项目静态资源，客户端，服务端 H5 |
| - routers | 路由配置 |
| - services | 数据服务提供者 |
| - static | 静态资源，用于上传存储 |
| - task | 任务调度器 |
| - ui | 包含客服系统的所有UI项目 |
| - kefu_server.postman_collection.json | Postman 文档 |
| - kefu_server.sql | 初始化安装数据 |
| - processguard_server.sh | Linux 进程守护shell脚本 |

## 支持功能
- 内置工单系统
- 支持多客服坐席
- 支持客服多终端同时在线
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

## 关联资源地址
- **[客服端-工作台][10]**         客服端工作台，支持WEB，或使用Electron打包成二进制安装包
- **[客服端-APP工作台][16]**      客服端APP工作台flutter源码
- **[客户端-移动端H5][11]**       万能的H5支持嵌入任何webview使用
- **[客户端-Flutter版][12]**     Flutter版客户端，可打包提供给原生应用使用
- **[插件-Flutter-Mimc][13]**   本插件是对小米消息云Android和IOS的一个flutter版移植

## 未来将考虑实现更多的功能
- 服务评分           （落实）
- 微信内置客服对接    （待定）
- 微信小程序版客户端  （待定）
- 支付宝小程序版客户端（待定）

## 体验客服系统

| 客服端      |    下载 |
| :-------- | --------: |
| 网页版  | [马上体验][1] |
| MAC版  | [下载体验][3] |
| Linux64  | [下载体验][14] |
| Windows  | [下载体验][4] |
| Android | [下载体验][17] |
| IOS | 请自行编译 |


| 客户端      |    下载 |
| :-------- | --------: |
| Example  | [马上体验][15] |
| H5  | [下载体验][2] |
| Android  | [下载体验][15] |
| Windows  | [下载体验][4] |
| Android | [下载体验][17] |
| IOS | 请自行编译 |

#### 客服测试账号
| 账号      |    密码 |
| :-------- | --------: |
| test1  | qwe123456 |
| test2  | qwe123456 |
| test3  | qwe123456 |
| test4  | qwe123456 |
| test5  | qwe123456 |

> **Note:** 目前仅提供5组客服账号供喜欢本系统的小伙伴测试，如需深度测试与管理员权限，建议亲自搭建测试



## 安装
##### 1.GO环境变量配置  [Golan官网][8]
- cd $GOPATH/src && git clone https://github.com/chenxianqi/kefu_server
- cd kefu_server && go get

##### 2.安装 protobuf （可选，不修改rpc源码的话暂时不用安装）
- cd protoc-3.6.1-osx-x86_64
- cp -r include/ /usr/local/include/
- cp -r bin/ /usr/local/bin/

##### 3.修改配置文件 kefu_server/conf/app.conf
- 去小米开放平台申请小米APPID信息(appId，appKey, appSecret) [小米开放平台][6]
- 将申请的小米配置到app.conf
- 配置数据库配置信息
- RPC 端口 如：8013
- 配置其它信息（具体查看app.conf）

##### 4.导入初始化数据
- 在项目根目录找到 kefu_server.sql，导入刚刚配置的数据库

##### 5.启动项目
bee run


## 打包发布 linux (其它运行环境编译请自行search baidu)
    bee pack -be GOOS=linux  OR   CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go
- bee pack -be GOOS=linux 命令会把所有的资源的打包成一个tar.gz文件，建议第一次安装使用该命令，打包后你需要删除一些没必要的目录文件，后续更新按需更新即可
- CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go 仅仅编译项目可执行文件

- 打包好后即可上传到服务器，执行 cd $current->project && nohub ./processguard_server.sh &

> **静态资源目录:** 
    本项目默认配置已打开静态资源目录，也可以独立开设站点运行
    public/admin  工作台
    public/client 客户端
	
## 截图预览
![客服系统](http://qiniu.cmp520.com/kefuxitonh.jpg)


## LICENSE

Copyright 2019 keith

Licensed to the Apache Software Foundation (ASF) under one or more contributor
license agreements.  See the NOTICE file distributed with this work for
additional information regarding copyright ownership.  The ASF licenses this
file to you under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.



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
  [14]: http://kf.aissz.com:666/static/app/linux-0.0.1.AppImage
  [15]: http://kf.aissz.com:666/static/app/app-release.apk
  [16]: https://github.com/chenxianqi/kefu_workbench
  [17]: http://kf.aissz.com:666/static/app/kefu_workbench.apk
  [18]: https://github.com/chenxianqi/kefu_go_robot


