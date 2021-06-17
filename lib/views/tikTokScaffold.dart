import 'dart:math';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double scrollSpeed = 300;

enum TikTokPagePositon {
  left,
  right,
  middle,
}

class TikTokScaffoldController extends ValueNotifier<TikTokPagePositon> {
  TikTokScaffoldController([
    TikTokPagePositon value = TikTokPagePositon.middle,
  ]) : super(value);

  Future? animateToPage(TikTokPagePositon pagePositon) {
    return _onAnimateToPage?.call(pagePositon);
  }

  Future? animateToLeft() {
    return _onAnimateToPage?.call(TikTokPagePositon.left);
  }

  Future? animateToRight() {
    return _onAnimateToPage?.call(TikTokPagePositon.right);
  }

  Future? animateToMiddle() {
    return _onAnimateToPage?.call(TikTokPagePositon.middle);
  }

  Future Function(TikTokPagePositon pagePositon)? _onAnimateToPage;
}

class TikTokScaffold extends StatefulWidget {
  final TikTokScaffoldController? controller;

  /// 首页的顶部
  final Widget? header;

  /// 底部导航
  final Widget? tabBar;

  /// 左滑页面
  final Widget? leftPage;

  /// 右滑页面
  final Widget? rightPage;

  /// 视频序号
  final int currentIndex;

  final bool hasBottomPadding;
  final bool? enableGesture;

  final Widget? page;

  final Function()? onPullDownRefresh;

  const TikTokScaffold({
    Key? key,
    this.header,
    this.tabBar,
    this.leftPage,
    this.rightPage,
    this.hasBottomPadding: false,
    this.page,
    this.currentIndex: 0,
    this.enableGesture,
    this.onPullDownRefresh,
    this.controller,
  }) : super(key: key);

  @override
  _TikTokScaffoldState createState() => _TikTokScaffoldState();
}

