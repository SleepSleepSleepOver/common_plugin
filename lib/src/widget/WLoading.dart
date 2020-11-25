import 'package:common_plugin/src/res/WAssets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WLoading extends StatefulWidget {
  final double width;
  final double height;
  final String bgName;
  final Color loadingColor;

  WLoading({this.bgName, this.width, this.height, this.loadingColor});

  @override
  State<StatefulWidget> createState() => _LoadingState();
}

class _LoadingState extends State<WLoading>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RotationTransition(
        alignment: Alignment.center,
        turns: controller,
        child: widget.bgName == null
            ? WAssets.loading(color: widget.loadingColor)
            : widget.bgName.endsWith('svg')
                ? SvgPicture.asset('images/${widget.bgName}',
                    color: widget.loadingColor)
                : Image.asset('images/${widget.bgName}',
                    color: widget.loadingColor),
      ),
    );
  }
}
