import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class CachedImage extends StatelessWidget {
  CachedImage(
      {@required this.src,
      this.width = 100.0,
      this.height = 100.0,
      this.fit = BoxFit.contain,
      this.bgColor,
      this.radius});
  final String src;
  final double width;
  final double height;
  final BoxFit fit;
  final Color bgColor;
  final BorderRadius radius;

  // 是否是本地资源
  bool get isLocal =>
      src != null && !src.contains(RegExp(r'^(http://|https://)'));

  @override
  Widget build(BuildContext context) {
    if (src == null || src.isEmpty)
      return Container(
        width: width,
        height: height,
        color: bgColor == null ? Color.fromRGBO(0, 0, 0, 0.1) : bgColor,
      );
    try {
      return ClipRRect(
        borderRadius:
            radius != null ? radius : BorderRadius.all(Radius.circular(3.0)),
        child: Container(
            width: width,
            height: height,
            color: bgColor == null ? Color.fromRGBO(0, 0, 0, 0.05) : bgColor,
            child: src == null
                ? SizedBox()
                : SizedBox(
                    width: width,
                    height: height,
                    child: isLocal
                        ? Image.file(
                            File(src),
                            width: width,
                            height: height,
                            fit: fit,
                          )
                        : TransitionToImage(
                            image: AdvancedNetworkImage(
                              src,
                              useDiskCache: true,
                              cacheRule:
                                  CacheRule(maxAge: const Duration(days: 30)),
                            ),
                            loadingWidgetBuilder: (_, double progress, __) =>
                                Center(
                                    child: Platform.isAndroid
                                        ? SizedBox(
                                            width: 15.0,
                                            height: 15.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ))
                                        : CupertinoActivityIndicator()),
                            fit: fit,
                            placeholder: Icon(
                              Icons.photo,
                              color: Colors.grey.withAlpha(100),
                            ),
                            width: width,
                            height: height,
                            enableRefresh: true,
                          ))),
      );
    } catch (_) {
      return Container(
        color: Colors.grey.withAlpha(10),
        child: Center(
          child: Text(
            "图片已损坏\r\n或已删除",
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
