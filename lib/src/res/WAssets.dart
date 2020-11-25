import 'package:flutter_svg/flutter_svg.dart';

import 'WConstant.dart';

class WAssets {
  WAssets._();

  static final SvgPicture empty =
      SvgPicture.asset('images/bg_empty.svg', package: WConstant.packageName);
  static final SvgPicture empty0 =
      SvgPicture.asset('images/bg_empty_0.svg', package: WConstant.packageName);
  static final SvgPicture fail =
      SvgPicture.asset('images/bg_fail.svg', package: WConstant.packageName);
  static final SvgPicture fail0 =
      SvgPicture.asset('images/bg_fail_0.svg', package: WConstant.packageName);
  static final SvgPicture netError = SvgPicture.asset('images/bg_net_error.svg',
      package: WConstant.packageName);
  static final SvgPicture netError0 = SvgPicture.asset(
      'images/bg_net_error_0.svg',
      package: WConstant.packageName);
  static final SvgPicture noPage =
      SvgPicture.asset('images/bg_no_page.svg', package: WConstant.packageName);
  static final SvgPicture noPage0 = SvgPicture.asset('images/bg_no_page_0.svg',
      package: WConstant.packageName);
  static final SvgPicture paySuccess = SvgPicture.asset(
      'images/bg_pay_success.svg',
      package: WConstant.packageName);
  static final SvgPicture paySuccess0 = SvgPicture.asset(
      'images/bg_pay_success_0.svg',
      package: WConstant.packageName);
  static final SvgPicture searchEmpty = SvgPicture.asset(
      'images/bg_search_empty.svg',
      package: WConstant.packageName);
  static final SvgPicture searchEmpty0 = SvgPicture.asset(
      'images/bg_search_empty_0.svg',
      package: WConstant.packageName);
  static final SvgPicture success =
      SvgPicture.asset('images/bg_success.svg', package: WConstant.packageName);
  static final SvgPicture success0 = SvgPicture.asset('images/bg_success_0.svg',
      package: WConstant.packageName);
  static final SvgPicture unvarify = SvgPicture.asset('images/bg_unvarify.svg',
      package: WConstant.packageName);
  static final SvgPicture unvarify0 = SvgPicture.asset(
      'images/bg_unvarify_0.svg',
      package: WConstant.packageName);
  static final SvgPicture auth =
      SvgPicture.asset('images/ic_auth.svg', package: WConstant.packageName);
  static final SvgPicture authError = SvgPicture.asset(
      'images/ic_auth_error.svg',
      package: WConstant.packageName);
  static final SvgPicture authFail = SvgPicture.asset('images/ic_auth_fail.svg',
      package: WConstant.packageName);
  static final SvgPicture authSuccess = SvgPicture.asset(
      'images/ic_auth_success.svg',
      package: WConstant.packageName);
  static final SvgPicture authing =
      SvgPicture.asset('images/ic_authing.svg', package: WConstant.packageName);
  static SvgPicture loading({color}) {
    return SvgPicture.asset('images/ic_loading.svg',
        package: WConstant.packageName, color: color);
  }
}
