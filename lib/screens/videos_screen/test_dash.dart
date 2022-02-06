import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/constants.dart';
import 'package:grewal/screens/pdfs/save_file_mobile.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TestDash extends StatefulWidget {
  final Object argument;

  const TestDash({Key key, this.argument}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<TestDash> {
  bool _value = false;
  String test_id = "";
  bool _loading = false;
  String profile_image = '';
  Future _chapterData;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  String test_name = "";
  String user_id = "";

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];
    test_name = data['test_name'].toString();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          child: Row(children: <Widget>[
            IconButton(
              icon: Image(
                image: AssetImage("assets/images/Icon.png"),
                height: 20.0,
                width: 10.0,
                color: Color(0xff2E2A4A),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ]),
        ),
        centerTitle: true,
        title: Container(
          child: Text(test_name, style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          /*Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: _networkImage1(
                profile_image,
              ),
            ),
          ),*/
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/students-summary',
                        arguments: <String, String>{
                          'test_id': test_id,
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 20.0, right: 10, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: planbg1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg1)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/student_summary.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Students \nSummary \n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/question-view',
                        arguments: <String, String>{
                          'test_id': test_id,
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 20.0, right: 30, bottom: 20),
                      child: Container(
                        /* width: 151,
                                  height: 176,*/
                        decoration: BoxDecoration(
                            color: planbg1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg1)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/quest_summary.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Question \n Summary \n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/answer-key',
                        arguments: <String, String>{
                          'test_id': test_id,
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 10, bottom: 20),
                      child: Container(
                        /* width: 151,
                                  height: 176,*/
                        decoration: BoxDecoration(
                            color: planbg1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg1)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: new Image.asset(
                                        'assets/images/problem_solving.png'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Answer \n Key \n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Container(
                                  height: 300,
                                  child: ListView(
                                    children: [
                                      Card(
                                        color: Colors.green,
                                        child: ListTile(
                                          title: Text(
                                            "Questions PDF",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () async {
                                            ProgressBar()
                                                .showLoaderDialog(context);
                                            Map<String, String> headers = {
                                              // 'Content-Type': 'application/json',
                                              'Accept': 'application/json',
                                              // "authorization": basicAuth
                                            };
                                            var response = await http.post(
                                              new Uri.https(
                                                  BASE_URL,
                                                  API_PATH +
                                                      "/institute-test-submited_list_question_overview"),
                                              body: {"test_id": test_id},
                                              headers: headers,
                                            );
                                            Navigator.of(context).pop();
                                            if (jsonDecode(response.body)[
                                                    'ErrorCode'] ==
                                                0) {
                                              String htmlContent = "";

                                              List data = jsonDecode(
                                                      response.body)['Response']
                                                  ['question_list'];

                                              data.forEach((element) {
                                                htmlContent = htmlContent +
                                                    "<h3><b>Question No: " +
                                                    (data.indexOf(element) + 1)
                                                        .toString() +
                                                    "</b></h3>" +
                                                    element['question']
                                                        .toString() +
                                                    "</br>";
                                              });
                                              Directory appDocDir =
                                                  await getApplicationDocumentsDirectory();
                                              final targetPath = appDocDir.path;
                                              final targetFileName =
                                                  test_name.toString();

                                              await FlutterHtmlToPdf
                                                      .convertFromHtmlContent(
                                                          htmlContent,
                                                          targetPath,
                                                          targetFileName)
                                                  .then((value) {
                                                SaveFilehelper.saveAndOpenFile(
                                                    File(value.path.toString())
                                                        .readAsBytesSync(),
                                                    "Questions PDF - " +
                                                        targetFileName
                                                            .toString());
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "No data found");
                                            }
                                          },
                                        ),
                                      ),
                                      Card(
                                        color: Colors.green,
                                        child: ListTile(
                                          title: Text(
                                            "Questions with Answer PDF",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () async {
                                            ProgressBar()
                                                .showLoaderDialog(context);
                                            Map<String, String> headers = {
                                              // 'Content-Type': 'application/json',
                                              'Accept': 'application/json',
                                            };
                                            var response = await http.post(
                                              new Uri.https(BASE_URL,
                                                  API_PATH + "/answerkey"),
                                              body: {
                                                "institute_id":
                                                    user_id.toString(),
                                                "inst_test_id":
                                                    test_id.toString(),
                                                "test_id": ""
                                              },
                                              headers: headers,
                                            );
                                            Navigator.of(context).pop();
                                            if (jsonDecode(response.body)[
                                                    'ErrorCode'] ==
                                                0) {
                                              String htmlContent = "";

                                              List data = jsonDecode(
                                                  response.body)['Response'];

                                              data.forEach((element) {
                                                String asnswer = "";
                                                switch (element['answer']) {
                                                  case "A":
                                                    asnswer = element[
                                                                'option_first']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p style='color:green;font-weight:bold'>(A).") +
                                                        element['option_second']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(B).") +
                                                        element['option_third']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(C).") +
                                                        element['option_fourth']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(D).");
                                                    break;
                                                  case "B":
                                                    asnswer = element[
                                                                'option_first']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(A).") +
                                                        element['option_second']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p style='color:green;font-weight:bold'>(B).") +
                                                        element['option_third']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(C).") +
                                                        element['option_fourth']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(D).");
                                                    break;
                                                  case "C":
                                                    asnswer = element[
                                                                'option_first']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(A).") +
                                                        element['option_second']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(B).") +
                                                        element['option_third']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p style='color:green;font-weight:bold'>(C).") +
                                                        element['option_fourth']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(D).");
                                                    break;
                                                  case "D":
                                                    asnswer = element[
                                                                'option_first']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(A).") +
                                                        element['option_second']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(B).") +
                                                        element['option_third']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p>(C).") +
                                                        element['option_fourth']
                                                            .toString()
                                                            .replaceFirst("<p>",
                                                                "<p style='color:green;font-weight:bold'>(D).");
                                                    break;
                                                }
                                                String comp = "";
                                                if (element['question_type']
                                                        .toString() ==
                                                    "Case Study") {
                                                  comp = element[
                                                          'comprahensive_paragraph ']
                                                      .toString();
                                                }
                                                htmlContent = htmlContent +
                                                    comp +
                                                    "<h2><b>Question No: " +
                                                    (data.indexOf(element) + 1)
                                                        .toString() +
                                                    "</b></h2>" +
                                                    element['question']
                                                        .toString() +
                                                    asnswer +
                                                    "<h4><b>Reason:</b></h4>" +
                                                    element['reason']
                                                        .toString();
                                              });
                                              Directory appDocDir =
                                                  await getApplicationDocumentsDirectory();
                                              final targetPath = appDocDir.path;
                                              final targetFileName =
                                                  test_name.toString();

                                              await FlutterHtmlToPdf
                                                      .convertFromHtmlContent(
                                                          htmlContent,
                                                          targetPath,
                                                          targetFileName)
                                                  .then((value) {
                                                SaveFilehelper.saveAndOpenFile(
                                                    File(value.path.toString())
                                                        .readAsBytesSync(),
                                                    "Questions Answers PDF - " +
                                                        targetFileName
                                                            .toString());
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "No data found");
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, right: 30, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: planbg1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: planbg1)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: Center(
                                  child: Container(
                                    width: 78,
                                    height: 67.01,
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      size: 60,
                                      color: Colors.red,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.76),
                                child: Center(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "PDFs\n\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
