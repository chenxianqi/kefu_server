import 'package:flutter/material.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/utils//index.dart';
class ShortcutPanel extends StatelessWidget{
  ShortcutPanel({
    this.isShow,
    this.listData,
    this.onSelected
  });
  final bool isShow;
  final List<ShortcutModel> listData;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Offstage(
      offstage: !isShow,
      child: Container(
      width: double.infinity,
      height: ToPx.size(500),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1.0, color: themeData.dividerColor))
      ),
      child: 
      listData.length == 0 ?
      Center(
        child: Text("没您还没有设置相关快捷语！", style: themeData.textTheme.body1),
      ) :
      ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index){
          return Column(
            children: <Widget>[
              Button(
                alignment: Alignment.centerLeft,
                radius: 0.0,
                height: ToPx.size(135),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
                color: Colors.white,
                withAlpha: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${listData[index].title}", style: themeData.textTheme.body1, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    Text("${listData[index].content}", style: themeData.textTheme.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
                onPressed: () => onSelected(listData[index].content),
              ),
              Divider(height: 1.0,)
            ],
          );
        }
      ),
    ),
    );
  }
}