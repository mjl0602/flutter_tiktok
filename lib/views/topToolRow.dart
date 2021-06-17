import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class TopToolRow extends StatelessWidget {
  final Widget? right;
  final bool? canPop;
  final Function? onPop;
  const TopToolRow({
    Key? key,
    this.right,
    this.canPop,
    this.onPop,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var popButton = canPop == true
        ? Tapped(
            child: Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.36),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
            onTap: () {
              if (onPop == null) {
                Navigator.of(context).pop();
              } else {
                onPop?.call();
              }
            },
          )
        : Container();
    Widget topButtonRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        popButton,
        Expanded(child: Container()),
        right ?? Container(),
      ],
    );
    return topButtonRow;
  }
}
