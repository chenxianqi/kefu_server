import 'package:flutter/material.dart';

/// 根据设计稿的设备尺寸适配size
class ToPx {
  static ToPx _instance;

  ToPx({
    this.width = 750,
    this.height = 1334,
    this.allowFontScaling = false,
  });

  int width;
  int height;
  bool allowFontScaling;
  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;
  static double _bottomBarHeight;
  static double _textScaleFactor;

  static ToPx get instance => getInstance();

  static ToPx getInstance() {
    if (_instance == null) {
      _instance = ToPx();
    }
    return _instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;

  static double get textScaleFactory => _textScaleFactor;

  static double get pixelRatio => _pixelRatio;

  static double get screenWidthDp => _screenWidth;

  static double get screenHeightDp => _screenHeight;

  static double get screenWidth => _screenWidth * _pixelRatio;

  static double get screenHeight => _screenHeight * _pixelRatio;

  static double get statusBarHeight => _statusBarHeight * _pixelRatio;

  static double get bottomBarHeight => _bottomBarHeight * _pixelRatio;

  get scaleWidth => _screenWidth / instance.width;

  get scaleHeight => _screenHeight / instance.height;

  static double size(int width) => width * instance.scaleWidth;
}
