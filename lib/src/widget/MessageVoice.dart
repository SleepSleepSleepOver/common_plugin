import 'dart:math';

import 'package:common_plugin/common_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

typedef stopRecord = Future Function();

class MessageVoice extends StatefulWidget {
  final Function stopRecord;
  final Widget leftWidget;
  final Color backGroundColor;
  final String initText;
  final double height;
  final Codec codeStr;

  const MessageVoice(
      {Key key,
      this.stopRecord,
      this.leftWidget,
      this.backGroundColor,
      this.initText,
      this.codeStr,
      this.height})
      : super(key: key);

  @override
  _MessageVoiceState createState() => _MessageVoiceState();
}

class _MessageVoiceState extends State<MessageVoice> {
  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  String textShow = "";
  bool isCancel = false;
  String voiceIco = "images/voice_1.png";
  OverlayEntry overlayEntry;
  FlutterSoundRecorder recordPlugin;
  int duration = 0;
  String mPath = "";

  @override
  void initState() {
    super.initState();
    textShow = widget.initText ?? '按住说话';
    FlutterSoundRecorder()
      ..openAudioSession().then((onValue) {
        recordPlugin = onValue;
        recordPlugin.setSubscriptionDuration(Duration(milliseconds: 100));
        recordPlugin
            .defaultPath(widget.codeStr ?? Codec.pcm16WAV)
            .then((value) {
          mPath = value;
        });
        recordPlugin.onProgress.listen((data) {
          if (data == null) return;
          if (data.duration != null) duration = data.duration.inSeconds;
          if (!isCancel) {
            double value = exp(data.decibels / 20);
            if (value < 6) {
              voiceIco = "images/voice_1.png";
            } else if (value >= 6 && value < 8) {
              voiceIco = "images/voice_2.png";
            } else if (value >= 8 && value < 12) {
              voiceIco = "images/voice_3.png";
            } else if (value >= 12 && value < 20) {
              voiceIco = "images/voice_4.png";
            } else if (value >= 20 && value < 30) {
              voiceIco = "images/voice_5.png";
            } else if (value >= 30) {
              voiceIco = "images/voice_6.png";
            }
          }
          if (overlayEntry != null) {
            overlayEntry.markNeedsBuild();
          }
        });
      });

    overlayEntry = OverlayEntry(builder: (content) {
      return Positioned(
        bottom: SizeUtils.screenH * 0.5 - 120.px * 0.5,
        left: SizeUtils.screenW * 0.5 - 120.px * 0.5,
        child: Container(
          width: 120.px,
          height: 120.px,
          child: Image.asset(
            voiceIco,
            package: WConstant.packageName,
            fit: BoxFit.fill,
          ),
        ),
      );
    });
  }

  showVoiceView() {
    setState(() {
      if (overlayEntry != null) {
        Overlay.of(context).insert(overlayEntry);
        textShow = "松开结束";
        isCancel = false;
        voiceIco = "images/voice_1.png";
      }
    });
    if (recordPlugin.isStopped)
      recordPlugin.startRecorder(
          codec: widget.codeStr ?? Codec.pcm16WAV,
          bitRate: 320000,
          toFile: mPath);
  }

  hideVoiceView() {
    setState(() {
      if (overlayEntry != null) {
        textShow = widget.initText ?? "按住说话";
        isUp = false;
        voiceIco = "images/voice_1.png";
        overlayEntry.remove();
      }
    });
    if (recordPlugin.isRecording)
      recordPlugin.stopRecorder().then((_) {
        if (!isCancel) {
          if (duration < 1)
            Toast.toast('说话时间太短');
          else
            widget.stopRecord(mPath, duration);
        }
      });
  }

  moveVoiceView() {
    isUp = starty - offset > 100 ? true : false;
    setState(() {
      if (isUp) {
        textShow = "松开手指,取消发送";
        isCancel = true;
        voiceIco = "images/cancelVoice.png";
      } else {
        textShow = "松开结束";
        isCancel = false;
        voiceIco = "images/voice_1.png";
      }
    });
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) {
        starty = details.globalPosition.dy;
        showVoiceView();
      },
      onVerticalDragCancel: () {
        hideVoiceView();
      },
      onVerticalDragEnd: (details) {
        hideVoiceView();
      },
      onVerticalDragUpdate: (details) {
        offset = details.globalPosition.dy;
        moveVoiceView();
      },
      child: Container(
          height: widget.height ?? 36.px,
          decoration: BoxDecoration(
            color: widget.backGroundColor ?? WColor.CF5F5F5,
            borderRadius: BorderRadius.circular(4.px),
            border: Border.all(
              color: widget.backGroundColor ?? WColor.CE9E9E9,
            ),
          ),
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            widget.leftWidget ?? Container(),
            WText(
              textShow,
              style: TextStyle(fontSize: 16.px, color: WColor.C333333),
            ),
          ])),
    );
  }

  @override
  void dispose() {
    if (recordPlugin != null) {
      recordPlugin.closeAudioSession();
    }
    super.dispose();
  }
}
