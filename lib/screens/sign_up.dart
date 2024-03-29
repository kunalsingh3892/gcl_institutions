import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/CustomRadioWidget.dart';
import 'package:grewal/components/CustomRadioWidget1.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class SignIn extends StatefulWidget {
  final String modal;

  SignIn(this.modal);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final parentmobileController = TextEditingController();
  final passController = TextEditingController();
  final codeController = TextEditingController();
  bool _loading = false;
  bool _isHidden = true;
  bool isEnabled1 = true;

  bool isEnabled2 = false;

  Future _boardData;
  Future _classData;
  Future _countryData;
  Future _batchData;
  List<Region> _region = [];
  List<Region3> _region3 = [];
  List<Region4> _region4 = [];
  List<Region5> _region5 = [];
  var _type = "";

  var _type3 = "";
  var _type4 = "";
  var _type5 = "";
  String selectedRegion = "";
  String selectedRegion3 = "";
  String selectedRegion4 = "";
  String selectedRegion5 = "";
  String selectedRegion6 = "";
  String catData = "";
  String catData3 = "";
  String catData4 = "";
  String catData5 = "";
  bool _autoValidate = false;
  String user_id = "";
  String fcmToken = "";
  Stream<String> _tokenStream;
  StreamSubscription iosSubscription;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);

    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        _boardData = _getBoardCategories();
      });
    });
  }

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      fcmToken = token;
    });
  }

  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.blue);

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

                print(selectedRegion);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion == "") {
            selectedRegion = _region[0].THIRD_LEVEL_NAME;
            _type = _region[0].THIRD_LEVEL_ID;
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
          _countryData = _getCountryCategories();
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

                print(selectedRegion6);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion6 == "") {
            selectedRegion6 = _region5[0].THIRD_LEVEL_NAME;
            _type5 = _region5[0].THIRD_LEVEL_ID;
          }
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getCountryCategories() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/country"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData = jsonEncode(result);

          final json = JsonDecoder().convert(catData);
          _region4 =
              (json).map<Region4>((item) => Region4.fromJson(item)).toList();
          List<String> item = _region4.map((Region4 map) {
            for (int i = 0; i < _region4.length; i++) {
              if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                _type4 = map.THIRD_LEVEL_ID;

                print(selectedRegion4);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion4 == "") {
            selectedRegion4 = _region4[0].THIRD_LEVEL_CODE;
            selectedRegion5 = _region4[0].THIRD_LEVEL_NAME;
            _type4 = _region4[0].THIRD_LEVEL_ID;
          }
          _batchData = _getBatchCategories();
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  int id;

  String sent_id = "";
  Widget _radioBuilder() {
    return Container(
        margin: EdgeInsets.only(right: 10),
        child: Row(children: <Widget>[
          CustomRadioWidget1(
            value: 1,
            groupValue: id,
            groupName: "Pay by Student",
            onChanged: (val) {
              setState(() {
                id = 1;
                sent_id = "0";
              });
            },
          ),
          SizedBox(
            width: 20,
          ),
          CustomRadioWidget1(
            value: 2,
            groupValue: id,
            // focusColor: Color(0xFFe7bf2e),
            groupName: "Pay by Institute",
            onChanged: (val) {
              setState(() {
                id = 2;
                sent_id = "1";
              });
            },
          ),
        ]));
  }

  Widget _loginContent1() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: nameController,
                //  maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  nameController.text = value;
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
                    hintText: 'Enter Your Name',
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
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: emailController,
                // maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (value) {
                  emailController.text = value;
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
                    hintText: 'Enter Your Email',
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
              child: Padding(
                padding: EdgeInsets.only(right: 0, left: 3),
                child: new DropdownButton<String>(
                  isExpanded: true,
                  hint: new Text(
                    "Select Country",
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
                      List<String> item = _region4.map((Region4 map) {
                        for (int i = 0; i < _region4.length; i++) {
                          if (selectedRegion5 == map.THIRD_LEVEL_NAME) {
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
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              margin: const EdgeInsets.only(right: 5.0, left: 8),
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
                      "Select",
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
                            if (selectedRegion4 == map.THIRD_LEVEL_CODE) {
                              _type4 = map.THIRD_LEVEL_ID;
                              return map.THIRD_LEVEL_ID;
                            }
                          }
                        }).toList();
                      });
                    },
                    items: _region4.map((Region4 map) {
                      return new DropdownMenuItem<String>(
                        value: map.THIRD_LEVEL_CODE,
                        child: new Text(map.THIRD_LEVEL_CODE,
                            style: new TextStyle(color: Colors.black87)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8.0, left: 5),
                child: TextFormField(
                    controller: mobileController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    cursorColor: Color(0xff000000),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter mobile no.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      mobileController.text = value;
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
                        hintText: 'Enter Your Mobile No.',
                        hintStyle:
                            TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                        fillColor: Color(0xfff9f9fb),
                        filled: true)),
              ),
            ),
          ]),
          const SizedBox(height: 15.0),
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              margin: const EdgeInsets.only(right: 5.0, left: 8),
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
                      "Select",
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
                            if (selectedRegion4 == map.THIRD_LEVEL_CODE) {
                              _type4 = map.THIRD_LEVEL_ID;
                              return map.THIRD_LEVEL_ID;
                            }
                          }
                        }).toList();
                      });
                    },
                    items: _region4.map((Region4 map) {
                      return new DropdownMenuItem<String>(
                        value: map.THIRD_LEVEL_CODE,
                        child: new Text(map.THIRD_LEVEL_CODE,
                            style: new TextStyle(color: Colors.black87)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8.0, left: 5),
                child: TextFormField(
                    controller: parentmobileController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    cursorColor: Color(0xff000000),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter mobile no.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      parentmobileController.text = value;
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
                        hintText: 'Enter Your Parent\'s Mobile No.',
                        hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                        fillColor: Color(0xfff9f9fb),
                        filled: true)),
              ),
            ),
          ]),
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
                          if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
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
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: passController,
                obscureText: _isHidden,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: _isHidden
                              ? Text(
                                  "Show",
                                  style: TextStyle(
                                      color: Color(0xff017EFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                              : Text(
                                  "Hide",
                                  style: TextStyle(
                                      color: Color(0xff017EFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )),
                    ),
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
                    hintText: 'Choose your Password',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                "Payment Option",
                textAlign: TextAlign.left,
                style: normalText2,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _radioBuilder(),
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
                    if (selectedRegion4 != "") {
                      if (sent_id != "") {
                        setState(() {
                          _loading = true;
                        });
                        final msg = jsonEncode({
                          "name": nameController.text,
                          "email": emailController.text,
                          "country": _type4,
                          "class_id": _type3,
                          "board_id": _type,
                          "mobile": mobileController.text,
                          "parentmobile":parentmobileController.text,
                          "password": passController.text,
                          "referral_code": codeController.text,
                          "institute_id": user_id,
                          "payment_flag": sent_id,
                          "school_id": "-1",
                          "batch_id": _type5,
                        });
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                        };
                        var response = await http.post(
                          new Uri.https(
                              BASE_URL, API_PATH + "/institute-student-signup"),
                          body: {
                            "name": nameController.text,
                            "email": emailController.text,
                            "country": _type4,
                            "class_id": _type3,
                            "board_id": _type,
                            "mobile": mobileController.text,
                            "parentmobile":parentmobileController.text,
                            "password": passController.text,
                            "referral_code": codeController.text,
                            "institute_id": user_id,
                            "payment_flag": sent_id,
                            "school_id": "-1",
                            "batch_id": _type5,
                          },
                          headers: headers,
                        );
                        print(msg);

                        if (response.statusCode == 200) {
                          setState(() {
                            _loading = false;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var data = json.decode(response.body);
                          print(data);
                          var errorCode = data['ErrorCode'];
                          var errorMessage = data['ErrorMessage'];

                          if (errorCode == "0") {
                            setState(() {
                              _loading = false;
                            });
                            Fluttertoast.showToast(
                                msg: errorMessage + errorMessage.toString());
                            Navigator.of(context).pop();
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
                        Fluttertoast.showToast(
                            msg: "Please select payment option");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please select country code");
                    }
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
          ),
          /*  const SizedBox(height: 30.0),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/login-with-logo');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: normalText2,
                    ),
                    Text(
                      " Sign in",
                        style:normalText3,

                    )
                  ],
                ),
              ),
            ),
          ),*/
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.modal != ""
          ? AppBar(
              elevation: 0.0,
              leading: widget.modal != ""
                  ? Row(children: <Widget>[
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
                    ])
                  : Row(children: <Widget>[
                      IconButton(
                        icon: Image(
                          image: AssetImage("assets/images/list_icon.png"),
                          height: 20.0,
                          width: 10.0,
                          color: Color(0xff2E2A4A),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ]),
              centerTitle: true,
              title: Container(
                child: Text("Student Registration", style: normalText6),
              ),
              flexibleSpace: Container(
                height: 100,
                color: Color(0xffffffff),
              ),
              actions: <Widget>[
                /*  Align(
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
            )
          : null,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: Center(
            child: Align(
          alignment: Alignment.center,
          child: Container(
            child: SpinKitFadingCube(
              itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
                  ),
                );
              },
              size: 30.0,
            ),
          ),
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Container(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: _loginContent1(),
                ),
              ),
            ],
          ),
        ),
      ),
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

class Region4 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;
  final String THIRD_LEVEL_CODE;

  Region4({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME, this.THIRD_LEVEL_CODE});

  factory Region4.fromJson(Map<String, dynamic> json) {
    return new Region4(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['CountryName'],
      THIRD_LEVEL_CODE: json['CountryCode'],
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
