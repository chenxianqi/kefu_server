import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:provider/provider.dart';

class LinePopupMenuButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Consumer<GlobalProvide>(
      builder: (context, globalState, _){
        ThemeData themeData = Theme.of(context);
        GlobalProvide  globalState = Provider.of<GlobalProvide>(context);
        Color lineColor = globalState?.serviceUser?.online == 1  ? Colors.green[400] :
                    globalState?.serviceUser?.online == 0 ? Colors.grey :
                    globalState?.serviceUser?.online == 2 ? Colors.amber : Colors.grey;
        return PopupMenuButton<int>(
        onSelected: (int status) =>
            globalState?.setOnline(online: status),
        child: Align(
          child: Container(
              width: ToPx.size(80),
              height: ToPx.size(40),
              child: Row(
                children: <Widget>[
                  Container(
                    width: ToPx.size(10),
                    height: ToPx.size(10),
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lineColor
                  ),
                  ),
                  Text(
                    globalState?.serviceUser?.online == 0 ? " 离线" :
                    globalState?.serviceUser?.online == 1 ? " 在线" :
                    globalState?.serviceUser?.online == 2 ? " 离开" : "未知",
                    style: themeData.textTheme.caption.copyWith(
                    fontSize: ToPx.size(22),
                    color: lineColor
                  ),
                  ),
                ],
              )),
        ),
        itemBuilder: (BuildContext context) {
          List<PopupMenuEntry<int>> menus = [];
          PopupMenuItem<int> online = PopupMenuItem<int>(
            value: 1,
            child: Text(
              '我要上线',
              style: themeData.textTheme.title.copyWith(
                  color: themeData.primaryColorLight),
            ),
          );
          PopupMenuItem<int> offline = PopupMenuItem<int>(
            value: 0,
            child: Text(
              '我要下线',
              style: themeData.textTheme.title.copyWith(
                  color: themeData.primaryColorLight),
            ),
          );
          PopupMenuItem<int> leave = PopupMenuItem<int>(
            value: 2,
            child: Text(
              '我要离开',
              style: themeData.textTheme.title.copyWith(
                  color: themeData.primaryColorLight),
            ),
          );

          if (globalState?.serviceUser?.online != 1) {
            menus.add(online);
          }
          if (globalState?.serviceUser?.online != 0) {
            menus.add(offline);
          }
          if (globalState?.serviceUser?.online != 2) {
            menus.add(leave);
          }
          return menus;
        });
        
      }
    );

  }
}