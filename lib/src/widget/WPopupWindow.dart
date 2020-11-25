import 'package:bot_toast/bot_toast.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WPopupWindow {
  static bool _isShow = false;
  static show(
    Widget widget, {
    Offset target,
    BuildContext targetContext,
    double width,
    double height,
    double radius,
    Offset shadowOffset,
    Color shadowColor,
    PreferDirection preferDirection,
    double verticalOffset,
    double horizontalOffset,
  }) {
    if (_isShow) {
      BotToast.removeAll(BotToast.attachedKey);
    } else {
      _isShow = true;
      BotToast.showAttachedWidget(
          attachedBuilder: (_) {
            return Container(
              width: width ?? 80.px,
              height: height ?? 90.px,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius ?? 4.px),
                  boxShadow: [
                    BoxShadow(
                        color: shadowColor ?? Color(0x245F77FA),
                        blurRadius: radius ?? 4.px,
                        offset: shadowOffset ?? Offset(0, 2.px))
                  ]),
              child: widget,
            );
          },
          preferDirection: preferDirection ?? PreferDirection.bottomCenter,
          targetContext: targetContext,
          target: target,
          allowClick: false,
          verticalOffset: verticalOffset ?? 0,
          horizontalOffset: horizontalOffset ?? 0,
          onClose: () {
            _isShow = false;
          });
    }
  }
}
