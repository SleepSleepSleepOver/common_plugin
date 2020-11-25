import 'package:common_plugin/common_plugin.dart';
import 'package:flutter/material.dart';

class WLine extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;

  WLine(
      {this.color,
      this.width,
      this.height = 0.5,
      this.marginLeft = 0.0,
      this.marginTop = 0.0,
      this.marginRight = 0.0,
      this.marginBottom = 0.0})
      : assert(marginLeft != null),
        assert(marginTop != null),
        assert(marginRight != null),
        assert(marginBottom != null);

  @override
  Widget build(BuildContext context) {
    if (width != null && height != null)
      return Container(
        width: width.px,
        height: height.px,
        margin: EdgeInsets.only(
            left: marginLeft ?? 0.0,
            top: marginTop ?? 0.0,
            right: marginRight ?? 0.0,
            bottom: marginBottom ?? 0.0),
        color: color ?? Color(0xffECECEC),
      );
    else if (width != null && height == null) {
      return Container(
        width: width.px,
        margin: EdgeInsets.only(
            left: marginLeft ?? 0.0,
            top: marginTop ?? 0.0,
            right: marginRight ?? 0.0,
            bottom: marginBottom ?? 0.0),
        color: color ?? Color(0xffECECEC),
      );
    } else if (width == null && height != null) {
      return Container(
        height: height.px,
        margin: EdgeInsets.only(
            left: marginLeft ?? 0.0,
            top: marginTop ?? 0.0,
            right: marginRight ?? 0.0,
            bottom: marginBottom ?? 0.0),
        color: color ?? Color(0xffECECEC),
      );
    } else
      // Divider();
      // VerticalDivider();
      return SizedBox();
  }
}
