import 'package:common_plugin/common_plugin.dart';
import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum NaviType { inside, outside }

class WTabNavi extends StatelessWidget {
  final double width;
  final double height;
  final Color textColorSelect;
  final Color textColorUnSelect;
  final double textSelectSize;
  final bool textSelectBold;
  final bool textNormalBold;
  final double textLRMargin;
  final Color lineColorSelectStart;
  final Color lineColorSelectMid1;
  final Color lineColorSelectMid2;
  final Color lineColorSelectEnd;
  final Color lineColorUnSelect;
  final double lineHeight;
  final double lineWidth;
  final double lineBottom;
  final double lineCorner;
  final List<String> titles;
  final ValueNotifier<int> index;
  final NaviType type;
  final isCenter;
  final Function onTabCallback;

  WTabNavi(
    this.titles, {
    this.width,
    this.height,
    this.textColorSelect,
    this.textColorUnSelect,
    this.textSelectSize,
    this.textLRMargin,
    this.textNormalBold = true,
    this.textSelectBold = true,
    this.lineColorSelectStart,
    this.lineColorSelectMid1,
    this.lineColorSelectMid2,
    this.lineColorSelectEnd,
    this.lineColorUnSelect,
    this.lineHeight,
    this.lineWidth,
    this.lineBottom,
    this.lineCorner,
    this.index,
    this.isCenter = true,
    this.type = NaviType.outside,
    this.onTabCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, int value, Widget child) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: isCenter,
          scrollDirection: Axis.horizontal,
          itemCount: titles.length,
          itemBuilder: (_, int i) {
            return GestureDetector(
              onTap: () {
                onTabCallback?.call(i);
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  type == NaviType.outside
                      ? Container(
                          height: lineHeight ?? 3.px,
                          width: lineWidth ?? 20.px,
                          margin: EdgeInsets.only(bottom: lineBottom ?? 4.px),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              value == i
                                  ? (lineColorSelectStart ?? WColor.C628AF4)
                                  : (lineColorUnSelect ?? Colors.transparent),
                              value == i
                                  ? (lineColorSelectMid1 ??
                                      lineColorSelectStart ??
                                      WColor.C628AF4)
                                  : (lineColorUnSelect ?? Colors.transparent),
                              value == i
                                  ? (lineColorSelectMid2 ??
                                      lineColorSelectStart ??
                                      WColor.C566FF9)
                                  : (lineColorUnSelect ?? Colors.transparent),
                              value == i
                                  ? (lineColorSelectEnd ??
                                      lineColorSelectStart ??
                                      WColor.C566FF9)
                                  : (lineColorUnSelect ?? Colors.transparent),
                            ]),
                            borderRadius:
                                BorderRadius.circular(lineCorner ?? 2.px),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    height: height ?? 44.px,
                    width: width ?? null,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.px),
                    margin:
                        EdgeInsets.symmetric(horizontal: textLRMargin ?? 5.px),
                    decoration: type == NaviType.outside
                        ? BoxDecoration(color: Colors.transparent)
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(2.px),
                            shape: BoxShape.rectangle,
                            border: value == i
                                ? null
                                : Border.all(color: WColor.CECECEC),
                            gradient: LinearGradient(colors: [
                              value == i
                                  ? (lineColorSelectStart ?? WColor.C628AF4)
                                  : (lineColorUnSelect ?? Colors.transparent),
                              value == i
                                  ? (lineColorSelectEnd ??
                                      lineColorSelectStart ??
                                      WColor.C566FF9)
                                  : (lineColorUnSelect ?? Colors.transparent),
                            ]),
                          ),
                    child: WText(
                      titles[i],
                      style: TextStyle(
                        color: type == NaviType.outside
                            ? (value == i
                                ? (textColorSelect ?? WColor.C333333)
                                : (textColorUnSelect ?? WColor.C666666))
                            : (value == i
                                ? (textColorSelect ?? Colors.white)
                                : (textColorUnSelect ?? WColor.C999999)),
                        fontWeight: type == NaviType.outside
                            ? (value == i
                                ? (textSelectBold
                                    ? FontWeight.bold
                                    : FontWeight.normal)
                                : (textNormalBold
                                    ? FontWeight.bold
                                    : FontWeight.normal))
                            : FontWeight.normal,
                        fontSize: type == NaviType.outside
                            ? (value == i ? (textSelectSize ?? 16.px) : 14.px)
                            : 13.px,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      valueListenable: index,
    );
  }
}
