import 'package:flutter_tiktok/mock/video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// class VideoInfo {
//   final String url;
//   final String title;

//   VideoInfo(this.url, this.title);
// }

class VideoListController {
  /// 构造方法
  VideoListController();

  /// 捕捉滑动，实现翻页
  void setPageContrller(PageController pageController) {
    pageController.addListener(() {
      var p = pageController.page!;
      if (p % 1 == 0) {
        int target = p ~/ 1;
        if (index.value == target) return;
        // 播放当前的，暂停其他的
        var oldIndex = index.value;
        var newIndex = target;
        playerOfIndex(oldIndex).seekTo(Duration.zero);
        playerOfIndex(oldIndex).pause();
        playerOfIndex(newIndex).play();
        // 完成
        index.value = target;
      }
    });
  }

  /// 获取指定index的player
  VideoPlayerController playerOfIndex(int index) => playerList[index];

  /// 视频总数目
  int get videoCount => playerList.length;

  /// 在当前的list后面继续增加视频，并预加载封面
  addVideoInfo(List<UserVideo> list) {
    for (var info in list) {
      var player = VideoPlayerController.network(
        info.url,
      );
      player.setLooping(true);
      player.initialize();
      playerList.add(player);
    }
  }

  /// 初始化
  init(PageController pageController, List<UserVideo> initialList) {
    addVideoInfo(initialList);
    setPageContrller(pageController);
  }

  /// 目前的视频序号
  ValueNotifier<int> index = ValueNotifier<int>(0);

  /// 视频列表
  List<VideoPlayerController> playerList = [];

  ///
  VideoPlayerController get currentPlayer => playerList[index.value];

  bool get isPlaying => currentPlayer.value.isPlaying;

  /// 销毁全部
  void dispose() {
    // 销毁全部
    for (var player in playerList) {
      player.dispose();
    }
    playerList = [];
  }
}
