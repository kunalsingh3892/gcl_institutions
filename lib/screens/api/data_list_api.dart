import 'dart:convert';

import 'package:grewal/services/shared_preferences.dart';
import 'package:grewal/constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataListAPI {
  String api_token = "";
  String user_id = "";
  String institute_id = "";
  Future getToken() async {
    Preference().getPreferences().then((value) {
      api_token = value.getString("api_token").toString();
      user_id = value.getString('user_id').toString();
      institute_id = value.getString('institute_id').toString();
    });
  }

  Future<List> getSubjectsList() async {
    print(BASE_URL + API_PATH);
    print(URL);
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/subject"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {"student_id": user_id},
    );
    print(response.body.toString() + " get");
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getBatchList() async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/batch-list"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {"institute_id": user_id},
    );
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getStandartList() async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/standard"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
    );
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getChapterList(
      String boardId, String classId, String subjectId) async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
      body: {
        "board_id": boardId,
        "class_id": classId,
        "subject_id": subjectId.toString(),
        "student_id": ""
      },
    );
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      List temp = jsonDecode(response.body)['Response'];
      temp.forEach((e) {
        e['selected'] = false;
      });
      return temp;
    }
    return [];
  }

  Future<List> getBoardList() async {
    await getToken();
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/board"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + api_token.toString(),
      },
    );
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }
}
