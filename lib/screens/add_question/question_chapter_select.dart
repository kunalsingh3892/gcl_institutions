import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/screens/api/data_list_api.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AddQuestionFirst extends StatefulWidget {
  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<AddQuestionFirst> {
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
  String chapter_name = "";
  String type = "";

  List<Region5> _region5 = [];
  List<Region> _region = [];
  List<Region3> _region3 = [];
  List<Region1> _region1 = [];
  List<Region2> _region2 = [];
  List<Region4> _region4 = [];
  List<Region6> _region6 = [];
  var _type5 = "";
  var _type = "";
  var _type3 = "";
  var _type1 = "";
  var _type2 = "";
  var _type4 = "";
  var _type6 = "";
  String selectedRegion5;
  String selectedRegion;
  String selectedRegion3 = "";
  String selectedRegion1;
  String selectedRegion2;
  String selectedRegion4;
  String selectedRegion6;
  String catData5 = "";
  String catData = "";
  String catData3 = "";
  String catData1 = "";
  String catData2 = "";
  String catData4 = "";
  String catData6 = "";
  Future _batchData;
  Future _boardData;
  Future _classData;
  Future _chapterData;
  Future _topicData;
  Future _dLData;
  Future _dTData;
  List subjectList = [];
  @override
  void initState() {
    super.initState();
    DataListAPI().getSubjectsList().then((val) {
      setState(() {
        val.forEach((element) {
          subjectList.add(element['id'].toString());
        });
      });
    });
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        _batchData = _getBatchCategories();
      });
    });
  }

  var result;

  Future _getChapterData(String boardId, String classId, String subject) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      body: {
        "board_id": boardId,
        "class_id": classId,
        "subject_id": subject.toString(),
        "student_id": ""
      },
      headers: headers,
    );
    print({
      "board_id": boardId,
      "class_id": classId,
      "subject_id": "8",
      "student_id": ""
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var result = data['Response'];
      print(result);
      if (mounted) {
        setState(() {
          catData1 = jsonEncode(result);

          final json = JsonDecoder().convert(catData1);
          _region1 =
              (json).map<Region1>((item) => Region1.fromJson(item)).toList();
          List<String> item = _region1.map((Region1 map) {
            for (int i = 0; i < _region1.length; i++) {
              if (selectedRegion1 == map.THIRD_LEVEL_NAME) {
                _type1 = map.THIRD_LEVEL_ID;
                if (selectedRegion1 == "" || selectedRegion1 == null) {
                  selectedRegion1 = _region1[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion1);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion1 == "") {
            selectedRegion1 = _region1[0].THIRD_LEVEL_NAME;
            // _type = _region[0].THIRD_LEVEL_ID;
          }
          //  _topicData=_getTopicData(_type1);
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getTopicData(String chapter_id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/topiclistchapterwise"),
      body: {"chapter_id": chapter_id},
      headers: headers,
    );
    print({"chapter_id": chapter_id});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var result = data['Response'];
      print(result);
      if (mounted) {
        setState(() {
          catData2 = jsonEncode(result);

          final json = JsonDecoder().convert(catData2);
          _region2 =
              (json).map<Region2>((item) => Region2.fromJson(item)).toList();
          List<String> item = _region2.map((Region2 map) {
            for (int i = 0; i < _region2.length; i++) {
              if (selectedRegion2 == map.THIRD_LEVEL_NAME) {
                _type2 = map.THIRD_LEVEL_ID;
                if (selectedRegion2 == "" || selectedRegion2 == null) {
                  selectedRegion2 = _region2[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion2);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          // if (selectedRegion2 == "") {
          selectedRegion2 = _region2[0].THIRD_LEVEL_NAME;
          _type2 = _region2[0].THIRD_LEVEL_ID;
          // }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getBoardCategories() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/board"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(result);
      if (mounted) {
        setState(() {
          catData = jsonEncode(result);

          final json = JsonDecoder().convert(catData);
          _region =
              (json).map<Region>((item) => Region.fromJson(item)).toList();
          List<String> item = _region.map((Region map) {
            for (int i = 0; i < _region.length; i++) {
              if (selectedRegion == map.THIRD_LEVEL_NAME) {
                _type = map.THIRD_LEVEL_ID;
                if (selectedRegion == "" || selectedRegion == null) {
                  selectedRegion = _region[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion == "") {
            selectedRegion = _region[0].THIRD_LEVEL_NAME;
            // _type = _region[0].THIRD_LEVEL_ID;
          }

          _classData = _getClassCategories();
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getClassCategories() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/standard"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData3 = jsonEncode(result);

          final json = JsonDecoder().convert(catData3);
          _region3 =
              (json).map<Region3>((item) => Region3.fromJson(item)).toList();
          List<String> item = _region3.map((Region3 map) {
            for (int i = 0; i < _region3.length; i++) {
              if (selectedRegion3 == map.THIRD_LEVEL_NAME) {
                _type3 = map.THIRD_LEVEL_ID;

                print(selectedRegion3);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion3 == "") {
            selectedRegion3 = _region3[0].THIRD_LEVEL_NAME;
            _type3 = _region3[0].THIRD_LEVEL_ID;
          }
          // _chapterData = _getChapterData(_type,_type3);
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getBatchCategories() async {
    Map<String, String> headers = {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/batch-list"),
      body: {
        "institute_id": user_id,
      },
      headers: headers,
    );
    print({
      "institute_id": user_id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData5 = jsonEncode(result);

          final json = JsonDecoder().convert(catData5);
          _region5 =
              (json).map<Region5>((item) => Region5.fromJson(item)).toList();
          List<String> item = _region5.map((Region5 map) {
            for (int i = 0; i < _region5.length; i++) {
              if (selectedRegion5 == map.THIRD_LEVEL_NAME) {
                _type5 = map.THIRD_LEVEL_ID;
                if (selectedRegion5 == "" || selectedRegion5 == null) {
                  selectedRegion5 = _region5[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion5);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion5 == "") {
            selectedRegion5 = _region5[0].THIRD_LEVEL_NAME;
            //  _type5 = _region5[0].THIRD_LEVEL_ID;
          }
          _boardData = _getBoardCategories();
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _difTypeCategories() async {
    Map<String, String> headers = {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/question-type"),
      body: "",
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData4 = jsonEncode(result);

          final json = JsonDecoder().convert(catData4);
          _region4 =
              (json).map<Region4>((item) => Region4.fromJson(item)).toList();
          List<String> item = _region4.map((Region4 map) {
            for (int i = 0; i < _region4.length; i++) {
              if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                _type4 = map.THIRD_LEVEL_ID;
                if (selectedRegion4 == "" || selectedRegion4 == null) {
                  selectedRegion4 = _region4[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion4);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion4 == "") {
            selectedRegion4 = _region4[0].THIRD_LEVEL_NAME;
            //  _type5 = _region5[0].THIRD_LEVEL_ID;
          }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _difLevCategories() async {
    Map<String, String> headers = {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/question-level"),
      body: "",
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData6 = jsonEncode(result);

          final json = JsonDecoder().convert(catData6);
          _region6 =
              (json).map<Region6>((item) => Region6.fromJson(item)).toList();
          List<String> item = _region6.map((Region6 map) {
            for (int i = 0; i < _region6.length; i++) {
              if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
                _type6 = map.THIRD_LEVEL_ID;
                if (selectedRegion6 == "" || selectedRegion6 == null) {
                  selectedRegion6 = _region6[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion6);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion6 == "") {
            selectedRegion6 = _region6[0].THIRD_LEVEL_NAME;
            //  _type5 = _region5[0].THIRD_LEVEL_ID;
          }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

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
        child: Container(
          child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.02,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select Batch",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion5,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion5 = newValue;
                              List<String> item = _region5.map((Region5 map) {
                                for (int i = 0; i < _region5.length; i++) {
                                  if (selectedRegion5 == map.THIRD_LEVEL_NAME) {
                                    _type5 = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();
                            });
                          },
                          items: _region5.map((Region5 map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select Class",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion3,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion3 = newValue;
                              List<String> item = _region3.map((Region3 map) {
                                for (int i = 0; i < _region3.length; i++) {
                                  if (selectedRegion3 == map.THIRD_LEVEL_NAME) {
                                    _type3 = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();
                            });
                          },
                          items: _region3.map((Region3 map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select Board",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion = newValue;
                              List<String> item = _region.map((Region map) {
                                for (int i = 0; i < _region.length; i++) {
                                  if (selectedRegion == map.THIRD_LEVEL_NAME) {
                                    _type = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();
                              valuefirst = false;
                              list.clear();

                              _chapterData = _getChapterData(_type, _type3,
                                  subjectList.join(",").toString());
                            });
                          },
                          items: _region.map((Region map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select Chapter",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion1,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion1 = newValue;
                              List<String> item = _region1.map((Region1 map) {
                                for (int i = 0; i < _region1.length; i++) {
                                  if (selectedRegion1 == map.THIRD_LEVEL_NAME) {
                                    _type1 = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();

                              _topicData = _getTopicData(_type1);
                            });
                          },
                          items: _region1.map((Region1 map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select Topic",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion2,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion2 = newValue;
                              List<String> item = _region2.map((Region2 map) {
                                for (int i = 0; i < _region2.length; i++) {
                                  if (selectedRegion2 == map.THIRD_LEVEL_NAME) {
                                    _type2 = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();
                              _dTData = _difTypeCategories();
                              _dLData = _difLevCategories();
                            });
                          },
                          items: _region2.map((Region2 map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select question type",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion4,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion4 = newValue;
                              List<String> item = _region4.map((Region4 map) {
                                for (int i = 0; i < _region4.length; i++) {
                                  if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                                    _type4 = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();
                            });
                          },
                          items: _region4.map((Region4 map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 3),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          hint: new Text(
                            "Select difficulty level",
                            style: TextStyle(color: Color(0xffBBBFC3)),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedRegion6,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRegion6 = newValue;
                              List<String> item = _region6.map((Region6 map) {
                                for (int i = 0; i < _region6.length; i++) {
                                  if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
                                    _type6 = map.THIRD_LEVEL_ID;
                                    return map.THIRD_LEVEL_ID;
                                  }
                                }
                              }).toList();
                            });
                          },
                          items: _region6.map((Region6 map) {
                            return new DropdownMenuItem<String>(
                              value: map.THIRD_LEVEL_NAME,
                              child: new Text(map.THIRD_LEVEL_NAME,
                                  style: new TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(right: 8.0, left: 8, bottom: 30),
                    child: ButtonTheme(
                      height: 28.0,
                      minWidth: MediaQuery.of(context).size.width * 0.80,
                      child: RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        textColor: Colors.white,
                        color: Color(0xff017EFF),
                        onPressed: () async {
                          if (_type5 != "") {
                            if (_type != "") {
                              if (_type1 != "") {
                                Navigator.pushNamed(
                                  context,
                                  '/enter-question',
                                  arguments: <String, String>{
                                    'chapter_id': _type1,
                                    'batch_id': _type5,
                                    'topic_name': selectedRegion2,
                                    'board_id': _type,
                                    'class_id': _type3,
                                    'question_type': _type4,
                                    'difficulty_level': _type6,
                                  },
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please select any chapter.");
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please select board.");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Please select batch.");
                          }
                        },
                        child: Text("Next", style: next),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class Region5 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;
  final String THIRD_LEVEL_CODE;

  Region5({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME, this.THIRD_LEVEL_CODE});

  factory Region5.fromJson(Map<String, dynamic> json) {
    return new Region5(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['batch_name'],
    );
  }
}

class Region {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        THIRD_LEVEL_ID: json['id'].toString(), THIRD_LEVEL_NAME: json['name']);
  }
}

class Region3 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region3({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region3.fromJson(Map<String, dynamic> json) {
    return new Region3(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['class'],
    );
  }
}

class Region1 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region1({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region1.fromJson(Map<String, dynamic> json) {
    return new Region1(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['chapter_name'],
    );
  }
}

class Region2 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region2({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region2.fromJson(Map<String, dynamic> json) {
    return new Region2(
      THIRD_LEVEL_ID: json['topic_id'].toString(),
      THIRD_LEVEL_NAME: json['name'],
    );
  }
}

class Region6 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region6({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region6.fromJson(Map<String, dynamic> json) {
    return new Region6(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['type'],
    );
  }
}

class Region4 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region4({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region4.fromJson(Map<String, dynamic> json) {
    return new Region4(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['type'],
    );
  }
}