class _TikTokScaffoldState extends State<TikTokScaffold>
    with TickerProviderStateMixin {
  AnimationController? animationControllerX;
  AnimationController? animationControllerY;
  late Animation<double> animationX;
  late Animation<double> animationY;
  double offsetX = 0.0;
  double offsetY = 0.0;
  // int currentIndex = 0;
  double inMiddle = 0;

  @override
  void initState() {
    widget.controller!._onAnimateToPage = animateToPage;
    super.initState();
  }

  Future animateToPage(p) async {
    if (screenWidth == null) {
      return null;
    }
    switch (p) {
      case TikTokPagePositon.left:
        await animateTo(screenWidth!);
        break;
      case TikTokPagePositon.middle:
        await animateTo();
        break;
      case TikTokPagePositon.right:
        await animateTo(-screenWidth!);
        break;
    }
    widget.controller!.value = p;
  }

  double? screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    // 先定义正常结构
    Widget body = Stack(
      children: <Widget>[
        _LeftPageTransform(
          offsetX: offsetX,
          content: widget.leftPage,
        ),
        _MiddlePage(
          absorbing: absorbing,
          onTopDrag: () {
            // absorbing = true;
            setState(() {});
          },
          offsetX: offsetX,
          offsetY: offsetY,
          header: widget.header,
          tabBar: widget.tabBar,
          isStack: !widget.hasBottomPadding,
          page: widget.page,
        ),
        _RightPageTransform(
          offsetX: offsetX,
          offsetY: offsetY,
          content: widget.rightPage,
        ),
      ],
    );
    // 增加手势控制
    body = GestureDetector(
      onVerticalDragUpdate: calculateOffsetY,
      onVerticalDragEnd: (_) async {
        if (!widget.enableGesture!) return;
        absorbing = false;
        if (offsetY != 0) {
          await animateToTop();
          widget.onPullDownRefresh?.call();
          setState(() {});
        }
      },
      onHorizontalDragEnd: (details) => onHorizontalDragEnd(
        details,
        screenWidth,
      ),
      // 水平方向滑动开始
      onHorizontalDragStart: (_) {
        if (!widget.enableGesture!) return;
        animationControllerX?.stop();
        animationControllerY?.stop();
      },
      onHorizontalDragUpdate: (details) => onHorizontalDragUpdate(
        details,
        screenWidth,
      ),
      child: body,
    );
    body = WillPopScope(
      onWillPop: () async {
        if (!widget.enableGesture!) return true;
        if (inMiddle == 0) {
          return true;
        }
        widget.controller!.animateToMiddle();
        return false;
      },
      child: Scaffold(
        body: body,
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
      ),
    );
    return body;
  }

  // 水平方向滑动中
  void onHorizontalDragUpdate(details, screenWidth) {
    if (!widget.enableGesture!) return;
    // 控制 offsetX 的值在 -screenWidth 到 screenWidth 之间
    if (offsetX + details.delta.dx >= screenWidth) {
      setState(() {
        offsetX = screenWidth;
      });
    } else if (offsetX + details.delta.dx <= -screenWidth) {
      setState(() {
        offsetX = -screenWidth;
      });
    } else {
      setState(() {
        offsetX += details.delta.dx;
      });
    }
  }

  // 水平方向滑动结束
  onHorizontalDragEnd(details, screenWidth) {
    if (!widget.enableGesture!) return;
    print('velocity:${details.velocity}');
    var vOffset = details.velocity.pixelsPerSecond.dx;

    // 速度很快时
    if (vOffset > scrollSpeed && inMiddle == 0) {
      // 去右边页面
      return animateToPage(TikTokPagePositon.left);
    } else if (vOffset < -scrollSpeed && inMiddle == 0) {
      // 去左边页面
      return animateToPage(TikTokPagePositon.right);
    } else if (inMiddle > 0 && vOffset < -scrollSpeed) {
      return animateToPage(TikTokPagePositon.middle);
    } else if (inMiddle < 0 && vOffset > scrollSpeed) {
      return animateToPage(TikTokPagePositon.middle);
    }
    // 当滑动停止的时候 根据 offsetX 的偏移量进行动画
    if (offsetX.abs() < screenWidth * 0.5) {
      // 中间页面
      return animateToPage(TikTokPagePositon.middle);
    } else if (offsetX > 0) {
      // 去左边页面
      return animateToPage(TikTokPagePositon.left);
    } else {
      // 去右边页面
      return animateToPage(TikTokPagePositon.right);
    }
  }

  /// 滑动到顶部
  ///
  /// [offsetY] to 0.0
  Future animateToTop() {
    animationControllerY = AnimationController(
        duration: Duration(milliseconds: offsetY.abs() * 1000 ~/ 60),
        vsync: this);
    final curve = CurvedAnimation(
        parent: animationControllerY!, curve: Curves.easeOutCubic);
    animationY = Tween(begin: offsetY, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetY = animationY.value;
        });
      });
    return animationControllerY!.forward();
  }

  CurvedAnimation curvedAnimation() {
    animationControllerX = AnimationController(
        duration: Duration(milliseconds: max(offsetX.abs(), 60) * 1000 ~/ 500),
        vsync: this);
    return CurvedAnimation(
        parent: animationControllerX!, curve: Curves.easeOutCubic);
  }

  Future animateTo([double end = 0.0]) {
    final curve = curvedAnimation();
    animationX = Tween(begin: offsetX, end: end).animate(curve)
      ..addListener(() {
        setState(() {
          offsetX = animationX.value;
        });
      });
    inMiddle = end;
    return animationControllerX!.animateTo(1);
  }

  bool absorbing = false;
  double endOffset = 0.0;

  /// 计算[offsetY]
  ///
  /// 手指上滑,[absorbing]为false，不阻止事件，事件交给底层PageView处理
  /// 处于第一页且是下拉，则拦截滑动���件
  void calculateOffsetY(DragUpdateDetails details) {
    if (!widget.enableGesture!) return;
    if (inMiddle != 0) {
      setState(() => absorbing = false);
      return;
    }
    final tempY = offsetY + details.delta.dy / 2;
    if (widget.currentIndex == 0) {
      // absorbing = true; // TODO:暂时屏蔽了下拉刷新
      if (tempY > 0) {
        if (tempY < 40) {
          offsetY = tempY;
        } else if (offsetY != 40) {
          offsetY = 40;
          // vibrate();
        }
      } else {
        absorbing = false;
      }
      setState(() {});
    } else {
      absorbing = false;
      offsetY = 0;
      setState(() {});
    }
    print(absorbing.toString());
  }

  @override
  void dispose() {
    animationControllerX?.dispose();
    animationControllerY?.dispose();
    super.dispose();
  }
}

