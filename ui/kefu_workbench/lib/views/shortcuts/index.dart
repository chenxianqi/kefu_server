import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/shortcut.dart';
import 'package:provider/provider.dart';

class ShortcutsPage extends StatelessWidget {
  final Map<dynamic, dynamic> arguments;
  ShortcutsPage({this.arguments});

  @override
  Widget build(_) {
    return ChangeNotifierProvider<ShortcutProvide>(
      create: (_) => ShortcutProvide.getInstance(),
      child: Consumer<ShortcutProvide>(builder: (context, shortcutState, _){
         return PageContext(builder: (context){
            ThemeData themeData = Theme.of(context);
            return Scaffold(
              backgroundColor: themeData.primaryColorLight,
              appBar: customAppBar(
                  title: Text(
                    "快捷语列表(${shortcutState.shortcuts.length})",
                    style: themeData.textTheme.display1,
                  ),
                  actions: [
                    Button(
                      height: ToPx.size(90),
                      useIosStyle: true,
                      color: Colors.transparent,
                      width: ToPx.size(150),
                      child: Text("新增"),
                      onPressed: () => shortcutState.goAdd(context)
                    ),
                  ],
                ),
              body: shortcutState.isLoading && shortcutState.shortcuts.length == 0 ? Center(
                child: loadingIcon(size: ToPx.size(50)),
              ): 
              RefreshIndicator(
                color: themeData.primaryColorLight,
                backgroundColor: themeData.primaryColor,
                onRefresh: shortcutState.onRefresh,
                child: CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                controller: shortcutState.scrollController,
                slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Offstage(
                        offstage: shortcutState.shortcuts.length > 0 || shortcutState.isLoading,
                        child: Padding(
                          padding: EdgeInsets.only(top: ToPx.size(50)),
                          child: Text("暂无数据~", style: themeData.textTheme.body1, textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        ShortcutModel shortcut = shortcutState.shortcuts[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => shortcutState.goEdit(context, shortcut),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text("${shortcut.content}", style: themeData.textTheme.caption),
                                  Text("添加时间：${Utils.epocFormat(shortcut.createAt)}",
                                    style: themeData.textTheme.caption.copyWith(
                                    color: themeData.textTheme.caption.color.withAlpha(150),
                                    fontSize: ToPx.size(24),
                                  ),)
                                ]
                              ),
                              title: Text("${index + 1}、 ${shortcut.title}", style: themeData.textTheme.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            ),
                            Divider(height: 1.0,)
                          ],
                        );
                      },
                      childCount: shortcutState.shortcuts.length
                     ),
                    ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        child: Center(
                          child: SizedBox(
                            height: ToPx.size(150),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                loadingIcon(),
                                Text('  内容加载中...',
                                    style: themeData.textTheme.caption)
                              ],
                            ),
                          ),
                        ),
                        offstage: !shortcutState.isLoading
                      )
                    ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: ToPx.size(40)),
                          child: Center(
                              child: Text(
                                  '没有更多了', style: themeData.textTheme.caption)
                          ),),
                        offstage:  shortcutState.shortcuts.length == 0 || shortcutState.isLoading
                      )
                    ),
                ],
              )
              ),
            );
          });
      },),
    );

  }
}

