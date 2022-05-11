import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/tikTokCommentBottomSheet.dart';
import 'package:flutter_tiktok/views/tikTokVideo.dart';
import 'package:flutter_tiktok/views/tilTokAppBar.dart';
import 'package:flutter/material.dart';
import 'package:safemap/safemap.dart';
import 'package:tapped/tapped.dart';

/// 单独修改了bottomSheet组件的高度
import 'package:flutter_tiktok/other/bottomSheet.dart' as CustomBottomSheet;

class FollowPage extends StatefulWidget {
  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  Map<int, bool> fMap = {};
  int select = 0;
  @override
  Widget build(BuildContext context) {
    Widget head = TikTokSwitchAppbar(
      index: select,
      list: ['推荐', '关注'],
      onSwitch: (i) => setState(() => select = i),
    );
    Widget body = ListView.builder(
      padding: EdgeInsets.only(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: 10,
      itemBuilder: (ctx, i) {
        bool isF = SafeMap(fMap)[i].boolean;
        return FollowRow(
          isFavorite: isF,
          onFavorite: () {
            setState(() {
              fMap[i] = !isF;
            });
          },
          onAddFavorite: () {
            setState(() {
              fMap[i] = true;
            });
          },
          onComment: () {
            CustomBottomSheet.showModalBottomSheet(
              backgroundColor: Colors.white.withOpacity(0),
              context: context,
              builder: (BuildContext context) => TikTokCommentBottomSheet(),
            );
          },
          onShare: () {},
        );
      },
    );
    return Container(
      color: ColorPlate.back1,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          head,
          Expanded(child: body),
        ],
      ),
    );
  }
}

class FollowRow extends StatelessWidget {
  final bool? isFavorite;
  final Function? onFavorite;
  final Function? onComment;
  final Function? onShare;
  final Function? onAddFavorite;

  const FollowRow({
    Key? key,
    this.isFavorite,
    this.onFavorite,
    this.onComment,
    this.onShare,
    this.onAddFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget video = TikTokVideoPage(
      // rightButtonColumn: true,
      aspectRatio: 6.0 / 9,
      onAddFavorite: onAddFavorite,
      userInfoWidget: Container(),
    );
    video = Container(
      alignment: Alignment.topLeft,
      height: 400,
      child: AspectRatio(
        aspectRatio: 6.0 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: video,
        ),
      ),
    );
    Widget userInfo = Row(
      children: <Widget>[
        Container(
          height: 32,
          width: 32,
          child: ClipOval(
            child: Image.network(
              "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '朱二蛋的枯燥生活',
            style: StandardTextStyle.normalW,
          ),
        )
      ],
    );
    Widget content = Padding(
      padding: const EdgeInsets.fromLTRB(2, 6, 50, 8),
      child: Text(
        '#原创 有钱人的生活就是这么朴实无华，且枯燥 #短视频',
        style: StandardTextStyle.normal,
      ),
    );
    var buttonRow = Row(
      children: <Widget>[
        Text(
          '10-9',
          style: StandardTextStyle.smallWithOpacity,
        ),
        Expanded(child: Container()),
        _RowButton(
          iconData: Icons.share,
          title: '分享',
        ),
        _RowButton(
          iconData: Icons.mode_comment,
          size: SysSize.iconNormal - 2,
          title: '评论',
          onTap: onComment,
        ),
        _RowButton(
          color: isFavorite! ? ColorPlate.red : null,
          iconData: Icons.favorite,
          title: '赞',
          onTap: onFavorite,
        ),
      ],
    );
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          userInfo,
          content,
          video,
          Opacity(
            opacity: 0.8,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 12, 8),
              child: buttonRow,
            ),
          )
        ],
      ),
    );
  }
}

class _RowButton extends StatelessWidget {
  final IconData? iconData;
  final Color? color;
  final double? size;
  final String? title;
  final Function? onTap;

  const _RowButton({
    Key? key,
    this.iconData,
    this.size,
    this.title,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tapped(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            Icon(
              iconData ?? Icons.favorite,
              size: size ?? SysSize.iconNormal,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title ?? '??',
                style: StandardTextStyle.small,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
