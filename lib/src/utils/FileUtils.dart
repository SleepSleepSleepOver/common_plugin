import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  Future<String> createFile(String path) async {
    File file = File(path);
    if (!await file.exists()) {
      file.create();
    }
    return path;
  }

  Future<String> getApkPath(String path) async {
    var appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path + "/Download/";
    Directory directory = Directory(appDocPath);
    if (!await directory.exists()) {
      directory.create();
    }
    String filePath = await createFile(appDocPath + path);
    return filePath;
  }
}
