import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kefu_flutter/kefu_flutter.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(0, 0, 0, 0.0)));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '在线客服',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter 在线客服 DEMO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  KeFuStore _keFu;

  void _action() {
    Navigator.push(context, CupertinoPageRoute(builder: (ctx){
      return _keFu.view();
    }));
  }

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
          host: "http://kf.aissz.com:666/api",
          appID: "2882303761518282099",
          appKey: "5521828290099",
          appSecret: "516JCA60FdP9bHQUdpXK+Q=="
      );

      // 获得实例并监听数据动态 (2)
      _keFu.addListener(() async{
          await Future.delayed(Duration(milliseconds: 200));
          debugPrint("_keFu对象变动");
          _keFu = KeFuStore.instance;
          if(mounted) setState(() {});
      });


    super.initState();

  }


  @override
  void dispose() {
    _keFu?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black
                ),
                children: [
                  TextSpan(text: "用户id: ${_keFu.imUser?.id ?? 0}   "),
                  TextSpan(text: "${_keFu.messageReadCount}", style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600
                  )),
                  TextSpan(text: "条未读消息"),
                ]
              ),
            ),
            Text(
              '欢迎使用在线客服',
            ),
            RaisedButton(
                color: themeData.primaryColor,
                child: Text("联系客服", style: TextStyle(color: Colors.white),), onPressed: () => _action()
            )
          ],
        ),
      ),
    );
  }
}
