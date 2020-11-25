import 'package:bot_toast/bot_toast.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/material.dart';

import 'WLoading.dart';

class Toast {
  static toast(text) {
    dissMissLoading();
    BotToast.showText(
        text: text,
        contentColor: Color.fromRGBO(51, 51, 51, 0.8),
        textStyle:
            TextStyle(fontSize: 14.px, color: Colors.white, height: 10 / 7),
        borderRadius: BorderRadius.circular(2.px),
        contentPadding: EdgeInsets.symmetric(vertical: 8.px, horizontal: 16.px),
        align: Alignment.center);
  }

  static toastIndicator({text, clickClose = true, Widget widget, align}) {
    dissMissLoading();
    BotToast.showCustomLoading(
        clickClose: clickClose,
        animationDuration: const Duration(milliseconds: 150),
        animationReverseDuration: const Duration(milliseconds: 150),
        backgroundColor: Colors.transparent,
        align: align ?? Alignment.center,
        toastBuilder: (_) {
          return widget ??
              Container(
                  padding: EdgeInsets.all(12.px),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(51, 51, 51, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(4.px))),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WLoading(
                            width: 30.px,
                            height: 30.px,
                            loadingColor: Colors.white),
                        text == null
                            ? SizedBox(width: 5.px)
                            : Container(
                                padding: EdgeInsets.only(top: 4.px),
                                child: Text(text,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.px)))
                      ]));
        });
  }

  static dissMissLoading() {
    BotToast.closeAllLoading();
  }
}
