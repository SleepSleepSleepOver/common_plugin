import 'dart:io';
import 'dart:ui';

import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PhotoView extends StatefulWidget {
  List imgs;
  File imgPath;
  String url;
  String asset;
  int currentIndex;
  String token;

  PhotoView(
      {this.url,
      this.imgs,
      this.imgPath,
      this.asset,
      this.currentIndex = 0,
      this.token});

  @override
  State<StatefulWidget> createState() => PhotoViewState();
}

class PhotoViewState extends State<PhotoView> with TickerProviderStateMixin {
  Animation<double> _doubleClickAnimation;
  AnimationController _doubleClickAnimationController;
  Function _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Color(0x00000000),
                  alignment: Alignment.centerLeft,
                  width: 44.px,
                  height: 44.px + SizeUtils.statusBar,
                  padding:
                      EdgeInsets.only(left: 18.px, top: SizeUtils.statusBar),
                  child: Image.asset(
                    "images/ic_cancel_6.png",
                    height: 20.px,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Offstage(
                offstage: null == widget.imgs,
                child: Container(
                  padding: EdgeInsets.only(top: SizeUtils.statusBar + 10.px),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${widget.currentIndex + 1} / ${widget.imgs?.length}',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                Widget image;
                if (widget.imgs != null && widget.imgs.length > 0) {
                  if (widget.imgs[index].startsWith("http")) {
                    image = getNetworkImg(widget.imgs[index]);
                  } else if (widget.imgs[index].startsWith("images")) {
                    image = Image.asset(widget.imgs[index]);
                  } else {
                    image = Image.file(widget.imgs[index]);
                  }
                } else {
                  if (widget.imgPath != null) {
                    image = Image.file(widget.imgPath);
                  } else if (widget.url != null) {
                    image = getNetworkImg(widget.url);
                  } else if (widget.asset != null) {
                    image = Image.asset(widget.url);
                  } else {
                    image = SizedBox();
                  }
                }
                return Hero(
                  tag: index.toString(),
                  child: image,
                );
              },
              itemCount: widget.imgs != null && widget.imgs.length > 0
                  ? widget.imgs.length
                  : 1,
              onPageChanged: (int index) {
                setState(() {
                  widget.currentIndex = index;
                });
              },
              controller: PageController(
                initialPage: widget.currentIndex,
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Widget getNetworkImg(url) {
    return ExtendedImage.network(
      url,
      cache: true,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.gesture,
      initGestureConfigHandler: (ExtendedImageState state) {
        return GestureConfig(
            inPageView: true,
            initialScale: 1.0,
            minScale: 1.0,
            cacheGesture: false);
      },
      headers: widget.token != null
          ? {"Authorization": "Bearer " + widget.token}
          : {},
      onDoubleTap: (ExtendedImageGestureState state) {
        final pointerDownPosition = state.pointerDownPosition;
        var begin = state.gestureDetails.totalScale;
        double end;
        _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);
        _doubleClickAnimationController.stop();
        _doubleClickAnimationController.reset();
        if (begin == doubleTapScales[0]) {
          end = doubleTapScales[1];
        } else {
          end = doubleTapScales[0];
        }
        _doubleClickAnimationListener = () {
          state.handleDoubleTap(
              scale: _doubleClickAnimation.value,
              doubleTapPosition: pointerDownPosition);
        };
        _doubleClickAnimation = _doubleClickAnimationController
            .drive(Tween<double>(begin: begin, end: end));

        _doubleClickAnimation.addListener(_doubleClickAnimationListener);

        _doubleClickAnimationController.forward();
      },
    );
  }

  @override
  void dispose() {
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }
}
