import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/res/WConstant.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String contentTitle;
  final bool hideDivide;
  final double height;
  final Color backColor;
  final Color contentTitleColor;
  final AssetImage backGroundImage;
  final double marginTop;
  final Widget leftWidget;
  final Widget centerWidget;
  final Widget rightWidget;
  final Function leftCallBack;

  CustomAppBar(
      {this.contentTitle,
      this.height,
      this.backColor,
      this.contentTitleColor,
      this.hideDivide,
      this.backGroundImage,
      this.marginTop,
      this.leftWidget,
      this.centerWidget,
      this.rightWidget,
      this.leftCallBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: height ?? 44.px + SizeUtils.statusBar,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: SizeUtils.statusBar),
          decoration: backGroundImage == null
              ? BoxDecoration(color: backColor ?? Colors.white)
              : BoxDecoration(
                  image: DecorationImage(
                      image: backGroundImage, fit: BoxFit.cover)),
          child: Container(
            height: 44.px,
            margin: EdgeInsets.only(top: marginTop ?? 0),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40.px),
                  child: centerWidget ??
                      WText(
                        contentTitle ?? '',
                        style: TextStyle(
                            fontSize: 18.px,
                            color: contentTitleColor ?? WColor.C333333,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                ),
                leftWidget ??
                    GestureDetector(
                      onTap: () {
                        if (leftCallBack == null) {
                          Navigator.pop(context);
                        } else {
                          leftCallBack.call();
                        }
                      },
                      child: Container(
                        width: 40.px,
                        padding: EdgeInsets.only(left: 12.px),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        child: Image.asset(
                          "images/_return.png",
                          package: WConstant.packageName,
                          height: 17.px,
                          color: contentTitleColor ?? WColor.C666666,
                        ),
                      ),
                    ),
                Container(
                  alignment: Alignment.centerRight,
                  child: rightWidget,
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: hideDivide ?? true,
          child: FDottedLine(
            color: WColor.CE9E9E9,
            width: SizeUtils.screenW,
            strokeWidth: 0.6.px,
            space: 0.0,
          ),
        ),
      ],
    );
  }
}
