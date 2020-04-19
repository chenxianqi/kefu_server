import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  LoginPage({this.arguments});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginProvide loginProvide;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      loginProvide = LoginProvide();
      var prefs = GlobalProvide.getInstance().prefs;
      String account = prefs.getString("account");
      String host = prefs.getString("host");
      loginProvide.hostCtr = TextEditingController(text: host);
      loginProvide.accountCtr = TextEditingController(text: account);
      String password = prefs.getString("password");
      if (password != null) {
        loginProvide.setIsSavePassword(true);
      }
      loginProvide.passwordCtr = TextEditingController(text: password ?? "");
      setState(() {});
    }
  }

  @override
  void dispose() {
    loginProvide?.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return ChangeNotifierProvider<LoginProvide>.value(
        value: loginProvide,
        child: Builder(
          builder: (context) {
            return PageContext(builder: (context) {
              GlobalProvide.getInstance().setRooContext(context);
              ThemeData themeData = Theme.of(context);
              LoginProvide loginState = Provider.of<LoginProvide>(context);
              return Scaffold(
                backgroundColor: themeData.primaryColor,
                appBar: customAppBar(
                    isShowLeading: false,
                    leading: "",
                    title: Text(
                      "用户登录",
                      style: themeData.textTheme.display1,
                    )),
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(60)),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: ToPx.size(100)),
                              child: Icon(
                                IconData(0xe674, fontFamily: 'IconFont'),
                                color: Colors.white,
                                size: ToPx.size(150),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: ToPx.size(100)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ToPx.size(20)),
                              height: ToPx.size(90),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ToPx.size(10)))),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.link,
                                    color: Colors.grey[400],
                                    size: ToPx.size(35),
                                  ),
                                  Expanded(
                                    child: Input(
                                      key: Key("hostCtr"),
                                      controller: loginState.hostCtr,
                                      padding:
                                          EdgeInsets.only(left: ToPx.size(20)),
                                      border: Border.all(
                                          width: 0.0,
                                          color: Colors.transparent),
                                      placeholder: "请输服务器地址~",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: ToPx.size(20)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ToPx.size(20)),
                              height: ToPx.size(90),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ToPx.size(10)))),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    IconData(0xe60d, fontFamily: 'IconFont'),
                                    color: Colors.grey[400],
                                    size: ToPx.size(35),
                                  ),
                                  Expanded(
                                    child: Input(
                                      key: Key("accountCtr"),
                                      controller: loginState.accountCtr,
                                      padding:
                                          EdgeInsets.only(left: ToPx.size(20)),
                                      border: Border.all(
                                          width: 0.0,
                                          color: Colors.transparent),
                                      placeholder: "请输入客服账号~",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: ToPx.size(20)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ToPx.size(20)),
                              height: ToPx.size(90),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ToPx.size(10)))),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    IconData(0xe62a, fontFamily: 'IconFont'),
                                    color: Colors.grey[400],
                                    size: ToPx.size(35),
                                  ),
                                  Expanded(
                                    child: Input(
                                      key: Key("passwordCtr"),
                                      obscureText: true,
                                      controller: loginState.passwordCtr,
                                      padding:
                                          EdgeInsets.only(left: ToPx.size(20)),
                                      border: Border.all(
                                          width: 0.0,
                                          color: Colors.transparent),
                                      placeholder: "请输入密码~",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: ToPx.size(10)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "保存登录密码",
                                    style: themeData.textTheme.caption,
                                  ),
                                  Platform.isAndroid
                                      ? Switch(
                                          value: loginState.isSavePassword,
                                          onChanged: (bool isSwitch) {
                                            loginState
                                                .setIsSavePassword(isSwitch);
                                          },
                                          activeColor: Colors.black)
                                      : Transform.scale(
                                          scale: .7,
                                          child: CupertinoSwitch(
                                              value: loginState.isSavePassword,
                                              onChanged: (bool isSwitch) {
                                                loginState.setIsSavePassword(
                                                    isSwitch);
                                              },
                                              activeColor: Colors.black)),
                                ],
                              ),
                            ),
                            Button(
                              withAlpha: 230,
                              margin: EdgeInsets.only(top: ToPx.size(80)),
                              height: ToPx.size(90),
                              color: Colors.black,
                              onPressed: () => loginState.login(context),
                              child: Text("登录"),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
          },
        ));
  }
}
