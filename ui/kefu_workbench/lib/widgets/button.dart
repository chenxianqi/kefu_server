import '../core_flutter.dart';

/// border 不能设置单边
class Button extends StatelessWidget {
  Button(
      {this.child,
      this.onPressed,
      this.minSize,
      this.color,
      this.radius = 3.0,
      this.width,
      this.height,
      this.pressedOpacity = .2,
      this.border,
      this.padding,
      this.useIosStyle = false,
      this.alignment = Alignment.center,
      this.withAlpha = 35,
      this.disabledColor,
      this.margin});

  final double width;
  final double height;
  final bool useIosStyle;
  final Widget child;
  final double minSize;
  final Border border;
  final double pressedOpacity;
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;
  final Alignment alignment;
  final int withAlpha;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Widget _buttonCenter() {
      double height = this.height == null ? ToPx.size(80) : this.height;
      double width =
          this.width == null ? MediaQuery.of(context).size.width : this.width;
      return DefaultTextStyle(
          style:
              TextStyle(fontSize: ToPx.size(28), fontWeight: FontWeight.w600),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              border: border == null
                  ? Border.all(
                      width: ToPx.size(1),
                      color: border == null ? Colors.transparent : color)
                  : border,
            ),
            alignment: alignment,
            child: child,
          ));
    }

    return Container(
      height: height == null ? ToPx.size(80) : height,
      width: width == null ? MediaQuery.of(context).size.width : width,
      margin: margin,
      child: Stack(
        children: <Widget>[
          Platform.isIOS == true || useIosStyle == true
              ? CupertinoButton(
                  disabledColor: disabledColor == null
                      ? themeData.disabledColor
                      : disabledColor,
                  color: color == null ? themeData.buttonColor : color,
                  pressedOpacity: pressedOpacity,
                  padding: padding == null ? EdgeInsets.zero : padding,
                  minSize: minSize == null ? ToPx.size(80) : minSize,
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  child: _buttonCenter(),
                  onPressed: onPressed)
              : RaisedButton(
                  elevation: 0.0,
                  disabledColor: disabledColor == null
                      ? themeData.disabledColor
                      : disabledColor,
                  animationDuration: Duration(milliseconds: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                  ),
                  highlightColor: color == null
                      ? themeData.primaryColor.withAlpha(withAlpha)
                      : color?.withAlpha(withAlpha),
                  highlightElevation: 0.0,
                  color: color == null ? themeData.primaryColor : color,
                  padding: padding == null ? EdgeInsets.zero : padding,
                  onPressed: onPressed,
                  child: _buttonCenter(),
                )
        ],
      ),
    );
  }
}
