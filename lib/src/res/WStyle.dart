import 'package:common_plugin/src/utils/SizeUtils.dart';
import 'package:flutter/material.dart';

import 'WColor.dart';

class WStyle {
  WStyle._();
  static TextStyle base({color, size, isBold = false, height}) {
    return TextStyle(
        color: color ?? WColor.C333333,
        fontSize: size ?? 16.px,
        fontWeight:
            isBold ? FontWeight.w600 : FontWeight.normal, //w500只对ios有效，安卓只认w600
        height: height ?? 1);
  }

  static final TextStyle HB18 = TextStyle(
      color: WColor.C333333,
      fontSize: 18.px,
      fontWeight: FontWeight.w600,
      height: 1);
  static final TextStyle HB16 = TextStyle(
      color: WColor.C333333,
      fontSize: 16.px,
      fontWeight: FontWeight.w600,
      height: 22 / 16);

  static final TextStyle L16 =
      TextStyle(color: WColor.C333333, fontSize: 16.px, height: 22 / 16);
  static final TextStyle T15 = TextStyle(
      color: WColor.C333333,
      fontSize: 15.px,
      height: 21 / 15,
      letterSpacing: 0.5);
  static final TextStyle T14 = TextStyle(
      color: WColor.C333333,
      fontSize: 14.px,
      height: 20 / 14,
      letterSpacing: 0.5);
  static final TextStyle T13 =
      TextStyle(color: WColor.C666666, fontSize: 13.px, height: 19 / 13);
  static final TextStyle T12 =
      TextStyle(color: WColor.C999999, fontSize: 12.px, height: 18 / 12);
  static final TextStyle T10 =
      TextStyle(color: WColor.C999999, fontSize: 10.px, height: 1);
}
