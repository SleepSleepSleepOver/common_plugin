import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum BtnTheme { normal, flat, border }

class WCard extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double corner;
  final Color color;
  final Color shadowColor;
  final Function onPressedCallBack;
  final Widget child;

  WCard({
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.corner,
    this.color,
    this.shadowColor,
    this.onPressedCallBack,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressedCallBack?.call,
      child: Container(
        width: width,
        height: height,
        margin:
            margin ?? EdgeInsets.only(left: 10.px, right: 10.px, bottom: 10.px),
        padding: padding ?? EdgeInsets.all(16.px),
        decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(corner ?? 3.px),
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? Color(0x1A1E4A95),
                offset: Offset(0, 1.px),
                blurRadius: 2.px,
              )
            ]),
        child: child,
      ),
    );
  }
}