class _MiddlePage extends StatelessWidget {
  final bool? absorbing;
  final bool isStack;
  final Widget? page;

  final double? offsetX;
  final double? offsetY;
  final Function? onTopDrag;

  final Widget? header;
  final Widget? tabBar;

  const _MiddlePage({
    Key? key,
    this.absorbing,
    this.onTopDrag,
    this.offsetX,
    this.offsetY,
    this.isStack: false,
    required this.header,
    required this.tabBar,
    this.page,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget tabBarContainer = tabBar ??
        Container(
          height: 44,
          child: Placeholder(
            color: Colors.red,
          ),
        );
    Widget mainVideoList = Container(
      color: ColorPlate.back1,
      padding: EdgeInsets.only(
        bottom: isStack ? 0 : 44 + MediaQuery.of(context).padding.bottom,
      ),
      child: page,
    );
    // 刷新标志
    Widget _headerContain;
    if (offsetY! >= 20) {
      _headerContain = Opacity(
        opacity: (offsetY! - 20) / 20,
        child: Transform.translate(
          offset: Offset(0, offsetY!),
          child: Container(
            height: 44,
            child: Center(
              child: const Text(
                "下拉刷新内容",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SysSize.normal,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      _headerContain = Opacity(
        opacity: max(0, 1 - offsetY! / 20),
        child: Transform.translate(
          offset: Offset(0, offsetY!),
          child: SafeArea(
            child: Container(
              height: 44,
              child: header ?? Placeholder(color: Colors.green),
            ),
          ),
        ),
      );
    }

    Widget middle = Transform.translate(
      offset: Offset(offsetX! > 0 ? offsetX! : offsetX! / 5, 0),
      child: Stack(
        children: <Widget>[
          Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                mainVideoList,
                tabBarContainer,
              ],
            ),
          ),
          _headerContain,
        ],
      ),
    );
    if (page is! PageView) {
      return middle;
    }
    return AbsorbPointer(
      absorbing: absorbing!,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return;
        } as bool Function(OverscrollIndicatorNotification)?,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            // 当手指离开时，并且处于顶部则拦截PageView的滑动事件 TODO: 没有触发下拉刷新
            if (notification.direction == ScrollDirection.idle &&
                notification.metrics.pixels == 0.0) {
              onTopDrag?.call();
              return false;
            }
            return true;
          },
          child: middle,
        ),
      ),
    );
  }
}

/// 左侧Widget
///
/// 通过 [Transform.scale] 进行根据 [offsetX] 缩放
/// 最小 0.88 最大为 1
class _LeftPageTransform extends StatelessWidget {
  final double? offsetX;
  final Widget? content;

  const _LeftPageTransform({Key? key, this.offsetX, this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Transform.scale(
      scale: 0.88 + 0.12 * offsetX! / screenWidth < 0.88
          ? 0.88
          : 0.88 + 0.12 * offsetX! / screenWidth,
      child: content ?? Placeholder(color: Colors.pink),
    );
  }
}

class _RightPageTransform extends StatelessWidget {
  final double? offsetX;
  final double? offsetY;

  final Widget? content;

  const _RightPageTransform({
    Key? key,
    this.offsetX,
    this.offsetY,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Transform.translate(
        offset: Offset(max(0, offsetX! + screenWidth), 0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.transparent,
          child: content ?? Placeholder(fallbackWidth: screenWidth),
        ));
  }
}
