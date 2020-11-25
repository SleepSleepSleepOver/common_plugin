import 'dart:io';

import 'package:common_plugin/common_plugin.dart';
import 'package:common_plugin/src/http/HttpUtils.dart';
import 'package:common_plugin/src/res/WColor.dart';
import 'package:common_plugin/src/res/WConstant.dart';
import 'package:common_plugin/src/utils/FileUtils.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/VideoView.dart';
import 'package:common_plugin/src/widget/WLoading.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:common_plugin/src/widget/WToast.dart';
import 'package:dio/dio.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  Widget body();
}

mixin HomeBasePage<T extends StatefulWidget> on BaseState<T> {
  UpgradeDialog mUpgradeDialog;
  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(WConstant.VIDEOSTART, (value, callback) {
      [Permission.camera, Permission.microphone].request().then((_) {
        if (_[Permission.camera].isGranted &&
            _[Permission.microphone].isGranted) {
          if (WConstant.overlayEntry != null) {
            Toast.toast("正在视频中，请勿重复发起");
          } else {
            WConstant.overlayEntry = OverlayEntry(builder: (ct) {
              return VideoView(value['appid'], value['channel']);
            });
            Overlay.of(context).insert(WConstant.overlayEntry);
            callback(true);
          }
        } else
          Toast.toast("请先在系统设置中打开相机及麦克风权限");
      });
    }, more: {
      WConstant.VIDEOEND: (value, callback) {
        if (WConstant.overlayEntry != null) {
          WConstant.overlayEntry.remove();
          WConstant.overlayEntry = null;
        }
      }
    }, context: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (WConstant.overlayEntry != null) {
          Toast.toast("请先结束视频通话");
          return Future.value(false);
        } else
          return Future.value(true);
      },
      child: body(),
    );
  }

  check(checkUrl, androidUrl, iosUrl, applicationId, appKey,
      {lcolor, rcolor, tcolor, bcolor, head}) {
    _checkUpdate(checkUrl, applicationId).then((data) {
      if (data.length == 0) return;
      PackageInfo.fromPlatform().then((package) {
        String local = package.version;
        List localNumber = local.split('.');
        String online = Platform.isAndroid
            ? data.first['androidVersion']
            : data.first['iosVersion'];
        List onLineNumber = online.split('.');
        // 同位比较
        bool haveUpdate = false;
        if (onLineNumber.length > localNumber.length) {
          haveUpdate = true;
        } else if (onLineNumber.length == localNumber.length) {
          // 同位比较
          for (var i = 0; i < onLineNumber.length; i++) {
            if (int.parse(onLineNumber[i].toString()) >
                int.parse(localNumber[i].toString())) {
              haveUpdate = true;
              break;
            } else if (int.parse(onLineNumber[i].toString()) ==
                int.parse(localNumber[i].toString())) {
              continue;
            } else {
              haveUpdate = false;
              break;
            }
          }
        }
        bool isMust = false;
        for (var map in data) {
          if (package.version ==
              (Platform.isAndroid
                  ? map['androidVersion']
                  : map['iosVersion'])) {
            isMust = map['isMust'];
            break;
          }
        }

        if (haveUpdate && mUpgradeDialog == null) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ct) {
                mUpgradeDialog = UpgradeDialog(
                  ct,
                  ver: online,
                  content: data.first['content'],
                  cancelHide: isMust,
                  lColor: lcolor,
                  rColor: rcolor,
                  tColor: tcolor,
                  bColor: bcolor,
                  head: head,
                );
                return WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: mUpgradeDialog);
              }).then((value) {
            if (value) _checkConfirm(androidUrl, appKey, iosUrl);
            mUpgradeDialog = null;
          });
        }
      });
    });
  }

  Future _checkUpdate(url, applicationId) {
    return HttpUtils(needAuthor: false).post(
      url,
      data: {"applicationId": applicationId},
    ).then((obj) {
      return obj["results"] ?? [];
    });
  }

  Future _checkUpdateAndriod(url, appKey) {
    Options options = Options();
    options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    return HttpUtils(needAuthor: false)
        .post(url,
            queryParameters: {
              "_api_key": "bc474f4e301625c77cb96ddf8c9192b1",
              "appKey": appKey
            },
            options: options)
        .then((obj) {
      return obj["data"];
    });
  }

  _checkConfirm(androidUrl, appKey, iosUrl) {
    if (Platform.isAndroid) {
      int percent = 0;
      StateSetter mSetState;
      Toast.toastIndicator(
          widget: Stateful(
            builder: (BuildContext context, StateSetter setState, Map data) {
              mSetState = setState;
              return Container(
                  padding: EdgeInsets.all(10.px),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(51, 51, 51, 0.6),
                      borderRadius: BorderRadius.all(Radius.circular(4.px))),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WLoading(
                            width: 30.px,
                            height: 30.px,
                            loadingColor: Colors.white),
                        Container(
                            padding: EdgeInsets.only(top: 4.px),
                            child: Text('正在下载$percent%',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.px)))
                      ]));
            },
          ),
          clickClose: false);
      _checkUpdateAndriod(androidUrl, appKey).then((data) {
        _downloadFile(data["downloadURL"], "sljt.apk", (int count, int total) {
          mSetState(() {
            percent = (count / total * 100).toInt();
          });
        }).then((response) {
          Toast.dissMissLoading();
          FileUtils().getApkPath("sljt.apk").then((path) {
            if (path.isEmpty) {
              return;
            }
            OpenFile.open(path);
          });
        }).catchError((onError) {
          Toast.toast("下载失败！${onError.toString()}");
        });
      });
    } else {
      launch(iosUrl);
    }
  }

  Future _downloadFile(
      String urlPath, String savePath, ProgressCallback onReceiveProgress) {
    return FileUtils().getApkPath(savePath).then((path) {
      return HttpUtils(needAuthor: false)
          .downloadFile(urlPath, path, onReceiveProgress: onReceiveProgress);
    });
  }

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }
}

