import 'dart:async';

import 'package:flustars/flustars.dart';

class CommonUtils {
  // 防抖函数: eg:输入框连续输入，用户停止操作300ms才执行访问接口
  static const deFaultDurationTime = 300;
  static Timer timer;

  static antiShake(Function doSomething, {durationTime = deFaultDurationTime}) {
    timer?.cancel();
    timer = new Timer(Duration(milliseconds: durationTime), () {
      doSomething?.call();
      timer = null;
    });
  }

  // 节流函数: eg:300ms内，只会触发一次
  static int startTime = 0;
  static throttle(Function doSomething, {durationTime = deFaultDurationTime}) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - startTime > durationTime) {
      doSomething?.call();
      startTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  // 根据身份证号计算 年龄
  static int getAgeWithIDCard(String idCard) {
    int age = 0;
    if (RegexUtil.isIDCard(idCard)) {
      int year = int.tryParse(idCard.substring(6, 10));
      int now = DateTime.now().year;
      return now - year;
    }
    return age;
  }

  // 根据身份证号计算出生日期
  static String getBirthdayDCard(String idCard) {
    if (idCard == null || idCard == "" || idCard.length < 16) {
      return "";
    }
    return idCard.substring(6, 14);
  }

  //根据生日计算年龄
  static String getAgeByBirthday(String birthday) {
    int age = 0;
    if (birthday != null && birthday != "") {
      DateTime birth = DateTime.tryParse(birthday);
      int now = DateTime.now().year;
      DateTime d = birth ?? now;
      age = now - d.year;
    }
    return "$age岁";
  }

  static String getFormatedDateTime(String dt) {
    List<String> mList = dt.split(" ");
    List<String> d = mList[0].split("/");
    List<String> t = mList[1].split(":");
    return d[0] +
        "-" +
        (d[1].length == 1 ? "0" + d[1] : d[1]) +
        "-" +
        (d[2].length == 1 ? "0" + d[2] : d[2]) +
        " " +
        (t[0].length == 1 ? "0" + t[0] : t[0]) +
        (t[1].length == 1 ? "0" + t[1] : t[1]) +
        (t[2].length == 1 ? "0" + t[2] : t[2]);
  }

  //当前月份天数
  static int getMouthDays(int year, int month) {
    int days = 0;
    if (month != 2) {
      switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
          days = 31;
          break;
        case 4:
        case 6:
        case 9:
        case 11:
          days = 30;
          break;
      }
    } else {
      // 闰年
      if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
        days = 29;
      else
        days = 28;
    }
    return days;
  }

  /// 获取性别
  static bool isManFromIdCard(String idCard) {
    if (RegexUtil.isIDCard(idCard)) {
      var value = idCard.substring(16, 17);
      return int.parse(value) % 2 == 0 ? false : true;
    } else {
      return null;
    }
  }

  /// 安全取出map值(String)
  static String safeGetMap(item, key, {placehoder = ''}) {
    if (item == null || item.isEmpty) return placehoder;
    var value = item[key];
    if (value == null || value.toString().length == 0 || value == 'null') {
      return placehoder;
    }
    return value.toString();
  }
}
