import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/tikTokVideoButtonColumn.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    Widget rightButtons = Column(
      children: <Widget>[
        _CameraIconButton(
          icon: Icons.repeat,
          title: '翻转',
        ),
        _CameraIconButton(
          icon: Icons.tonality,
          title: '速度',
        ),
        _CameraIconButton(
          icon: Icons.texture,
          title: '滤镜',
        ),
        _CameraIconButton(
          icon: Icons.sentiment_satisfied,
          title: '美化',
        ),
        _CameraIconButton(
          icon: Icons.timer,
          title: '计时关',
        ),
      ],
    );
    rightButtons = Opacity(
      opacity: 0.8,
      child: Container(
        padding: EdgeInsets.only(right: 20, top: 12),
        alignment: Alignment.topRight,
        child: Container(
          child: rightButtons,
        ),
      ),
    );
    Widget selectMusic = Container(
      padding: EdgeInsets.only(left: 20, top: 20),
      alignment: Alignment.topCenter,
      child: DefaultTextStyle(
        style: TextStyle(
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconToText(
              Icons.music_note,
            ),
            Text(
              '选择音乐',
              style: StandardTextStyle.normal,
            ),
            Container(width: 32, height: 12),
          ],
        ),
      ),
    );

    var closeButton = Tapped(
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 20),
        alignment: Alignment.topLeft,
        child: Container(
          child: Icon(Icons.clear),
        ),
      ),
      onTap: Navigator.of(context).pop,
    );

    var cameraButton = Container(
      padding: EdgeInsets.only(bottom: 12),
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _SidePhotoButton(title: '道具'),
            Expanded(
              child: Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.white.withOpacity(0.4),
                      width: 6,
                    ),
                  ),
                ),
              ),
            ),
            _SidePhotoButton(title: '上传'),
          ],
        ),
      ),
    );
    var body = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        cameraButton,
        closeButton,
        selectMusic,
        rightButtons,
      ],
    );

    return Scaffold(
      // backgroundColor: Color(0xFFf5f5f4),
      body: SafeArea(
        child: body,
      ),
    );
  }
}

class _SidePhotoButton extends StatelessWidget {
  final String? title;
  const _SidePhotoButton({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              style: BorderStyle.solid,
              color: Colors.white.withOpacity(0.4),
              width: 2,
            ),
          ),
        ),
        Container(height: 2),
        Text(
          title!,
          style: StandardTextStyle.smallWithOpacity,
        )
      ],
    );
  }
}

class _CameraIconButton extends StatelessWidget {
  final IconData? icon;
  final String? title;
  const _CameraIconButton({
    Key? key,
    this.icon,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DefaultTextStyle(
        style: TextStyle(shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ]),
        child: Column(
          children: <Widget>[
            IconToText(
              icon,
            ),
            Text(
              title!,
              style: StandardTextStyle.small,
            ),
          ],
        ),
      ),
    );
  }
}
