import 'dart:math';

import '../core_flutter.dart';
/*
 * 重新定义刷新样式
 */
class RefreshWidget extends StatelessWidget{
  RefreshWidget(
    this.refreshState,
    this.pulledExtent,
    this.refreshTriggerPullDistance,
    this.refreshIndicatorExtent,
    {
      this.bgSrc,
      this.bgColor = const Color(0xffffffff),
      this.dragText = "下拉刷新",
      this.doneText = "刷新完成",
      this.refreshText = "刷新中...",
      this.isNoRefresh = false,
      this.iconColor = Colors.grey,
      this.textColor = const Color(0xff666666),
      this.noRefreshWidget = const SizedBox()
    }
  );
  final RefreshIndicatorMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final Color bgColor;
  final String dragText;
  final String doneText;
  final String refreshText;
  final String bgSrc;
  final bool isNoRefresh;
  final Color iconColor;
  final Color textColor;
  final Widget noRefreshWidget;
  @override
  Widget build(BuildContext context) {

    if(isNoRefresh) return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: noRefreshWidget
    );

    const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.fastOutSlowIn);
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: ToPx.size(10)),
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Opacity(
        opacity: opacityCurve.transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            refreshState == RefreshIndicatorMode.done ?
              Icon(Icons.done,color: iconColor ,size: ToPx.size(30),) :
            refreshState == RefreshIndicatorMode.drag ?
            Icon(Icons.arrow_downward,color:iconColor,size: ToPx.size(30),) :
            loadingIcon(),
            Text(
              refreshState == RefreshIndicatorMode.done
                  ? " $doneText" : refreshState == RefreshIndicatorMode.drag ?  " $dragText" : " $refreshText",
              style: TextStyle(fontSize: ToPx.size(26), color: textColor),
            )
          ],
        )
      ),
    );
  }
}
