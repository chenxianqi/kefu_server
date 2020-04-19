import '../core_flutter.dart';
Widget loadingIcon({double size}){
  return SizedBox(
    width: size ?? ToPx.size(25),
    height: size ?? ToPx.size(25),
    child: Platform.isAndroid ?
    CircularProgressIndicator(
      strokeWidth: 2.0,
    ):
    CupertinoActivityIndicator(radius: ToPx.size(25),)
  );
}