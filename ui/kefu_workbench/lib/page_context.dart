
import 'core_flutter.dart';

typedef Build = Widget Function(BuildContext context);
class PageContext extends StatelessWidget {
  PageContext({
    @required this.builder,
    this.onClickRefresh,
    this.onClickPage
  });

  final Build builder;
  final VoidCallback onClickRefresh;
  final VoidCallback onClickPage;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        if(onClickPage != null) onClickPage();
      },
      child: Theme(
        data: _themeData.copyWith(
            // 重写字体大写
            textTheme: TextTheme(
              title:_themeData.textTheme.title.copyWith(fontSize: ToPx.size(30),),
              body1: _themeData.textTheme.body1.copyWith(fontSize: ToPx.size(28),),
              body2: _themeData.textTheme.body2.copyWith(fontSize: ToPx.size(28),),
              caption: _themeData.textTheme.caption.copyWith(fontSize: ToPx.size(26),),
              display1: _themeData.textTheme.display1.copyWith(fontSize: ToPx.size(34),),
            )
        ),
        child: Builder(builder: (context) => builder(context))
      ),
    );
  }
}
