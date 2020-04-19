import 'package:flutter/material.dart';

enum ThemeType { first, second }

class ThemeProvide with ChangeNotifier {
  // 实例
  static ThemeProvide instance;

  // 单例
  static ThemeProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = ThemeProvide();
    return instance;
  }

  //当前主题
  ThemeType themeType = ThemeType.first;

  // 第一个主题
  ThemeData _firstTheme() {
    return ThemeData(
        primaryColor: Color(0xff3e444a), // 主题色
        dividerColor: Color(0xfff3f3f3), // 描边等
        accentColor: Color(0xff999999), //  文本前景色
        indicatorColor: Color(0xff3e444a), // 选中颜色
        buttonColor: Color(0xff3e444a), // 按钮颜色
        disabledColor: Color(0xffcccccc), // 禁用颜色
        primaryColorLight: Color(0xffffffff), // 比较亮的颜色
        primaryColorDark: Color(0xff333333), // 比较暗的颜色
        scaffoldBackgroundColor: Color(0xffF3F3F3),
        backgroundColor: Color(0xffF3F3F3),
        popupMenuTheme: PopupMenuThemeData(
          color: Color(0xff3e444a)
        ),
        textTheme: TextTheme(
          // 文本主题
          title: TextStyle(
              // 标题
              color: Color(0xff333333),
              fontWeight: FontWeight.w500),
          body1: TextStyle(
              // 正文1
              color: Color(0xff666666),
              fontWeight: FontWeight.w400),
          body2: TextStyle(
              // 正文2
              color: Color(0xff999999),
              fontWeight: FontWeight.w400),
          caption: TextStyle(
            // 描述
            color: Color(0xff999999),
            fontWeight: FontWeight.w400
          ),
          display1: TextStyle(
              color: Color(0xffffffff),
              fontWeight: FontWeight.w400),
        ),
        appBarTheme: AppBarTheme(
            // 导航条主题
            color: Color(0xffffffff),
            elevation: 0.3,
            brightness: Brightness.dark
        ),
        buttonTheme: ButtonThemeData(splashColor: Color(0xfff3f3f3)));
  }

  // 第二个主题
  ThemeData _secondTheme() {
    return ThemeData(
      primaryColor: Color(0xff000000), // 主题色
      dividerColor: Color(0xfff3f3f3), // 描边等
      primaryColorLight: Color(0xfffc4919), // 比较亮的颜色
      accentColor: Colors.black54, //  文本前景色
      indicatorColor: Color(0xff0cb8fd), // 选中颜色
      buttonColor: Color(0xff0cb8fd), // 按钮颜色
      scaffoldBackgroundColor: Color(0xffF3F3F3),
      textTheme: TextTheme(
        // 文本主题
        title: TextStyle(
            // 标题
            color: Color(0xff333333),
            fontWeight: FontWeight.w400),
        body1: TextStyle(
            // 正文1
            color: Color(0xff666666),
            fontWeight: FontWeight.w500),
        body2: TextStyle(
          // 正文1
          color: Color(0xffcccccc),
          fontWeight: FontWeight.w400
        ),
        caption: TextStyle(
          // 描述
          color: Color(0xff999999),
          fontWeight: FontWeight.w400
        ),
        display1: TextStyle(
            // 用作appbar title
            color: Color(0xff333333),
            fontWeight: FontWeight.w500),
      ),
      buttonTheme: ButtonThemeData(),
      appBarTheme: AppBarTheme(
          // 导航条主题
          elevation: 0.3,
          brightness: Brightness.light),
    );
  }

  /// 获取当前主题
  ThemeData getCurrentTheme() {
    switch (themeType) {
      case ThemeType.first:
        return _firstTheme();
        break;
      case ThemeType.second:
        return _secondTheme();
        break;
      default:
        return _firstTheme();
    }
  }

  void setTheme(ThemeType themeType) {
    themeType = themeType;
    notifyListeners();
  }
  
}
