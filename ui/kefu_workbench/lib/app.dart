import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kefu_workbench/resources/localizations.dart';
import 'package:kefu_workbench/routes.dart';
import 'package:provider/provider.dart';

import 'core_flutter.dart';
import 'provider/global.dart';
import 'provider/home.dart';

Widget createApp() {
  return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: GlobalProvide.getInstance()),
        ChangeNotifierProvider.value(value: HomeProvide.getInstance()),
      ],
      child: _MyApp()
  );
}
class _MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<_MyApp>  with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    GlobalProvide.getInstance().setAppLifecycleState(state);
  }


  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvide>(builder: (context, globalState, ___){
      return MaterialApp(
        title: Configs.APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: globalState.getCurrentTheme,
        home: Builder(builder: (context) {
          ToPx().init(context);
          GlobalProvide.getInstance().setRooContext(context);
          return Routers.buildPage("/home", arguments: {"data": "not arguments"});
        }),
        onGenerateRoute: (RouteSettings settings) {
          // 是否是全屏modal
          bool fullscreenDialog = false;

          // 是否有动画
          bool isAnimate = true;

          // 判断是否是全屏Modal
          if (settings.arguments != null) {
            var isModal = (settings.arguments as Map)['modal'] ?? false;
            isAnimate = (settings.arguments as Map)['isAnimate'] ?? true;
            fullscreenDialog = (isModal == 'true' ? true : isModal) ?? false;
          }
          if (isAnimate) {
            return CupertinoPageRoute<Object>(
                fullscreenDialog: fullscreenDialog,
                builder: (BuildContext context) {
                  return Routers.buildPage(settings.name,
                      arguments: settings.arguments);
                });
          } else {
            return PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 0),
                pageBuilder: (BuildContext context, __, _) {
                  return Routers.buildPage(settings.name,
                      arguments: settings.arguments);
                });
          }
        },
        localizationsDelegates: [
          ChineseCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: <Locale>[
          const Locale('zh', 'CH'),
          const Locale('en', 'US')
        ],
      );
      
    });
    
  }
}
