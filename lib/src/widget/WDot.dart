import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WDot extends StatelessWidget {
  final int count;
  final bool showCount;
  final Color bg;

  WDot({this.count = 0, this.showCount = false, this.bg});

  @override
  Widget build(BuildContext context) {
    return (count == null || count == 0)
        ? SizedBox()
        : (showCount
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 3.px),
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 14.px),
                height: 14.px,
                decoration: BoxDecoration(
                  color: bg ?? WColor.CF36969,
                  borderRadius: BorderRadius.circular(7.px),
                ),
                child: WText(count > 99 ? '···' : '$count',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.px, color: Colors.white)),
              )
            : Container(
                width: 6.px,
                height: 6.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.px),
                  color: WColor.CF36969,
                ),
              ));
  }
}
