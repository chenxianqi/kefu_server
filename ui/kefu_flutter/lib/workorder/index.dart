import 'package:flutter/material.dart';

class WorkOrder extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        title: Text("我的工单"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "创建工单",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: (){},
          )
      ],
      ),
      body: CustomScrollView(

      ),
    );
  }
}