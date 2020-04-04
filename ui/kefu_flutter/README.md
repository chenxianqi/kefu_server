
客服系统开发者QQ交流群： 623661658

# 欢迎使用本客服系统 - kefu_flutter


![客服系统](http://qiniu.cmp520.com/flutter_kefu.jpg)


## 本项目关联GIT项目资源连接
- **[服务端][1]** 
- **[客服端-APP工作台][7]**      客服端APP工作台flutter源码
- **[客服端-网页工作台][2]** 
- **[客户端H5][3]**
- **[客户端Flutter][4]**
- **[Flutter-mimc][6]**

**本系统** 是基于小米消息云实现的一款简单实用的面向多终端的客服系统，本系统简单易用，易扩展，易整合现有的业务系统，无缝对接自有业务。


## 项目的依赖其他库
如果您也是用了以下库，存在版本冲突，可以尝试修改
``` dart
    flutter_mimc: ^1.0.1
    dio: ^3.0.8
    image_picker: ^0.6.2+3
    shared_preferences: ^0.5.6
    provider: ^4.0.1
    flutter_advanced_networkimage: ^0.6.2
  
```

## Android 你应该添加的权限
```xml
 <uses-permission android:name="android.permission.INTERNET"/>
 <uses-permission android:name="android.permission.CAMERA" />
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />​
    
```

## IOS 你应该添加的权限
```xml
 <key>NSCameraUsageDescription</key>
 <key>NSPhotoLibraryUsageDescription</key>
    
```

## EXAMPLE AND INSTALL

- **[下载Android体验][5]**

dependencies:
  kefu_flutter: $lastVersion

import 'package:kefu_flutter/kefu_flutter.dart';

``` dart

KeFuStore _keFu;

@override
void initState() {
    
    // 获得实例并监听数据动态 (1)
    // 单列 获取对象
    /// 配置信息
    /// mImcTokenData 不为空，即优先使用 mImcTokenData
    /// [apiHost] 客服后台API地址
    /// [mImcAppID]     mimc AppID
    /// [mImcAppKey]    mimc AppKey
    /// [mImcAppSecret] mimc AppSecret
    /// [mImcTokenData] mimc TokenData 服务端生成
    /// [userId]        业务平台ID(扩展使用)
    /// [autoLogin]     是否自动登录
    /// [delayTime]     延迟登录，默认1500毫秒，以免未实例化完成就调用登录
    _keFu = KeFuStore.getInstance(
        debug: true,
        autoLogin: true,
        host: "http://kf.aissz.com:666/v1",
        appID: "",
        appKey: "",
        appSecret: ""
    );

    /// 获得实例并监听数据动态 (2)
    _keFu.addListener(() async{
        await Future.delayed(Duration(milliseconds: 200));
        debugPrint("_keFu对象变动");
        _keFu = KeFuStore.instance;
        if(mounted) setState(() {});
    });

    /// 或者设置不自动登录，自己手动登录
    /// _keFu.loginIm()

    super.initState();

}

/// 获得客服页面视图
_keFu.view();

/// 然后记得销毁
@override
void dispose() {
    _keFu?.dispose();
    super.dispose();
}


  
``` 

  [1]: https://github.com/chenxianqi/kefu_server
  [2]: https://github.com/chenxianqi/kefu_admin
  [3]: https://github.com/chenxianqi/kefu_client
  [4]: https://github.com/chenxianqi/kefu_flutter
  [5]: http://kf.aissz.com:666/static/app/app-release.apk
  [6]: https://github.com/chenxianqi/flutter_mimc
  [7]: https://github.com/chenxianqi/kefu_workbench