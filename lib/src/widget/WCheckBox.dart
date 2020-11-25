import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/res/WConstant.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CBType { circle, rectangle }

class WCheckBox extends StatelessWidget {
  final double width;
  final double height;
  final Color selectColorStart;
  final Color selectColorEnd;
  final bool select;
  final bool enable;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final CBType type;
  final Function onChange;

  WCheckBox(this.onChange,
      {this.width,
      this.height,
      this.select,
      this.enable = true,
      this.paddingLeft,
      this.paddingRight,
      this.paddingTop,
      this.paddingBottom,
      this.type = CBType.circle,
      this.selectColorStart,
      this.selectColorEnd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enable) onChange?.call(!select);
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: paddingLeft ?? 24.px,
            right: paddingRight ?? 24.px,
            top: paddingTop ?? 10.px,
            bottom: paddingBottom ?? 10.px),
        child: select
            ? (enable
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      type == CBType.circle
                          ? Container(
                              width: width ?? 20.px,
                              height: width ?? 20.px,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  selectColorStart ?? WColor.C628AF4,
                                  selectColorEnd ??
                                      selectColorStart ??
                                      WColor.C566FF9
                                ]),
                              ),
                            )
                          : Container(
                              width: width ?? 20.px,
                              height: width ?? 20.px,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.px),
                                gradient: LinearGradient(colors: [
                                  selectColorStart ?? WColor.C628AF4,
                                  selectColorEnd ??
                                      selectColorStart ??
                                      WColor.C566FF9
                                ]),
                              ),
                            ),
                      SvgPicture.asset(
                        'images/ic_g.svg',
                        package: WConstant.packageName,
                        width: width != null ? width / 20.px * 13.px : 13.px,
                        height: width != null ? width / 20.px * 13.px : 13.px,
                      )
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        type == CBType.circle
                            ? 'images/ic_r_unchecked_disable.svg'
                            : 'images/ic_f_unchecked_disable.svg',
                        package: WConstant.packageName,
                        width: width ?? 20.px,
                        height: width ?? 20.px,
                      ),
                      SvgPicture.asset(
                        'images/ic_g.svg',
                        package: WConstant.packageName,
                        width: width != null ? width / 20.px * 13.px : 13.px,
                        height: width != null ? width / 20.px * 13.px : 13.px,
                      )
                    ],
                  ))
            : (enable
                ? (type == CBType.circle
                    ? Container(
                        width: width ?? 20.px,
                        height: width ?? 20.px,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: WColor.CCCCCCC, width: 1.px)),
                      )
                    : Container(
                        width: width ?? 20.px,
                        height: width ?? 20.px,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.px),
                            color: Colors.white,
                            border:
                                Border.all(color: WColor.CCCCCCC, width: 1.px)),
                      ))
                : SvgPicture.asset(
                    type == CBType.circle
                        ? 'images/ic_r_unchecked_disable.svg'
                        : 'images/ic_f_unchecked_disable.svg',
                    package: WConstant.packageName,
                    width: width ?? 20.px,
                    height: width ?? 20.px,
                  )),
      ),
    );
  }
}
