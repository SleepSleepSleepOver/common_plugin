import 'dart:ui';

class SizeUtils {
  SizeUtils._();
  static final double screenW =
      window.physicalSize.width / window.devicePixelRatio;
  static final double screenH =
      window.physicalSize.height / window.devicePixelRatio;
  static final double screenWidthPX = window.physicalSize.width;
  static final double screenHeightPX = window.physicalSize.height;
  static final double statusBar = window.padding.top / window.devicePixelRatio;
  static final double bottomBar =
      window.padding.bottom / window.devicePixelRatio;
}

extension doubleFit on double {
  double get px {
    return this * SizeUtils.screenW / 375.0;
  }
}

extension intFit on int {
  double get px {
    return this * SizeUtils.screenW / 375.0;
  }
}
