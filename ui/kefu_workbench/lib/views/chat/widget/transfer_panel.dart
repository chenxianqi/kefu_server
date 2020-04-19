import 'package:flutter/material.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/utils//index.dart';
class TransferPanel extends StatelessWidget{
  TransferPanel({
    this.isShow,
    this.listData,
    this.onSelected
  });
  final bool isShow;
  final List<AdminModel> listData;
  final ValueChanged<AdminModel> onSelected;
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
        child: Text("当前没有其他客服在线！", style: themeData.textTheme.body1),
      ) :
      ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index){
          AdminModel user = listData[index];
          return Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: ToPx.size(90),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                      children: <Widget>[
                        Avatar(
                          size: ToPx.size(60),
                          imgUrl: user.avatar ??
                              "http://qiniu.cmp520.com/avatar_default.png",
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("  ${user.nickname}", style: themeData.textTheme.body1),
                            Text("  当前在线", style: themeData.textTheme.caption.copyWith(
                              color: Colors.green[400],
                              fontSize: ToPx.size(20)
                            )),
                          ],
                        )
                      ],
                    ),
                    ),
                    Button(
                      width: ToPx.size(90),
                      height: ToPx.size(50),
                      withAlpha: 200,
                      child: Text("转接", style: themeData.textTheme.body1.copyWith(
                        color: Colors.amber,
                        fontSize: ToPx.size(20)
                      ),),
                      onPressed: () => onSelected(listData[index]),
                    )
                  ],
                ),
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