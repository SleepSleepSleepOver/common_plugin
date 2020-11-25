import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/res/WStyle.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum BtnTheme { normal, flat, border }

class WButton extends StatelessWidget {
  final double width;
  final double height;
  final double corner;
  final String text;
  final double fontSize;
  final Widget image;
  final Color color;
  final Color textColor;
  final Color endColor;
  final Color disableColor;
  final Color disableTextColor;
  final bool enable;
  final BtnTheme theme;
  final bool isBold;
  final Function onPressedCallBack;

  WButton({
    this.width,
    this.height,
    this.corner,
    this.text,
    this.fontSize,
    this.image,
    this.disableColor,
    this.disableTextColor,
    this.color,
    this.textColor,
    this.endColor,
    this.theme = BtnTheme.normal,
    this.isBold = true,
    this.enable = true,
    this.onPressedCallBack,
  });

  @override
  Widget build(BuildContext context) {
    switch (theme) {
      case BtnTheme.normal:
        return RaisedButton(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(corner ?? 4.px),
          ),
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                enable
                    ? (color ?? Theme.of(context).primaryColor)
                    : (disableColor ?? WColor.CCCCCCC),
                enable
                    ? (endColor ?? color ?? Theme.of(context).primaryColor)
                    : (disableColor ?? WColor.CCCCCCC)
              ])),
              height: height ?? 48.px,
              width: width,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                image != null
                    ? Container(
                        child: image,
                        margin: EdgeInsets.only(right: 6.px),
                      )
                    : SizedBox(),
                WText(
                  text ?? '',
                  style: WStyle.base(
                      size: fontSize ?? 16.px,
                      isBold: isBold,
                      color: enable
                          ? (textColor ?? Colors.white)
                          : (disableTextColor ?? Colors.white)),
                ),
              ])),
          onPressed: enable ? onPressedCallBack?.call : null,
        );
      case BtnTheme.flat:
        return FlatButton(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(corner ?? 4.px),
          ),
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                enable
                    ? (color ?? Theme.of(context).primaryColor)
                    : (disableColor ?? WColor.CCCCCCC),
                enable
                    ? (endColor ?? color ?? Theme.of(context).primaryColor)
                    : (disableColor ?? WColor.CCCCCCC)
              ])),
              height: height ?? 48.px,
              width: width,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                image != null
                    ? Container(
                        child: image,
                        margin: EdgeInsets.only(right: 6.px),
                      )
                    : SizedBox(),
                WText(
                  text ?? '',
                  style: WStyle.base(
                      size: fontSize ?? 16.px,
                      isBold: isBold,
                      color: enable
                          ? (textColor ?? Colors.white)
                          : (disableTextColor ?? Colors.white)),
                ),
              ])),
          onPressed: enable ? onPressedCallBack?.call : null,
        );
      case BtnTheme.border:
        return FlatButton(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(corner ?? 4.px),
              side: BorderSide(
                  color: enable
                      ? (color ?? Theme.of(context).primaryColor)
                      : WColor.CCCCCCC)),
          onPressed: enable ? onPressedCallBack?.call : null,
          child: Container(
              height: height ?? 48.px,
              width: width,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                image != null
                    ? Container(
                        child: image,
                        margin: EdgeInsets.only(right: 6.px),
                      )
                    : SizedBox(),
                WText(
                  text ?? '',
                  style: WStyle.base(
                      size: fontSize ?? 16.px,
                      isBold: isBold,
                      color: enable
                          ? (textColor ??
                              color ??
                              Theme.of(context).primaryColor)
                          : (disableTextColor ?? WColor.CCCCCCC)),
                ),
              ])),
        );
    }
  }
}
