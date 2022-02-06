import 'dart:io' as io;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SaveFilehelper {
  static Future<void> saveAndOpenFile(List<int> bytes, String bpcNo) async {
    try {
//Get external storage directory
      final directory = await getApplicationDocumentsDirectory();

//Get directory path
      final path = directory.path;

//Create an empty file to write PDF data
      io.File file = io.File('$path/' + bpcNo + '.pdf');

//Write PDF data
      await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
      OpenFile.open('$path/' + bpcNo + '.pdf');
    } catch (e) {
      print(e);
    }
  }
}
