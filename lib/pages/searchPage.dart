
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class SearchPage extends StatefulWidget {
  final Function? onPop;

  const SearchPage({
    Key? key,
    this.onPop,
  }) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Widget head = Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: ColorPlate.back2,
      width: double.infinity,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.fullscreen,
              size: 24,
            ),
            Expanded(
              child: Container(
                height: 32,
                margin: EdgeInsets.only(right: 20, left: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.only(left: 12),
                child: Opacity(
                  opacity: 0.3,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 2, bottom: 2),
                        child: Text(
                          '搜索内容',
                          style: StandardTextStyle.normal,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Tapped(
              child: Text(
                '取消',
                style: StandardTextStyle.normal.apply(color: ColorPlate.orange),
              ),
              onTap: widget.onPop,
            ),
          ],
        ),
      ),
    );
    Widget body = ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _SearchSelectRow(),
        _SearchSelectRow(),
        _SearchSelectRow(),
        _SearchSelectRow(),
        _SearchSelectRow(),
        Opacity(
          opacity: 0.6,
          child: Container(
            height: 46,
            child: Center(child: Text('全部搜索记录')),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: AspectRatio(
            aspectRatio: 4.0,
            child: Container(
              decoration: BoxDecoration(
                color: ColorPlate.darkGray,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '预留轮播图',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
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

class _SearchSelectRow extends StatelessWidget {
  const _SearchSelectRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.timelapse,
            size: 20,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8, bottom: 1),
              child: Text(
                '搜索热点',
                style: StandardTextStyle.normal,
              ),
            ),
          ),
          Icon(
            Icons.clear,
            size: 20,
          ),
        ],
      ),
    );
  }
}
