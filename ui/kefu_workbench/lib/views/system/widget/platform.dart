import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
class PlatformSettingView  extends StatefulWidget{
  @override
  _PlatformSettingViewState createState() => _PlatformSettingViewState();
}

class _PlatformSettingViewState  extends State<PlatformSettingView>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  PlatformService platformService = PlatformService.getInstance();
  List<PlatformModel>  platforms = [];
  bool isLoading = true;

  /// 获取平台信息
  Future<void> _getPlatforms() async{
    await Future.delayed(Duration(milliseconds: 500));
    Response response = await platformService.getPlatforms();
    if (response.data["code"] == 200) {
      platforms = (response.data["data"] as List).map((i) =>PlatformModel.fromJson(i)).toList();
    } else {
      UX.showToast("${response.data["message"]}");
    }
    isLoading = false;
    setState(() {});
  }

  /// 刷新
  Future<bool> _onRefresh() async{
    await _getPlatforms();
     UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }

  /// 去添加
   void _goAdd(BuildContext context) async{
    Navigator.pushNamed(context, "/platform_add").then((isSuccess){
      if(isSuccess == true){
        _getPlatforms();
      }
    });
  }

  /// 去编辑
  void _goEdit(BuildContext context, PlatformModel platform){
    Navigator.pushNamed(context, "/platform_edit", arguments: {
      "platform": platform
    }).then((isSuccess){
      if(isSuccess == true){
        _getPlatforms();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if(mounted){
      _getPlatforms();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if(isLoading){
      return Center(
        child: loadingIcon(size: ToPx.size(50)),
      );
    }
    return RefreshIndicator(
          color: themeData.primaryColorLight,
          backgroundColor: themeData.primaryColor,
          onRefresh: () => _onRefresh(),
          child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ToPx.size(20)),
              sliver: SliverToBoxAdapter(child: Text("通过该配置，对接的平台，机器人，知识库匹配等", style: themeData.textTheme.caption, textAlign: TextAlign.center,),),
            ),
            
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
                PlatformModel platform  = platforms[index];
                return Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () => _goEdit(context, platform),
                      subtitle: Text("别名：${platform.alias}", style: themeData.textTheme.caption),
                      trailing: Text(platform.system == 1 ?"系统内置" : "自定义", style: themeData.textTheme.body1.copyWith(
                        color: platform.system == 1 ? Colors.amber : themeData.textTheme.body1.color
                      ),),
                      title: Text("${index + 1}、 ${platform.title}", style: themeData.textTheme.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ),
                    Divider(height: 1.0,)
                  ],
                );
              },
              childCount: platforms.length
              ),
            ),

            SliverToBoxAdapter(
              child: Button(
                withAlpha: 200,
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(80)),
                onPressed: () => _goAdd(context),
                child: Text("添加"),
              )
            )

        ],
      )
    );
  }
}