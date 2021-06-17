import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/tilTokAppBar.dart';
import 'package:flutter_tiktok/views/userMsgRow.dart';
import 'package:flutter/material.dart';

class MsgDetailListPage extends StatefulWidget {
  final String? title;

  final String? msgTitle;
  final String? msgDesc;
  final bool? reverse;

  const MsgDetailListPage({
    Key? key,
    this.title,
    this.msgTitle,
    this.msgDesc,
    this.reverse,
  }) : super(key: key);
  @override
  _MsgDetailListPageState createState() => _MsgDetailListPageState();
}

class _MsgDetailListPageState extends State<MsgDetailListPage> {
  @override
  Widget build(BuildContext context) {
    Widget head = TikTokAppbar(title: widget.title);
    Widget body = ListView.builder(
      padding: EdgeInsets.only(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: 20,
      itemBuilder: (_, __) => UserMsgRow(
        title: widget.msgTitle,
        desc: widget.msgDesc,
        reverse: widget.reverse ?? false,
      ),
    );
    return Scaffold(
      body: Container(
        color: ColorPlate.back1,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            head,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
