客服系统开发者QQ交流群： 623661658

# 欢迎使用本客服系统 - 客户端H5

![客服系统](http://qiniu.cmp520.com/kefuxitonh.jpg)

## 本项目关联GIT项目资源连接
- **[服务端][1]** 
- **[客服端-APP工作台][6]**      客服端APP工作台flutter源码
- **[客服端-网页工作台][2]** 
- **[客户端H5][3]**
- **[客户端Flutter][4]**

**本系统** 是基于小米消息云实现的一款简单实用的面向多终端的客服系统，本系统简单易用，易扩展，易整合现有的业务系统，无缝对接自有业务。

## 安装与打包
```
    npm install
    npm run serve
    npm run build
    npm run test
    npm run lint
```


## 连接管控关键字
    通过连接控制页面的样式以及一些基本配置
``` html
    // url query 介绍
    // h == header  0 不显示 1显示 默认值显示，PC端不显示
    // m == mobile  0 不是移动端 1是移动端
    // p == platform  平台ID（渠道）
    // r == robot   0 当前为为客服 1机器人（对应的账号为a）
    // a == account 当前提供对话服务的账号，即客服账号，或机器人
    // u == userAccount  会话用户账号
    // uid == userId  业务平台的ID
    // c = 1          清除本地缓存
```

## mini_im.js 工具
GO》》》》》[Example][5]

    mini_im 工具是帮助其在PC端以及其他小程序，创建IM账户连接提供的相关函数，具体使用见example目录demo



### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

### TypeError: Cannot destructure property `createHash` of 'undefined' or 'null'.
npm add webpack@latest  OK




  [1]: https://github.com/chenxianqi/kefu_server
  [2]: https://github.com/chenxianqi/kefu_admin
  [3]: https://github.com/chenxianqi/kefu_client
  [4]: https://github.com/chenxianqi/kefu_flutter
  [5]: http://kf.aissz.com:666/example/
  [6]: https://github.com/chenxianqi/kefu_workbench
