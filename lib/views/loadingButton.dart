import 'package:flutter_tiktok/style/text.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:tapped/tapped.dart';

class AdMusicLoadingButton extends StatelessWidget {
  const AdMusicLoadingButton({
    Key? key,
    required this.buttonText,
    this.onTap,
    this.isLoading: false,
    this.primary: true,
    this.margin,
    this.height,
    this.backgoundColor,
    this.shadow: false,
    this.textColor,
  }) : super(key: key);

  final String buttonText;
  final Function? onTap;
  final bool isLoading;
  final bool primary;
  final bool shadow;
  final EdgeInsets? margin;
  final double? height;
  final Color? backgoundColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    var body = Container(
      height: height ?? 44,
      width: double.infinity,
      padding: margin ?? EdgeInsets.symmetric(horizontal: 60),
      color: ColorPlate.clear,
      child: Container(
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            shadows: shadow
                ? [
                    BoxShadow(
                      color: ColorPlate.black.withOpacity(0.1),
                    )
                  ]
                : [],
            color: backgoundColor ??
                (primary ? ColorPlate.orange : ColorPlate.white),
          ),
          child: IndexedStack(
            alignment: Alignment.center,
            index: isLoading ? 0 : 1,
            children: <Widget>[
              CupertinoActivityIndicator(),
              Container(
                child: AdMucisText.normal(
                  buttonText,
                  enableOffset: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor ??
                        (primary ? ColorPlate.white : ColorPlate.orange),
                  ),
                ),
              ),
            ],
          )),
    );
    return Container(
      child: Tapped(
        onTap: () {
          if (!isLoading) {
            onTap?.call();
          }
        },
        child: body,
      ),
    );
  }
}
