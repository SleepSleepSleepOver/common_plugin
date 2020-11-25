import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/res/WConstant.dart';
import 'package:common_plugin/src/utils/RouteHelper.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum DGTheme { normal, input }
enum InputType { NAME, PHONE }

//ct为showDialog的context，必传，且需区别于父页面的context，代表外层dialog的BuildContext
class WDialog extends Dialog {
  final BuildContext ct;
  final String title;
  final String content;
  final Widget other;
  final Function(dynamic text) onConfirm;
  final Function(dynamic text) onCancel;
  final String cancelTitle;
  final String confirmTitle;
  final String hintText;
  final Color confirmColor;
  final bool cancelHide;
  final int maxLength;
  final InputType inputType;
  final List
      textInputFormatter; //自定义多个正则，例如FilteringTextInputFormatter.allow(RegExp(r'^(0|\+?[1-9][0-9]*)$'))
  final DGTheme type;
  final TextEditingController _useCcontroller =
      TextEditingController.fromValue(TextEditingValue());
  WDialog(this.ct,
      {Key key,
      this.title,
      this.content,
      this.other,
      this.onConfirm,
      this.onCancel,
      this.cancelTitle = "取消",
      this.confirmTitle = "确定",
      this.hintText,
      this.confirmColor,
      this.cancelHide = false,
      this.maxLength = -1,
      this.inputType,
      this.textInputFormatter,
      this.type = DGTheme.normal})
      : super(key: key) {}
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (btContext, state) {
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 227.px,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.px),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(height: 22.px),
                  Offstage(
                    offstage: title == null,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 15.px, right: 15.px, bottom: 18.px),
                      alignment: Alignment.center,
                      child: WText(
                        title ?? "",
                        style: TextStyle(
                            color: WColor.C333333,
                            fontSize: 16.px,
                            fontWeight: FontWeight.w600,
                            height: 1),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: content == null,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 15.px, right: 15.px, bottom: 18.px),
                      alignment: Alignment.center,
                      child: WText(
                        content ?? "",
                        style: TextStyle(
                            color: WColor.C333333,
                            fontSize: 14.px,
                            height: 10 / 7),
                      ),
                    ),
                  ),
                  other ??
                      (type == DGTheme.input
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: 15.px, right: 15.px, bottom: 15.px),
                              padding: EdgeInsets.symmetric(horizontal: 8.px),
                              alignment: Alignment.center,
                              height: 30.px,
                              decoration: BoxDecoration(
                                border: Border.all(color: WColor.CCCCCCC),
                                borderRadius: BorderRadius.circular(3.px),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: _useCcontroller,
                                      autofocus: true,
                                      maxLength:
                                          maxLength <= 0 ? null : maxLength,
                                      style: TextStyle(
                                        color: WColor.C333333,
                                        fontSize: 14.px,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        counterText: '',
                                        isDense: true,
                                        hintText: hintText ?? "请填写...",
                                        hintStyle: TextStyle(
                                          color: WColor.CCCCCCC,
                                          fontSize: 14.px,
                                        ),
                                      ),
                                      keyboardType: inputType == InputType.PHONE
                                          ? TextInputType.phone
                                          : TextInputType.text,
                                      inputFormatters:
                                          inputType == InputType.PHONE
                                              ? <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      11)
                                                ]
                                              : (textInputFormatter ??
                                                  <TextInputFormatter>[]),
                                      onChanged: (s) {},
                                    ),
                                  ),
                                  Offstage(
                                    offstage: _useCcontroller.text.length == 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        state(() {
                                          _useCcontroller.text = '';
                                        });
                                      },
                                      child: SvgPicture.asset(
                                          "images/ic_del.svg",
                                          package: WConstant.packageName,
                                          width: 17.px),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox()),
                  Container(height: 4.px),
                  Container(height: 0.8.px, color: WColor.CE9E9E9),
                  Row(
                    children: <Widget>[
                      cancelHide
                          ? SizedBox()
                          : Expanded(
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  RouteHelper.maybePop(ct, false).then((_) {
                                    handleCallBack(onCancel);
                                  });
                                },
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5.px)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44.px,
                                  child: WText(
                                    cancelTitle,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: WColor.C999999,
                                      fontSize: 14.px,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      cancelHide
                          ? SizedBox()
                          : Container(
                              height: 44.px,
                              width: 0.8.px,
                              color: WColor.CE9E9E9),
                      Expanded(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            RouteHelper.maybePop(ct, true).then((_) {
                              handleCallBack(onConfirm,
                                  content: _useCcontroller.text);
                            });
                          },
                          borderRadius: BorderRadius.only(
                              bottomLeft: cancelHide
                                  ? Radius.circular(5.px)
                                  : Radius.circular(0),
                              bottomRight: Radius.circular(5.px)),
                          child: Container(
                            alignment: Alignment.center,
                            height: 44.px,
                            child: WText(
                              confirmTitle,
                              style: TextStyle(
                                  color: confirmColor ??
                                      Theme.of(context).primaryColor,
                                  fontSize: 14.px),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

handleCallBack(Function callBack, {String content}) {
  if (callBack != null) {
    callBack(content);
  }
}
