import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AddQuestionSecond extends StatefulWidget {
  final Object argument;

  const AddQuestionSecond({Key key, this.argument}) : super(key: key);
  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<AddQuestionSecond> {
  bool _loading = false;
  var access_token;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showList = false;
  bool valuefirst = false;
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String profile_image = '';
  List<bool> isChecked = new List();
  List<bool> isChecked1 = new List();

  List<String> list = [];
  String chapter_id = "";
  String batch_id = "";
  String topic_name = "";
  String chapter_name = "";
  String question_type = "";
  String difficulty_level = "";

  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  final reasonController = TextEditingController();
  String _dropdownValue = 'Select Correct Option';
  String type = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    batch_id = data['batch_id'];
    topic_name = data['topic_name'];
    board_id = data['board_id'];
    class_id = data['class_id'];
    question_type = data['question_type'];
    difficulty_level = data['difficulty_level'];
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
      });
    });
  }

  var result;

  Widget _emptyOrders() {
    return Center(
      child: Container(
          child: Text(
        'NO RECORDS FOUND!',
        style:
            TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
      )),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

  Widget _networkImage1(url) {
    return Container(
      margin: EdgeInsets.only(
        right: 8,
        left: 8,
      ),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffffffff),
        image: DecorationImage(
          image: NetworkImage(profile_image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  var finalDate;
  final dobController = TextEditingController();

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finalDate = order;
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted = formatter.format(finalDate);
      print(formatted);
      dobController.text = formatted.toString();
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2190),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Color(0xff017EFF),
              accentColor: Color(0xff017EFF),
              primarySwatch: MaterialColor(
                0xff017EFF,
                const <int, Color>{
                  50: const Color(0xff017EFF),
                  100: const Color(0xff017EFF),
                  200: const Color(0xff017EFF),
                  300: const Color(0xff017EFF),
                  400: const Color(0xff017EFF),
                  500: const Color(0xff017EFF),
                  600: const Color(0xff017EFF),
                  700: const Color(0xff017EFF),
                  800: const Color(0xff017EFF),
                  900: const Color(0xff017EFF),
                },
              )),
          child: child,
        );
      },
    );
  }

  Widget _questionContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: questionController,
                maxLines: null,
                minLines: 2,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter question.';
                  }
                  return null;
                },
                onSaved: (value) {
                  questionController.text = value;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Enter Question',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: option1Controller,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter option 1.';
                  }
                  return null;
                },
                onSaved: (value) {
                  option1Controller.text = value;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Enter option 1',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: option2Controller,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter option 2.';
                  }
                  return null;
                },
                onSaved: (value) {
                  option2Controller.text = value;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Enter option 2',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: option3Controller,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter option 3.';
                  }
                  return null;
                },
                onSaved: (value) {
                  option3Controller.text = value;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Enter option 3',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: option4Controller,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter option 4.';
                  }
                  return null;
                },
                onSaved: (value) {
                  option4Controller.text = value;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Enter option 4',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            padding: EdgeInsets.all(10),
            decoration: ShapeDecoration(
              color: Color(0xfff9f9fb),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.0,
                  color: Color(0xfff9f9fb),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                isExpanded: true,
                value: _dropdownValue,
                isDense: true,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                    if (_dropdownValue == "Select Correct Option") {
                      setState(() {
                        type = "";
                      });

                      print(type);
                    }
                    if (_dropdownValue == "A") {
                      setState(() {
                        type = "A";
                      });

                      print(type);
                    }
                    if (_dropdownValue == "B") {
                      setState(() {
                        type = "B";
                      });

                      print(type);
                    } else if (_dropdownValue == "C") {
                      setState(() {
                        type = "C";
                      });

                      print(type);
                    } else if (_dropdownValue == "D") {
                      setState(() {
                        type = "D";
                      });

                      print(type);
                    }
                  });
                },
                items: <String>['Select Correct Option', 'A', 'B', 'C', 'D']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value,
                        style: new TextStyle(color: Colors.black)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: reasonController,
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter reason.';
                  }
                  return null;
                },
                onSaved: (value) {
                  reasonController.text = value;
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xfff9f9fb),
                      ),
                    ),
                    counterText: "",
                    hintText: 'Enter reason',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 30.0),
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: ButtonTheme(
              height: 28.0,
              child: RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                textColor: Colors.white,
                color: Color(0xff017EFF),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    setState(() {
                      _loading = true;
                    });
                    final msg = jsonEncode({
                      "type": "2",
                      "batch_id": batch_id,
                      "institute_id": user_id,
                      "subject_id": "1",
                      "board_id": board_id,
                      "class_id": class_id,
                      "question_type": question_type,
                      "difficulty_id": difficulty_level,
                      "chapter_id": chapter_id,
                      "topic_name": topic_name,
                      "question": questionController.text,
                      "option_first": option1Controller.text,
                      "option_second": option2Controller.text,
                      "option_third": option3Controller.text,
                      "option_four": option4Controller.text,
                      "answer_option": type,
                      "reason": reasonController.text,
                    });
                    Map<String, String> headers = {
                      'Accept': 'application/json',
                    };
                    var response = await http.post(
                      new Uri.https(
                          BASE_URL, API_PATH + "/institute-addquestion"),
                      body: {
                        "type": "2",
                        "batch_id": batch_id,
                        "institute_id": user_id,
                        "subject_id": "1",
                        "board_id": board_id,
                        "class_id": class_id,
                        "question_type": question_type,
                        "difficulty_id": difficulty_level,
                        "chapter_id": chapter_id,
                        "topic_name": topic_name,
                        "question": questionController.text,
                        "option_first": option1Controller.text,
                        "option_second": option2Controller.text,
                        "option_third": option3Controller.text,
                        "option_four": option4Controller.text,
                        "answer_option": type,
                        "reason": reasonController.text,
                      },
                      headers: headers,
                    );
                    print(msg);

                    if (response.statusCode == 200) {
                      setState(() {
                        _loading = false;
                      });
                      var data = json.decode(response.body);

                      print(data);
                      var errorCode = data['ErrorCode'];
                      var errorMessage = data['ErrorMessage'];
                      if (errorCode == 0) {
                        setState(() {
                          _loading = false;
                        });
                        Fluttertoast.showToast(msg: errorMessage);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/dashboard');
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        showAlertDialog(
                            context, ALERT_DIALOG_TITLE, errorMessage);
                      }
                    }
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
          child: Text("Add Question", style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: _networkImage1(
                profile_image,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: _questionContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
