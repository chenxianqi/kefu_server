import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/chat_record.dart';
import 'package:provider/provider.dart';

class PopupButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Consumer<ChatReCordProvide>(
      builder: (context, chatReCordState, _){
        ThemeData themeData = Theme.of(context);
        return PopupMenuButton<AdminModel>(
        onSelected: (AdminModel admin) => chatReCordState.onSelected(admin),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            alignment: Alignment.centerRight,
            width: ToPx.size(250),
            child: Text("客服：${chatReCordState?.selectedAdmin?.nickname ?? '选择客服'}    ",
              style: themeData.textTheme.caption.copyWith(
              color: Colors.amber,
              fontSize: ToPx.size(26)
            )))
        ),
        itemBuilder: (BuildContext context) => chatReCordState.admins.map((i) => PopupMenuItem<AdminModel>(
            value: i,
            child: Center(
              child: Text(
              '${i.nickname}',
              style: themeData.textTheme.title.copyWith(
                color: chatReCordState.selectedAdmin?.id == i.id ? Colors.amber : themeData.primaryColorLight
              ),
            )
            ),
          )).toList());
        
      }
    );

  }
}