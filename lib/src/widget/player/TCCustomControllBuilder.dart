import 'dart:async';

import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencentplayer/controller/tencent_player_controller.dart';
import 'package:flutter_tencentplayer/view/tencent_player.dart';
import 'package:screen/screen.dart';

import 'widget/tencent_player_bottom_widget.dart';
import 'widget/tencent_player_gesture_cover.dart';

typedef Widget FullScreenTopWidgetBuilder(StateSetter theState);
typedef Widget CenterWidgetBuilder();

class TCCustomControllBuilder extends StatefulWidget {
  final TencentPlayerController controller;
  final bool currentFullScreenState;
  final String placeHolder;
  final FullScreenTopWidgetBuilder barRightWidget;
  final CenterWidgetBuilder centerWidget;
  bool controllable;
  final bool isLocal;

  TCCustomControllBuilder(
      {Key key,
      @required this.controller,
      this.placeHolder,
      this.currentFullScreenState = false,
      this.barRightWidget,
      this.centerWidget,
      this.isLocal = false,
      this.controllable = false})
      : super(key: key);

  @override
  _TCCustomControllBuilderState createState() =>
      _TCCustomControllBuilderState();
}

class _TCCustomControllBuilderState extends State<TCCustomControllBuilder> {
  bool showClearBtn = false; //清晰度
  bool showCover = false;
  Timer timer;
  VoidCallback listener;
  bool _firstPlay = true;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    listener = () {
      if (!mounted) {
        return;
      }
      if (widget.controller.value.initialized &&
          !widget.currentFullScreenState &&
          !widget.isLocal) {
        if (_firstPlay) {
          if (widget.controller.value.duration.inSeconds > 5 &&
              widget.controller.value.isPlaying) {
            widget.controller.pause();
            _firstPlay = false;
          }
        }
      }
      setState(() {});
    };
    widget.controller.addListener(listener);
    hideCover();
    if (widget.currentFullScreenState) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listener);
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    Screen.keepOn(false);
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: widget.currentFullScreenState &&
              widget.controller.value.aspectRatio > 1
          ? 1
          : 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          hideCover();
        },
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: TencentPlayer(widget.controller),
              ),
              showCover
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x40000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x00000000),
                              Color(0x30000000),
                              Color(0x7f000000)
                            ]),
                      ),
                    )
                  : SizedBox(),
              TencentPlayerGestureCover(
                controller: widget.controller,
                behavingCallBack: delayHideCover,
              ),
              widget.centerWidget(),
              showCover
                  ? Positioned(
                      left: 0,
                      top: SizeUtils.statusBar,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(8.px),
                              child: Image.asset(
                                'images/videoBack.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          widget.currentFullScreenState
                              ? widget.barRightWidget(setState)
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox(),
              TencentPlayerBottomWidget(
                isShow: showCover,
                controller: widget.controller,
                currentFullScreenState: widget.currentFullScreenState,
                barRightWidget: widget.barRightWidget,
                centerWidget: widget.centerWidget,
                showClearBtn: showClearBtn,
                behavingCallBack: () {
                  delayHideCover();
                },
                changeClear: (int index) {},
              ),
              Offstage(
                offstage: !widget.controllable,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  hideCover() {
    if (!mounted) return;
    setState(() {
      showCover = !showCover;
    });
    delayHideCover();
  }

  delayHideCover() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    if (showCover) {
      timer = new Timer(Duration(seconds: 6), () {
        if (!mounted) return;
        setState(() {
          showCover = false;
        });
      });
    }
  }
}
