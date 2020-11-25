import 'package:common_plugin/common_plugin.dart';
import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/res/WConstant.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WItem extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;
  final double lrPadding;
  final bool showArrow;
  final Function onPressedCallBack;

  WItem({
    this.width,
    this.height,
    this.color,
    this.child,
    this.showArrow = true,
    this.lrPadding,
    this.onPressedCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressedCallBack?.call,
      child: Container(
        width: width,
        height: height ?? 54.px,
        padding: EdgeInsets.symmetric(horizontal: lrPadding ?? 16.px),
        color: color ?? Colors.white,
        child: Row(
          children: [
            Expanded(child: child),
            showArrow
                ? SvgPicture.asset(
                    "images/next.svg",
                    package: WConstant.packageName,
                    width: 5.px,
                    color: WColor.C999999,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
