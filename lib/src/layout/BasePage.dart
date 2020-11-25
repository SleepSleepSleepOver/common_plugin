import 'package:common_plugin/common_plugin.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WLoading.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/WColor.dart';

enum Status {
  LOADING,
  NONE,
  EMPTY,
  ERROR,
}

class BasePage extends StatelessWidget {
  final Status status;
  final Widget child;
  final String hint;
  final double minHeight;
  final Widget loadingWidget;
  final String emptyHint;
  final Widget emptyWidget;
  final String errorHint;
  final Widget errorWidget;
  final bool enableRefresh;
  final List<Widget> _childrens = [];

  BasePage({
    @required this.child,
    this.status,
    this.hint,
    this.minHeight,
    this.loadingWidget,
    this.emptyHint,
    this.emptyWidget,
    this.errorHint,
    this.errorWidget,
    this.enableRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    _childrens.clear();
    switch (status) {
      case Status.LOADING:
        _childrens.add(
          Container(
            constraints: BoxConstraints(minHeight: minHeight ?? 0),
            alignment: Alignment.center,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              loadingWidget ?? WLoading(width: 30.px, height: 30.px),
              WText(
                "${(hint != null && hint != '') ? (hint + '\n') : '加载中...'}",
                style: TextStyle(
                    fontSize: 15.px, color: WColor.C666666, height: 2),
              )
            ]),
          ),
        );
        break;
      case Status.EMPTY:
        _childrens.add(
          Container(
            constraints: BoxConstraints(minHeight: minHeight ?? 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                emptyWidget ?? WAssets.empty,
                Padding(
                  padding: EdgeInsets.only(top: 10.px),
                  child: WText(
                    "${(emptyHint != null && emptyHint != '') ? (emptyHint + '\n') : '暂无数据'}",
                    style: TextStyle(fontSize: 14.px, color: WColor.CDBDBDB),
                  ),
                )
              ],
            ),
          ),
        );
        _childrens.add(
          ListView(
            physics: enableRefresh ? null : NeverScrollableScrollPhysics(),
            children: <Widget>[],
          ),
        );
        break;
      case Status.ERROR:
        _childrens.add(
          Container(
            constraints: BoxConstraints(minHeight: minHeight ?? 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                errorWidget ?? WAssets.netError,
                Padding(
                  padding: EdgeInsets.only(top: 10.px),
                  child: WText(
                    "${(errorHint != null && errorHint != '') ? (errorHint + '\n') : '服务或网络异常'}",
                    style: TextStyle(fontSize: 14.px, color: WColor.CDBDBDB),
                  ),
                )
              ],
            ),
          ),
        );
        _childrens.add(
          //不要在这使用future类型的回调，外部无法携带参数！！！需要刷新的在业务页面独立外包RefreshIndicator
          ListView(
            physics: enableRefresh ? null : NeverScrollableScrollPhysics(),
            children: <Widget>[],
          ),
        );
        break;
      default:
        _childrens.add(child);
        break;
    }

    return Stack(children: _childrens);
  }
}
