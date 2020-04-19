import 'package:kefu_workbench/core_flutter.dart';

class TemplatePage extends StatelessWidget {
  final Map<dynamic, dynamic> arguments;
  TemplatePage({this.arguments});
  
  @override
  Widget build(_) {
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);
      return Scaffold(
        appBar: customAppBar(
            isShowLeading: false,
            title: Text(
              "TemplatePage title",
              style: themeData.textTheme.display1,
            )),
        body: Text("TemplatePage"),
      );
    });
  }
}
