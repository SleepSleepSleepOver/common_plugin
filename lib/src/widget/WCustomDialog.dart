import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WCustomDialog {
  static show(Function(Function cancelFunc) widget,
      {BackButtonBehavior backButtonBehavior}) {
    BotToast.showAnimationWidget(
        clickClose: false,
        allowClick: false,
        onlyOne: true,
        crossPage: true,
        backButtonBehavior: backButtonBehavior ?? BackButtonBehavior.close,
        animationDuration: Duration(milliseconds: 300),
        wrapToastAnimation: (controller, cancel, child) => Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cancel();
                  },
                  child: AnimatedBuilder(
                    builder: (_, child) => Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black54),
                      child: SizedBox.expand(),
                    ),
                    animation: controller,
                  ),
                ),
                CustomOffsetAnimation(
                  controller: controller,
                  child: child,
                )
              ],
            ),
        toastBuilder: (cancelFunc) {
          return widget(cancelFunc);
        });
  }
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomOffsetAnimation({Key key, this.controller, this.child})
      : super(key: key);

  @override
  _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
}

class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  Tween<Offset> tweenOffset;

  Animation<double> animation;

  @override
  void initState() {
    tweenOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.8), end: Offset.zero);
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller,
      builder: (BuildContext context, Widget child) {
        return FractionalTranslation(
            translation: tweenOffset.evaluate(animation), child: child);
      },
    );
  }
}
