// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:grewal/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class UploadStudyMaterialAPI {
  Future<List> getFolderList(user_id) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/folder-list"),
      body: {"institute_id": user_id},
      headers: headers,
    );
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response']['folderList'];
    }
    return [];
  }

  Future<bool> addFolder(user_id, folder_name) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/create-folder"),
      body: {"folder_name": folder_name, "institute_id": user_id},
      headers: headers,
    );

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return true;
    }
    return false;
  }

  Future<List> getUploadedFileList(user_id, folder_id) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/file-list"),
      body: {"folder_id": folder_id, "institute_id": user_id},
      headers: headers,
    );
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response']['files'];
    }
    return [];
  }

  Future<bool> assignFileToBatch(
      toBatch, user_id, folder_id, batch_id, file_id) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    print(jsonEncode(toBatch
        ? {
            "folder_id": folder_id.toString(),
            "institute_id": user_id.toString(),
            "batch_id": batch_id.toString(),
            "file_id": file_id.toString()
          }
        : {
            "folder_id": folder_id.toString(),
            "institute_id": user_id.toString(),
            "file_id": file_id.toString()
          }));
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/file-assign-to-batch"),
      body: toBatch
          ? {
              "folder_id": folder_id.toString(),
              "institute_id": user_id.toString(),
              "batch_id": batch_id.toString(),
              "file_id": file_id.toString()
            }
          : {
              "folder_id": folder_id.toString(),
              "institute_id": user_id.toString(),
              "file_id": file_id.toString()
            },
      headers: headers,
    );

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return true;
    }
    return false;
  }
}
