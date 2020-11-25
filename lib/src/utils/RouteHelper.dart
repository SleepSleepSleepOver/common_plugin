import 'package:flutter/material.dart';

class RouteHelper {
  //打开新页面
  static Future<T> pushWidget<T>(BuildContext context, Widget widget) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => widget,
            settings: RouteSettings(name: widget.toString())));
  }

  //打开页面，并且关闭新页面和老页面之间的页面，老页面如果是初始页面，则initpage为true，老页面widget不传
  static Future<T> pushAndRemoveUntil<T>(BuildContext context, Widget newWidget,
      {Widget baseWidget, bool initpage = true}) {
    assert(!(baseWidget == null && initpage == false));
    if (baseWidget != null) initpage = false;
    if (initpage)
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => newWidget),
          (route) => route.isFirst);
    else
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => newWidget),
          (route) => route.settings.name == baseWidget.toString());
  }

  //打开新页面，并且替换当前页面
  static Future<T> pushReplacement<T>(BuildContext context, Widget newWidget) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => newWidget),
    );
  }

  //关闭页面，无法关闭则无操作
  static Future<bool> maybePop<T>(BuildContext context, [T result]) {
    return Navigator.maybePop(context, result);
  }

  //关闭指定页面上层的所有页面，指定页面如果是初始页面，则initpage为true，老页面widget不传
  static popUntil(BuildContext context,
      {Widget baseWidget, bool initpage = true}) {
    assert(!(baseWidget == null && initpage == false));
    if (baseWidget != null) initpage = false;
    if (initpage)
      Navigator.popUntil(context, (route) => route.isFirst);
    else
      Navigator.popUntil(
          context, (route) => route.settings.name == baseWidget.toString());
  }

  //移除指定页面
  static removeRoute(BuildContext context, Widget widget) {
    Navigator.removeRoute(context, MaterialPageRoute(builder: (ctx) => widget));
  }

  //移除指定页面
  static removeRouteBelow(BuildContext context, Widget widget) {
    Navigator.removeRouteBelow(
        context, MaterialPageRoute(builder: (ctx) => widget));
  }

  //替换指定页面
  static replace(BuildContext context, Widget oldWidget, Widget newWidget) {
    Navigator.replace(context,
        oldRoute: MaterialPageRoute(builder: (ctx) => oldWidget),
        newRoute: MaterialPageRoute(builder: (ctx) => newWidget));
  }

  //替换指定页面
  static replaceRouteBelow(
      BuildContext context, Widget anchorWidget, Widget newWidget) {
    Navigator.replaceRouteBelow(context,
        anchorRoute: MaterialPageRoute(builder: (ctx) => anchorWidget),
        newRoute: MaterialPageRoute(builder: (ctx) => newWidget));
  }
}
