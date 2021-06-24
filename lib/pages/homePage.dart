import 'package:flutter_tiktok/mock/video.dart';
import 'package:flutter_tiktok/other/pageView.dart';
import 'package:flutter_tiktok/pages/cameraPage.dart';
import 'package:flutter_tiktok/pages/followPage.dart';
import 'package:flutter_tiktok/pages/searchPage.dart';
import 'package:flutter_tiktok/pages/userPage.dart';
import 'package:flutter_tiktok/views/tikTokCommentBottomSheet.dart';
import 'package:flutter_tiktok/views/tikTokHeader.dart';
import 'package:flutter_tiktok/views/tikTokScaffold.dart';
import 'package:flutter_tiktok/views/tikTokVideo.dart';
import 'package:flutter_tiktok/views/tikTokVideoButtonColumn.dart';
import 'package:flutter_tiktok/views/tikTokVideoPlayer.dart';
import 'package:flutter_tiktok/views/tiktokTabBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safemap/safemap.dart';
import 'package:video_player/video_player.dart';

import 'msgPage.dart';

/// 单独修改了bottomSheet组件的高度
import 'package:flutter_tiktok/other/bottomSheet.dart' as CustomBottomSheet;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  TikTokPageController _pageController = TikTokPageController();

  VideoListController _videoListController = VideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  @override
  void initState() {
    videoDataList = UserVideo.fetchVideo();
    WidgetsBinding.instance!.addObserver(this);
    _videoListController.init(
      _pageController,
      videoDataList,
    );
    _videoListController.addListener(() {
      setState(() {});
    });
    tkController.addListener(
      () {
        if (tkController.value == TikTokPagePositon.middle) {
          _videoListController.currentPlayer.play();
        } else {
          _videoListController.currentPlayer.pause();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? currentPage;

    switch (tabBarType) {
      case TikTokPageTag.home:
        break;
      case TikTokPageTag.follow:
        currentPage = FollowPage();
        break;
      case TikTokPageTag.msg:
        currentPage = MsgPage();
        break;
      case TikTokPageTag.me:
        currentPage = UserPage(isSelfPage: true);
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    bool hasBackground = hasBottomPadding;
    hasBackground = tabBarType != TikTokPageTag.home;
    if (hasBottomPadding) {
      hasBackground = true;
    }
    Widget tikTokTabBar = TikTokTabBar(
      hasBackground: hasBackground,
      current: tabBarType,
      onTabSwitch: (type) async {
        setState(() {
          tabBarType = type;
          if (type == TikTokPageTag.home) {
            _videoListController.currentPlayer.play();
          } else {
            _videoListController.currentPlayer.pause();
          }
        });
      },
      onAddButton: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CameraPage(),
          ),
        );
      },
    );

    var userPage = UserPage(
      isSelfPage: false,
      canPop: true,
      onPop: () {
        tkController.animateToMiddle();
      },
    );
    var searchPage = SearchPage(
      onPop: tkController.animateToMiddle,
    );

    var header = tabBarType == TikTokPageTag.home
        ? TikTokHeader(
            onSearch: () {
              tkController.animateToLeft();
            },
          )
        : Container();

    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      tabBar: tikTokTabBar,
      header: header,
      leftPage: searchPage,
      rightPage: userPage,
      enableGesture: tabBarType == TikTokPageTag.home,
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          TikTokPageView.builder(
            key: Key('home'),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videoListController.videoCount,
            itemBuilder: (context, i) {
              // 拼一个视频组件出来
              var data = videoDataList[i];
              bool isF = SafeMap(favoriteMap)[i].boolean ?? false;
              var player = _videoListController.playerOfIndex(i);
              // 右侧按钮列
              Widget buttons = TikTokButtonColumn(
                isFavorite: isF,
                onAvatar: () {
                  tkController.animateToPage(TikTokPagePositon.right);
                },
                onFavorite: () {
                  setState(() {
                    favoriteMap[i] = !isF;
                  });
                  // showAboutDialog(context: context);
                },
                onComment: () {
                  CustomBottomSheet.showModalBottomSheet(
                    backgroundColor: Colors.white.withOpacity(0),
                    context: context,
                    builder: (BuildContext context) =>
                        TikTokCommentBottomSheet(),
                  );
                },
                onShare: () {},
              );
              // video
              Widget currentVideo = Center(
                child: AspectRatio(
                  aspectRatio: player.value.aspectRatio,
                  child: VideoPlayer(player),
                ),
              );

              currentVideo = TikTokVideoPage(
                // TODO: 手势播放与自然播放都会产生暂停按钮状态变化，待处理
                hidePauseIcon: true,
                aspectRatio: 9 / 16.0,
                key: Key(data.url + '$i'),
                tag: data.url,
                bottomPadding: hasBottomPadding ? 16.0 : 16.0,
                userInfoWidget: VideoUserInfo(
                  desc: data.desc,
                  bottomPadding: hasBottomPadding ? 16.0 : 50.0,
                ),
                onSingleTap: () async {
                  if (player.value.isPlaying) {
                    await player.pause();
                  } else {
                    await player.play();
                  }
                  setState(() {});
                },
                onAddFavorite: () {
                  setState(() {
                    favoriteMap[i] = true;
                  });
                },
                rightButtonColumn: buttons,
                video: currentVideo,
              );
              return currentVideo;
            },
          ),
          currentPage ?? Container(),
        ],
      ),
    );
  }
}
