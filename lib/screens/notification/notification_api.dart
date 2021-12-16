import 'dart:convert';

import 'package:grewal/constants.dart';
import 'package:http/http.dart' as http;

class SendNotificationAPI {
  Future<List> getAllBatchList(user_id) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/batch-list"),
      body: {"institute_id": user_id},
      headers: headers,
    );
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getBatchWiseStudentList(batch_id, institute_id) async {
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/institute-student-list"),
      body: {
        "institute_id": institute_id.toString(),
        "batch_id": batch_id.toString(),
      },
      headers: {
        'Accept': 'application/json',
      },
    );
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<String> sendNotification(Map m) async {
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/institute-send-notification"),
      body: m,
      headers: {
        'Accept': 'application/json',
      },
    );
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return "Notification Send";
    }
    return "Notification Failed to Send";
  }
}
