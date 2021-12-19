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

import '../constants.dart';

class ChapterListScreen extends StatefulWidget {
  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<ChapterListScreen> {
  Future<dynamic> _chapterData;
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
  var _type5 = "";
  var _type = "";
  var _type3 = "";
  String selectedRegion6;
  String testType = "O";
  String selectedRegion;
  String selectedRegion3 = "";
  String catData5 = "";
  String catData = "";
  String catData3 = "";
  Future _batchData;
  Future _boardData;
  Future _classData;
  String _dropdownValue = 'Select Content Type';
  @override
  void initState() {
    super.initState();
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

  Future _getChapterData(String boardId, String classId) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      body: {
        "board_id": boardId,
        "class_id": classId,
        "subject_id": "8",
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
      result = data['Response'];

      setState(() {
        if (boardId != "14") {
          print("hffffff");
          isChecked.clear();
          for (int i = 0; i < result.length; i++) {
            isChecked.add(false);
          }
        } else {
          print("wsegewge");
          isChecked1.clear();
          for (int i = 0; i < result.length; i++) {
            isChecked1.add(false);
          }
        }
      });

      return data;
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
              if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
                _type5 = map.THIRD_LEVEL_ID;
                if (selectedRegion6 == "" || selectedRegion6 == null) {
                  selectedRegion6 = _region5[0].THIRD_LEVEL_ID;
                }
                print(selectedRegion6);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion6 == "") {
            selectedRegion6 = _region5[0].THIRD_LEVEL_NAME;
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

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['Response'].length != 0) {
            return Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data['Response'].length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xff2E2A4A).withOpacity(0.40)),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  snapshot.data['Response'][index]
                                      ['chapter_name'],
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: normalText5),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Color(0xff2E2A4A),
                                  ),
                                  child: Checkbox(
                                    focusColor: Color(0xff2E2A4A),
                                    checkColor: Color(0xffffffff),
                                    activeColor: Color(0xff2E2A4A),
                                    value: isChecked[index],
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          isChecked[index] = value;
                                          if (isChecked[index] == true) {
                                            list.add(snapshot.data['Response']
                                                    [index]['id']
                                                .toString());
                                            print(list);
                                          } else if (isChecked[index] ==
                                              false) {
                                            list.remove(snapshot
                                                .data['Response'][index]['id']
                                                .toString());
                                            print(list);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ));
                  }),
            );
          } else {
            return _emptyOrders();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget chapterList1(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['Response'].length != 0) {
            return Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data['Response'].length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xff2E2A4A).withOpacity(0.40)),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  snapshot.data['Response'][index]
                                      ['chapter_name'],
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: normalText5),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Color(0xff2E2A4A),
                                  ),
                                  child: Checkbox(
                                    focusColor: Color(0xff2E2A4A),
                                    checkColor: Color(0xffffffff),
                                    activeColor: Color(0xff2E2A4A),
                                    value: isChecked1[index],
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          isChecked1[index] = value;
                                          if (isChecked1[index] == true) {
                                            list.add(snapshot.data['Response']
                                                    [index]['id']
                                                .toString());
                                            print(list);
                                          } else if (isChecked1[index] ==
                                              false) {
                                            list.remove(snapshot
                                                .data['Response'][index]['id']
                                                .toString());
                                            print(list);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ));
                  }),
            );
          } else {
            return _emptyOrders();
          }
        } else {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
      },
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
          child: Text("Create Test", style: normalText6),
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
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
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
                                "Test Type",
                                style: TextStyle(color: Color(0xffBBBFC3)),
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                              value: testType,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  testType = newValue;
                                });
                              },
                              items: [
                                {"title": "Objective", "value": "O"},
                                {"title": "Subjective", "value": "S"}
                              ]
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e['title'].toString()),
                                        value: e['value'].toString(),
                                      ))
                                  .toList()),
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
                            value: selectedRegion6,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRegion6 = newValue;
                                List<String> item = _region5.map((Region5 map) {
                                  for (int i = 0; i < _region5.length; i++) {
                                    if (selectedRegion6 ==
                                        map.THIRD_LEVEL_NAME) {
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
                                    style:
                                        new TextStyle(color: Colors.black87)),
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
                                    if (selectedRegion3 ==
                                        map.THIRD_LEVEL_NAME) {
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
                                    style:
                                        new TextStyle(color: Colors.black87)),
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
                                    if (selectedRegion ==
                                        map.THIRD_LEVEL_NAME) {
                                      _type = map.THIRD_LEVEL_ID;
                                      return map.THIRD_LEVEL_ID;
                                    }
                                  }
                                }).toList();
                                valuefirst = false;
                                list.clear();

                                _chapterData = _getChapterData(_type, _type3);
                              });
                            },
                            items: _region.map((Region map) {
                              return new DropdownMenuItem<String>(
                                value: map.THIRD_LEVEL_NAME,
                                child: new Text(map.THIRD_LEVEL_NAME,
                                    style:
                                        new TextStyle(color: Colors.black87)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      child: InkWell(
                        onTap: () {
                          callDatePicker();
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: TextFormField(
                            controller: dobController,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff000000),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter last submission date';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              dobController.text = value;
                            },
                            onChanged: (String value) {
                              dobController.text = value;
                            },
                            decoration: InputDecoration(
                                suffixIcon: Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Color(0xff017EFF),
                                    )),
                                suffixIconConstraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 15,
                                ),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 30, 0),
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
                                errorStyle:
                                    TextStyle(color: Colors.red, fontSize: 14),
                                counterText: "",
                                hintText: 'Last Submission Date',
                                hintStyle: TextStyle(
                                    color: Color(0xffBBBFC3), fontSize: 16),
                                fillColor: Color(0xfff9f9fb),
                                filled: true)),
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
                              if (_dropdownValue == "Select Content Type") {
                                setState(() {
                                  type = "";
                                });

                                print(type);
                              }
                              if (_dropdownValue == "GCL Content") {
                                setState(() {
                                  type = "A";
                                });

                                print(type);
                              }
                              if (_dropdownValue == "Self Content") {
                                setState(() {
                                  type = "I";
                                });

                                print(type);
                              }
                            });
                          },
                          items: <String>[
                            'Select Content Type',
                            'GCL Content',
                            'Self Content'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value,
                                  style: new TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _type != ""
                        ? Expanded(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 5),
                                margin: EdgeInsets.symmetric(
                                  horizontal: deviceSize.width * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Color(0xff2E2A4A),
                                    width: 0.5,
                                  ),
                                ),
                                child: ListView(children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Select All", style: normalText7),
                                      Container(
                                        padding: EdgeInsets.only(
                                          right: 25,
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor:
                                                Color(0xff2E2A4A),
                                          ),
                                          child: Checkbox(
                                            focusColor: Color(0xff2E2A4A),
                                            checkColor: Color(0xffffffff),
                                            activeColor: Color(0xff2E2A4A),
                                            value: this.valuefirst,
                                            onChanged: (bool value) {
                                              setState(() {
                                                isChecked.clear();
                                                isChecked1.clear();
                                                list.clear();
                                                this.valuefirst = value;

                                                if (valuefirst == true) {
                                                  for (int i = 0;
                                                      i < result.length;
                                                      i++) {
                                                    isChecked.add(true);
                                                    isChecked1.add(true);
                                                    list.add(result[i]['id']
                                                        .toString());
                                                    print(isChecked);
                                                    print(isChecked1);
                                                    print(list);
                                                  }
                                                } else if (valuefirst ==
                                                    false) {
                                                  for (int i = 0;
                                                      i < result.length;
                                                      i++) {
                                                    isChecked.add(false);
                                                    isChecked1.add(false);
                                                    list.remove(result[i]['id']
                                                        .toString());
                                                    print(isChecked);
                                                    print(isChecked1);
                                                    print(list);
                                                  }
                                                  /* if (isChecked.contains(true)) {
                                                enable = true;
                                              }
                                              else {
                                                enable = false;
                                              }*/
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  _type != "14"
                                      ? Container(
                                          child: chapterList(deviceSize))
                                      : Container(
                                          child: chapterList1(deviceSize))
                                ])))
                        : Container(),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          right: 8.0, left: 8, bottom: 30),
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
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (_type5 != "") {
                                if (_type != "") {
                                  if (type != "") {
                                    if (list.length != 0) {
                                      for (int i = 0; i < list.length; i++) {
                                        if (i == (list.length - 1)) {
                                          chapter_id =
                                              chapter_id + list[i].toString();
                                        } else {
                                          chapter_id = chapter_id +
                                              list[i].toString() +
                                              ",";
                                        }
                                      }
                                      Navigator.pushNamed(
                                        context,
                                        '/create-test-new',
                                        arguments: <String, String>{
                                          'chapter_id': chapter_id,
                                          'batch_id': _type5,
                                          'submission_date': dobController.text,
                                          'board_id': _type,
                                          'class_id': _type3,
                                          'content_type': type,
                                          'test_type': testType
                                        },
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please select any chapter.");
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please select content type.");
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please select board.");
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please select batch.");
                              }
                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
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
