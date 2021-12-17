// import 'dart:async';
// import 'package:facebook_app_events/facebook_app_events.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:grewal/screens/add_question/enter_question.dart';
// import 'package:grewal/screens/add_question/question_chapter_select.dart';
// import 'package:grewal/screens/add_support.dart';
// import 'package:grewal/screens/batch_list.dart';
// import 'package:grewal/screens/change_password.dart';
// import 'package:grewal/screens/chapter_overview.dart';
// import 'package:grewal/screens/chapter_select.dart';
//
// import 'package:grewal/screens/chapters_list.dart';
// import 'package:grewal/screens/create_batch.dart';
// import 'package:grewal/screens/create_mcq.dart';
// import 'package:grewal/screens/create_ticket.dart';
// import 'package:grewal/screens/dashboard.dart';
// import 'package:grewal/screens/home_page.dart';
// import 'package:grewal/screens/institute_test_list.dart';
// import 'package:grewal/screens/institute_test_list_performance.dart';
// import 'package:grewal/screens/intro_screens.dart';
// import 'package:grewal/screens/leaderboard.dart';
// import 'package:grewal/screens/mts.dart';
// import 'package:grewal/screens/notifications.dart';
// import 'package:grewal/screens/open_pdf.dart';
// import 'package:grewal/screens/overall_performance.dart';
// import 'package:grewal/screens/overall_performance_details.dart';
// import 'package:grewal/screens/sample.dart';
// import 'package:grewal/screens/settings.dart';
// import 'package:grewal/screens/sign_otp_verification.dart';
// import 'package:grewal/screens/sign_up.dart';
// import 'package:grewal/screens/splash.dart';
// import 'package:grewal/screens/static_screens/privacy_policy.dart';
// import 'package:grewal/screens/static_screens/refund_policies.dart';
// import 'package:grewal/screens/static_screens/t_c.dart';
// import 'package:grewal/screens/student_list.dart';
// import 'package:grewal/screens/support_detail.dart';
// import 'package:grewal/screens/support_list.dart';
// import 'package:grewal/screens/test_list.dart';
// import 'package:grewal/screens/ticket_details.dart';
// import 'package:grewal/screens/ticket_list.dart';
// import 'package:grewal/screens/update_profile.dart';
// import 'package:grewal/screens/videos_screen/answer_key.dart';
// import 'package:grewal/screens/videos_screen/create_test.dart';
// import 'package:grewal/screens/videos_screen/create_test_new.dart';
// import 'package:grewal/screens/videos_screen/question_view.dart';
// import 'package:grewal/screens/videos_screen/stu_list.dart';
// import 'package:grewal/screens/videos_screen/student_summary.dart';
// import 'package:grewal/screens/videos_screen/students_summary.dart';
// import 'package:grewal/screens/videos_screen/test_dash.dart';
// import 'package:grewal/screens/videos_screen/videos.dart';
// import 'package:grewal/screens/videos_screen/videos_detail.dart';
// import 'package:grewal/screens/view_performance.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'screens/reset_password.dart';
// import 'screens/get_otp.dart';
// import 'screens/login_with_logo.dart';
// import 'screens/otp_verification.dart';
// import 'screens/plan.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'screens/test_correct.dart';
// import 'screens/view_test.dart';
//
//
//
//
//
// Future<BatchListMove> getUserConnects() async {
//   var headerData = await _getAppHeaders() as Map<String, String>;
//   var url = BaseUrl + "konnect/get-total-connects/";
//   final response = await _provider.get(url, headerData);
//   var responseStatus = Response.fromJson(response);
//   if(responseStatus.status == ResponseStatus.success){
//     var responseModel = BatchListMove.fromJson(response);
//     return responseModel;
//   }
//   // else {
//   //   var responseModel = BatchListMove();
//   //   responseModel.status = responseStatus.status;
//   //   responseModel.error = responseStatus.error;
//   //   return responseModel;
//   // }
// }