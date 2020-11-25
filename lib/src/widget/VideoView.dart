import 'dart:async';
import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart' as REG;
import 'package:agora_rtc_engine/rtc_local_view.dart' as LV;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RV;
import 'package:common_plugin/common_plugin.dart';
import 'package:common_plugin/src/utils/CommonUtils.dart';
import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:common_plugin/src/widget/WText.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screen/screen.dart';

class VideoView extends StatefulWidget {
  final String addID;
  final String channelName;
  VideoView(this.addID, this.channelName, {Key key}) : super(key: key);
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  double mDx = 0;
  double mDy = 0;
  double mHeight = SizeUtils.screenH;
  double mWidth = SizeUtils.screenW;
  bool fullScreen = true;

  Timer _timer;
  String timeString = "00:00:00";
  // 放大的索引
  int clickIndex = -1;
  // 是否交换大小窗口(只适用于两人通话)
  bool exchange = false;
  final _remoteUsers = List<int>();
  List<Widget> _widgetList = [];
  StateSetter mSetState;
  StateSetter sSetState;
  REG.RtcEngine re;

  @override
  void initState() {
    super.initState();
    FBroadcast.instance().register(WConstant.VIDEOEND, (value, callback) {
      Screen.keepOn(false);
      if (_timer != null) {
        _timer.cancel();
      }
      _timer = null;
      if (re != null) {
        re.leaveChannel();
        re.stopPreview();
        Future.delayed(Duration(seconds: 1), () {
          re.destroy();
        });
      }
    }, context: this);

    REG.RtcEngine.create(widget.addID).then((_) {
      re = _;
      re.enableVideo();
      re.enableAudio();
      re.setCameraAutoFocusFaceModeEnabled(true);
      re.setChannelProfile(REG.ChannelProfile.Communication);
      REG.VideoEncoderConfiguration config = REG.VideoEncoderConfiguration();
      config.orientationMode = REG.VideoOutputOrientationMode.FixedPortrait;
      re.setVideoEncoderConfiguration(config);
      REG.RtcEngineEventHandler rtcEH = REG.RtcEngineEventHandler();
      rtcEH.leaveChannel = (REG.RtcStats rs) {
        _remoteUsers.clear();
        if (mounted) mSetState(() {});
      };
      rtcEH.userJoined = (int uid, int elapsed) {
        _remoteUsers.add(uid);
        CommonUtils.antiShake(() {
          if (mounted) mSetState(() {});
        });
      };
      rtcEH.userOffline = (int uid, REG.UserOfflineReason reason) {
        _remoteUsers.remove(uid);
        CommonUtils.antiShake(() {
          if (mounted) mSetState(() {});
          if (_remoteUsers.length == 0)
            FBroadcast.instance().broadcast(WConstant.VIDEOEND);
        });
      };
      re.setEventHandler(rtcEH);
      re.startPreview();
      re.joinChannel(null, widget.channelName, null, 0);
    }).catchError((err) {});

    Screen.keepOn(true);
    _widgetList = [
      SizedBox(width: mWidth, height: mHeight),
      _viewRows(),
      _btns()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: mDx,
      top: mDy,
      width: mWidth,
      height: mHeight,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(42, 43, 49, 1.0),
        body: Stack(
          children: <Widget>[
            Stack(children: _widgetList),
            Offstage(
              offstage: fullScreen,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    mDx = details.globalPosition.dx - mWidth / 2;
                    mDy = details.globalPosition.dy - mHeight / 2;
                    if (mDx < 0) mDx = 0;
                    if (mDy < 0) mDy = 0;
                    if (mDx > SizeUtils.screenW - mWidth)
                      mDx = SizeUtils.screenW - mWidth;
                    if (mDy > SizeUtils.screenH - mHeight)
                      mDy = SizeUtils.screenH - mHeight;
                  });
                },
                onTap: () {
                  if (!fullScreen) {
                    mDx = 0;
                    mDy = 0;
                    mHeight = SizeUtils.screenH;
                    mWidth = SizeUtils.screenW;
                    fullScreen = true;
                    setState(() {});
                    mSetState(() {});
                    sSetState(() {});
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  width: mWidth,
                  height: mHeight,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//视频控制按钮
  Widget _btns() {
    return Stateful(
      builder: (BuildContext context, StateSetter state, Map data) {
        sSetState = state;
        if (_timer == null) {
          int _time = 0;
          _timer = Timer.periodic(Duration(seconds: 1), (interval) {
            sSetState(() {
              _time++;
              timeString = DateUtil.formatDateMs(_time * 1000,
                  isUtc: true, format: DateFormats.h_m_s);
            });
          });
        }
        return Offstage(
          offstage: !fullScreen,
          child: Container(
            width: SizeUtils.screenW,
            padding: EdgeInsets.only(bottom: 20.px + SizeUtils.bottomBar),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20.px),
                  child: WText(
                    timeString,
                    style: TextStyle(fontSize: 15.px, color: Colors.white),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () => re.switchCamera(),
                        child: Container(
                            width: 68.px,
                            height: 100.px,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 68.px,
                                      height: 68.px,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Color(0xFFFFFFFF),
                                              width: 1),
                                          color: Colors.transparent),
                                    ),
                                    Center(
                                        child: Image.asset(
                                            "images/switching_thecamera_head.png",
                                            width: 36.px)),
                                  ],
                                ),
                                WText("切换摄像头",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.px,
                                      height: 2,
                                    )),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            FBroadcast.instance().broadcast(WConstant.VIDEOEND),
                        child: Container(
                            width: 68.px,
                            height: 100.px,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 68.px,
                                      height: 68.px,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xfffa5051)),
                                    ),
                                    Center(
                                        child: Image.asset(
                                            "images/hold-down.png",
                                            width: 36.px)),
                                  ],
                                ),
                                WText("挂断",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.px,
                                      height: 2,
                                    )),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          fullScreen = false;
                          mHeight = SizeUtils.screenW / 27 * 16;
                          mWidth = SizeUtils.screenW / 3;
                          mDx = SizeUtils.screenW - mWidth;
                          mDy = SizeUtils.screenH - mHeight;
                          sSetState(() {});
                          setState(() {});
                          mSetState(() {});
                        },
                        child: Container(
                            width: 68.px,
                            height: 100.px,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 68.px,
                                      height: 68.px,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Color(0xFFFFFFFF),
                                              width: 1),
                                          color: Colors.transparent),
                                    ),
                                    Center(
                                        child: Image.asset(
                                            "images/view_patient_details.png",
                                            width: 36.px)),
                                  ],
                                ),
                                WText("查看患者资料",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.px,
                                      height: 2,
                                    )),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Iterable<Widget> get _renderWidget sync* {
    yield LV.SurfaceView();
    for (final uid in _remoteUsers) {
      yield RV.SurfaceView(uid: uid);
    }
  }

  Widget _viewRows() {
    return Stateful(
      builder: (BuildContext context, StateSetter state, Map data) {
        mSetState = state;
        List<Widget> views = _renderWidget.toList();
        switch (views.length) {
          case 1:
            return views[0];
          case 2:
            return Stack(children: <Widget>[
              views[exchange ? 0 : 1],
              Positioned(
                child: Offstage(
                  offstage: !fullScreen,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: views[exchange ? 1 : 0],
                        height: SizeUtils.screenW / 27 * 16,
                        width: SizeUtils.screenW / 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (fullScreen)
                            mSetState(() {
                              exchange = !exchange;
                            });
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: SizeUtils.screenW / 27 * 16,
                          width: SizeUtils.screenW / 3,
                        ),
                      )
                    ],
                  ),
                ),
                right: 0,
                top: SizeUtils.statusBar,
              )
            ]);
          default:
            return Wrap(
              children: getWrapItems(views),
            );
        }
      },
    );
  }

  List<Widget> getWrapItems(List<Widget> items) {
    List<Widget> temps = [];
    double itemWidth = items.length >= 5 ? mWidth / 3.0 : mWidth / 2.0;
    for (int i = 0; i < items.length; i++) {
      if (clickIndex == -1)
        temps.add(smallVideoItem(i, items, itemWidth));
      else {
        if (clickIndex == i)
          temps.add(smallVideoItem(i, items, mWidth));
        else
          temps.add(smallVideoItem(i, items, 1));
      }
    }
    return temps;
  }

  Widget smallVideoItem(int index, List oriViews, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: <Widget>[
          oriViews[index],
          GestureDetector(
            onTap: () {
              if (fullScreen)
                mSetState(() {
                  if (clickIndex == -1) {
                    clickIndex = index;
                  } else {
                    clickIndex = -1;
                  }
                });
            },
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }
}
