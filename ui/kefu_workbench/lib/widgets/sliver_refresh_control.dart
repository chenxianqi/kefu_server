

import '../core_flutter.dart';

CupertinoSliverRefreshControl sliverRefreshControl({
  VoidCallback onRefresh,
  Color bgColor = const Color(0xffffffff),
  bool isNoRefresh = false,
  Color iconColor = Colors.grey,
  Color textColor = const Color(0xff666666),
  Widget noRefreshWidget
}){
  return CupertinoSliverRefreshControl(
    builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent){
      return RefreshWidget(
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        bgColor: bgColor,
        isNoRefresh: isNoRefresh,
        iconColor: iconColor,
        textColor: textColor,
        noRefreshWidget: noRefreshWidget
      );
    },
    onRefresh: onRefresh
  );
}