class UpgradeDialog extends Dialog {
  final String ver;
  final String content;
  final Color lColor;
  final Color rColor;
  final Color tColor;
  final Color bColor;
  final Widget head;
  final bool cancelHide;
  final BuildContext ct;
  UpgradeDialog(this.ct,
      {this.ver,
      this.content,
      this.head,
      this.lColor,
      this.rColor,
      this.tColor,
      this.bColor,
      this.cancelHide = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.px,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.px),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              head ??
                  Image.asset(
                    "images/bg_upgrade.png",
                    package: 'common_plugin',
                  ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.px),
                  WText(
                    "发现新版本",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.px,
                        fontWeight: FontWeight.w600,
                        height: 1),
                  ),
                  SizedBox(height: 12.px),
                  WText(
                    'v' + ver,
                    style: TextStyle(
                        color: Colors.white, fontSize: 14.px, height: 1),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 105.px),
                  Container(
                    padding: EdgeInsets.only(
                        left: 24.px, right: 24.px, bottom: 12.px),
                    child: WText(
                      '更新内容',
                      style: TextStyle(
                          color: WColor.C333333, fontSize: 15.px, height: 1),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 24.px, right: 24.px, bottom: 28.px),
                    child: WText(
                      content ?? "",
                      style: TextStyle(
                          color: WColor.C333333,
                          fontSize: 15.px,
                          height: 22 / 15),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24.px),
                      cancelHide
                          ? SizedBox()
                          : Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bColor ??
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.08),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4.px))),
                                height: 42.px,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.pop(ct, false);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.px))),
                                  child: WText(
                                    '稍后再说',
                                    softWrap: false,
                                    style: TextStyle(
                                      color: tColor ??
                                          Theme.of(context).primaryColor,
                                      fontSize: 16.px,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      cancelHide ? SizedBox() : SizedBox(width: 20.px),
                      Expanded(
                        child: Container(
                          height: 42.px,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.px)),
                              gradient: LinearGradient(colors: [
                                (lColor ?? Theme.of(context).primaryColor),
                                (rColor ??
                                    lColor ??
                                    Theme.of(context).primaryColor)
                              ])),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(ct, true);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.px))),
                            child: WText(
                              '立即更新',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.px),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.px),
                    ],
                  ),
                  SizedBox(height: 30.px),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
