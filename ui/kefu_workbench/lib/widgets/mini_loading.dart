import '../core_flutter.dart';

class MiniLoading extends StatelessWidget{
  MiniLoading({this.context, this.content = 'content'});
  final BuildContext context;
  final String content;
  @override
  Widget build(BuildContext _) {
    ThemeData themeData = Theme.of(context);
    return  WillPopScope(
        child:  Material(
          color: Colors.transparent,
          child: Theme(data: themeData.copyWith(accentColor: themeData.primaryColor), child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromRGBO(0, 0, 0, 0.3),
                child: Center(
                  child: Container(
                      width: ToPx.size(250),
                      height: ToPx.size(250),
                      padding: EdgeInsets.symmetric(
                          horizontal: ToPx.size(20), vertical: ToPx.size(30)),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, .7),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: ToPx.size(40), top: ToPx.size(20)),
                              child: Platform.isIOS == true
                                  ? CupertinoActivityIndicator(
                                radius: ToPx.size(30),
                              )
                                  : SizedBox(
                                width: ToPx.size(45),
                                height: ToPx.size(45),
                                child: CircularProgressIndicator(
                                   backgroundColor: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  content,
                                  style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: ToPx.size(32)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              )
          )),
        ),
        onWillPop: () async {
          return false;
        });
  }
}