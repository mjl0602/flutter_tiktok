import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class TodoPage extends StatelessWidget {
  final String? title;
  final String? detail;

  const TodoPage({
    Key? key,
    this.title,
    this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool canpop = Navigator.of(context).canPop();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  child: FlutterLogo(
                    size: 120,
                  ),
                ),
                Text(
                  title ?? '未开放的页面',
                  style: StandardTextStyle.big,
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text(
                    detail ?? '正在施工中',
                    style: StandardTextStyle.smallWithOpacity,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: canpop
                  ? Tapped(
                      child: Icon(
                        Icons.clear,
                        size: 30,
                        color: Colors.red,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
            ),
          ),
          Expanded(
            child: Center(),
          ),
        ],
      ),
    );
  }
}
