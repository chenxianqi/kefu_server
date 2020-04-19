import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../core_flutter.dart';
class CachedNetworkImage extends StatelessWidget{
  CachedNetworkImage({@required this.src, this.width = 100.0, this.height = 100.0, this.fit = BoxFit.contain, this.bgColor, this.radius, this.color});
  final String src;
  final double width;
  final double height;
  final BoxFit fit;
  final Color bgColor;
  final Color color;
  final BorderRadius radius;

  // 是否是本地资源
  bool get isLocal => src != null && src != "" && !src.contains(RegExp(r'^(http://|https://)'));

  @override
  Widget build(BuildContext context) {
    // if(src == null || src.isEmpty) return Container(width: width,height: height,color: bgColor == null ? Color.fromRGBO(0, 0, 0, 0.1) : bgColor,);
    try {
      if(src == null || src.isEmpty) throw 'no image!';
      return ClipRRect(
        borderRadius: radius != null ? radius : BorderRadius.all(
            Radius.circular(ToPx.size(3))),
        child: Container(
            width: width,
            height: height,
            color: bgColor == null ? Color.fromRGBO(0, 0, 0, 0.05) : bgColor,
            child: src == null ? SizedBox() :
            SizedBox(
                width: width,
                height: height,
                child: isLocal ?
                Image.file(
                  File(src),
                  width: width,
                  height: height,
                  fit: fit,
                ) :
                TransitionToImage(
                  color: color,
                  image: AdvancedNetworkImage(
                    src,
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: const Duration(days: 30)),
                  ),
                  loadingWidgetBuilder: (_, double progress, __) =>
                      Center(
                          child: loadingIcon()
                      ),
                  fit: fit,
                  placeholder: Icon(
                    Icons.photo, color: Colors.grey.withAlpha(100),),
                  width: width,
                  height: height,
                  enableRefresh: true,
                )
            )
        ),
      );
    }catch(_){
      return Container(
        color: Colors.grey.withAlpha(10),
        child: Center(
          child: Text("图片已损坏\r\n或已删除", style: TextStyle(fontSize: ToPx.size(36), color: Colors.grey), textAlign: TextAlign.center,),
        ),
      );
    }
  }
}
