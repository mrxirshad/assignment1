import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CheckFile{
  static  Future<bool> checkFile(String link) async {
    bool offline = true;
    if (!link.isEmpty) {
      String url = link;
      String filename = url
          .split('/')
          .last;

      final dir =
      await getApplicationDocumentsDirectory();
      String path = dir.path + "/" + filename;
      final fileDir = Directory(path);
      print(fileDir);

      if (await fileDir.exists()) {
        offline = true;
      }
      else{
        return false;
      }
    }
    return offline;
  }
}