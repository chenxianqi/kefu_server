import '../core_flutter.dart';
PreferredSize customAppBar({
  Widget title,
  leading,
  Color backgroundColor,
  double elevation,
  List<Widget> actions,
  PreferredSizeWidget bottom,
  bool isShowLeading = true,
  Widget flexibleSpace,
  Brightness brightness,
  double size
}){
  return PreferredSize(
    preferredSize: Size(double.infinity, size ?? ToPx.size(90)),
    child: AppBar(
      automaticallyImplyLeading: isShowLeading,
      backgroundColor: backgroundColor ?? ThemeProvide.getInstance().getCurrentTheme().primaryColor,
      elevation: elevation,
      centerTitle: true,
      title: title,
      actions: actions,
      brightness: brightness,
      leading: isShowLeading ? leading == null ? CustomBackButton() : leading : null,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
    )
  );
}

class CustomBackButton extends StatelessWidget{
  CustomBackButton({this.color = Colors.white});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Button(
      width: ToPx.size(60),
      useIosStyle: true,
      color: Colors.transparent,
      onPressed: () => Navigator.pop(context),
      child: Icon(IconData(0xe600, fontFamily: 'IconFont'),size: ToPx.size(30), color: color,),
    );
  }

}