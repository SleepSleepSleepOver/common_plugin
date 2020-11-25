import 'dart:ui';

import 'package:common_plugin/src/res/WColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CustomAppBar.dart';

class FullBasePage extends StatelessWidget {
  final Key mKey;
  final String title;
  final Color titleColor;
  final Color titleBackgroundColor;
  final AssetImage backGroundImage;
  final Widget leftWidget;
  final Widget centerWidget;
  final Widget rightWidget;
  final double marginTop;
  final Widget child;
  final bool statusStyleDark;
  final Color backgroundColor;
  final Function leftCallBack;
  final bool resizeToBottomInset;
  final bool hideDivide;
  final double height;

  FullBasePage({
    this.title,
    this.mKey,
    this.leftWidget,
    this.leftCallBack,
    this.centerWidget,
    this.rightWidget,
    this.backgroundColor,
    this.titleColor,
    this.titleBackgroundColor,
    this.backGroundImage,
    this.marginTop,
    this.statusStyleDark = true,
    this.resizeToBottomInset = false,
    this.hideDivide,
    this.height,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mKey,
      backgroundColor: backgroundColor ?? WColor.CF8F9FA,
      resizeToAvoidBottomInset: resizeToBottomInset,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusStyleDark
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: Column(
          children: <Widget>[
            CustomAppBar(
              contentTitle: title,
              contentTitleColor: titleColor,
              backColor: titleBackgroundColor,
              backGroundImage: backGroundImage,
              leftWidget: leftWidget,
              centerWidget: centerWidget,
              rightWidget: rightWidget,
              leftCallBack: leftCallBack,
              hideDivide: hideDivide,
              height: height,
              marginTop: marginTop,
            ),
            Expanded(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
