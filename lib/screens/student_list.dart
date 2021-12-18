import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class StudentList extends StatefulWidget {
  final Object argument;

  const StudentList({Key key, this.argument}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<StudentList> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();
  String _dropdownValue = 'Select Student Type';
  String _dropdownValueBatch = 'Select Batch';
  String name = "";
  String profile_image = '';
  List<UserDetails> _userDetails = [];
  List<UserDetails> _searchResult = [];
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String batch_id = "";
  // List batch_list=[];
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    batch_id = data['batch_id'];
    // var temp=jsonDecode(data['batch_list'].toString());

    _getUser();
  }

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

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();

        profile_image = prefs.getString('profile_image').toString();

        _chapterData = _getChapterData("");
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  List<bool> showExpand = new List();
  Future _getChapterData(String name) async {
    _searchResult.clear();
    _userDetails.clear();
    completeController.text = "";
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/institute-student-list"),
      body: {
        "institute_id": user_id,
        "batch_id": batch_id,
        "payment_type": name,
      },
      headers: headers,
    );
    print({
      "institute_id": user_id,
      "batch_id": batch_id,
      "payment_type": name,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['ErrorCode'] == 0) {
        var result = data['Response'];
        setState(() {
          for (Map user in result) {
            _userDetails.add(UserDetails.fromJson(user));
          }
        });
        for (int i = 0; i < data['Response'].length; i++) {
          showExpand.add(false);
        }
      }
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget _buildWikiCategory(
      String icon, String label, Color color, Color circle_color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      // height: 100,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: circle_color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color,
            radius: 20,
            child: Image(
              image: AssetImage(icon),
              height: 18.0,
              width: 18.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              label,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['ErrorCode'] == 0) {
            return _searchResult.length != 0 ||
                    completeController.text.isNotEmpty
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _searchResult.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                showExpand[index] = !showExpand[index];
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      _searchResult[index].name,
                                                      maxLines: 3,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: normalText5),
                                                ),
                                                showExpand[index]
                                                    ? Icon(
                                                        Icons
                                                            .arrow_drop_up_outlined,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      ),
                                              ],
                                            ),
                                            Container(
                                              child: Text(
                                                  _searchResult[index].mobile,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: normalText7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              showExpand[index]
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/test-list',
                                                      arguments: <String,
                                                          String>{
                                                        'user_id':
                                                            _searchResult[index]
                                                                .id
                                                                .toString(),
                                                        'chapter_name': "",
                                                        'type': "outside"
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/performance.png",
                                                      "Tests - Self",
                                                      Color(0xff415EB6),
                                                      Color(0xffEEF7FE)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/overall-performance',
                                                      arguments: <String,
                                                          String>{
                                                        'user_id':
                                                            _searchResult[index]
                                                                .id
                                                                .toString(),
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/performance.png",
                                                      "Overall Performance (Total)",
                                                      Color(0xffAC4141),
                                                      Color(0xffFEEEEE)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/institute-test-list-performance',
                                                      arguments: <String,
                                                          String>{
                                                        'user_id':
                                                            _searchResult[index]
                                                                .id
                                                                .toString(),
                                                        'chapter_name': "",
                                                        'type': "outside"
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/performance.png",
                                                      "Tests - Institution",
                                                      Color(0xff38CD8B),
                                                      Color(0xffE9FFF5)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Expanded(
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                      ],
                                    )
                                  : Container(),
                              new Container(
                                  padding: EdgeInsets.only(left: 15, right: 10),
                                  child: Divider(
                                    color: Color(0xffE8E8E8),
                                    thickness: 1,
                                  )),
                            ]),
                          );
                        }),
                  )
                : Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data['Response'].length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                showExpand[index] = !showExpand[index];
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      snapshot.data['Response']
                                                          [index]['name'],
                                                      maxLines: 3,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: normalText5),
                                                ),
                                                showExpand[index]
                                                    ? Icon(
                                                        Icons
                                                            .arrow_drop_up_outlined,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            Color(0xff017EFF),
                                                        size: 24,
                                                      ),
                                              ],
                                            ),
                                            snapshot.data['Response'][index]
                                                        ['mobile'] !=
                                                    null
                                                ? Container(
                                                    child: Text(
                                                        snapshot
                                                            .data['Response']
                                                                [index]
                                                                ['mobile']
                                                            .toString(),
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: normalText7),
                                                  )
                                                : Container(
                                                    child: Text("",
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: normalText7),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              showExpand[index]
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/test-list',
                                                      arguments: <String,
                                                          String>{
                                                        'user_id': snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                        'chapter_name': "",
                                                        'type': ""
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/student_test.png",
                                                      "Test - Self",
                                                      Color(0xff415EB6),
                                                      Color(0xffEEF7FE)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/overall-performance',
                                                      arguments: <String,
                                                          String>{
                                                        'user_id': snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/performance.png",
                                                      "Overall Performance (Total)",
                                                      Color(0xffAC4141),
                                                      Color(0xffFEEEEE)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/institute-test-list-performance',
                                                      arguments: <String,
                                                          String>{
                                                        'user_id': snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                        'chapter_name': "",
                                                        'type': "institute"
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/student_test.png",
                                                      "Test - Institution",
                                                      Color(0xff38CD8B),
                                                      Color(0xffE9FFF5)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/student-summary',
                                                      arguments: <String,
                                                          String>{
                                                        'student_id': snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                        'batch_id': batch_id
                                                      },
                                                    );
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/stu_summary.png",
                                                      "Summary",
                                                      Color(0xffFFB110),
                                                      Color(0xffFFFBEC)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    /* Navigator.pushNamed(
                                            context,
                                            '/institute-test-list-performance',
                                            arguments: <String, String>{
                                              'user_id': snapshot.data['Response'][index]['id'].toString(),
                                              'chapter_name': "",
                                              'type': "institute"
                                            },
                                          );*/
                                                    _moveBatchDialog(
                                                        snapshot
                                                            .data['Response']
                                                                [index]['id']
                                                            .toString(),
                                                        batch_id);
                                                  },
                                                  child: _buildWikiCategory(
                                                      "assets/images/student_test.png",
                                                      "Move - Batch",
                                                      Color(0xff34DEDE),
                                                      Color(0xffF0FFFF)),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Container(
                                                width: 174.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                      ],
                                    )
                                  : Container(),
                              new Container(
                                  padding: EdgeInsets.only(left: 15, right: 10),
                                  child: Divider(
                                    color: Color(0xffE8E8E8),
                                    thickness: 1,
                                  )),
                            ]),
                          );
                        }),
                  );
          } else {
            return _emptyOrders();
          }
        } else {
          return Center(
              child: Align(
            alignment: Alignment.center,
            child: Container(
              child: SpinKitFadingCube(
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          index.isEven ? Color(0xff017EFF) : Color(0xffFFC700),
                    ),
                  );
                },
                size: 30.0,
              ),
            ),
          ));
        }
      },
    );
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

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          leading: Row(children: <Widget>[
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
          centerTitle: true,
          title: Container(
            child: Text("List Of Students", style: normalText6),
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
          inAsyncCall: isLoading,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.02,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 8.0, left: 8),
                      padding: EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Color(0xfff9f9fb),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.0,
                            color: Color(0xfff9f9fb),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                              if (_dropdownValue == "Paid") {
                                name = "1";
                                _chapterData = _getChapterData(name);
                              } else if (_dropdownValue ==
                                  "Select Student Type") {
                                name = "";
                                _chapterData = _getChapterData(name);
                              } else {
                                name = "0";
                                _chapterData = _getChapterData(name);
                              }

                              print(_dropdownValue);
                              print(name);
                            });
                          },
                          items: <String>[
                            'Select Student Type',
                            'Paid',
                            'UnPaid'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value,
                                  style: new TextStyle(
                                    color: Colors.black87,
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: new TextField(
                                enabled: true,
                                controller: completeController,
                                decoration: InputDecoration(
                                  fillColor: Color(0xfff9f9fb),
                                  filled: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 30, 30, 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  counterText: "",
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff200E32),
                                    size: 24,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Color(0xffBBBFC3), fontSize: 16),
                                  hintText: 'Search Student... ',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                textCapitalization: TextCapitalization.none,
                                onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                        ),
                        /* SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.20,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        height: 15,
                        child: Image(
                            image: AssetImage('assets/images/filter.png'),
                            height: 15,
                            width: 15,
                            fit: BoxFit.fill),
                      ),*/
                      ]),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: chapterList(deviceSize),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )),
        ));
  }

  _moveBatchDialog(id, batch_id) async {
    // final editController = TextEditingController();
    var alert = new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text("Move Batch"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return new Row(
            children: <Widget>[
              new Expanded(
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    value: _dropdownValueBatch,
                    isDense: true,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (String newValue) {
                      _dropdownValueBatch = newValue;
                      setState(() {});
                    },
                    items: <String>['gaurav', 'batch 1']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value,
                            style: new TextStyle(
                              color: Colors.black87,
                            )),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          );
        },
      ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            }),
        new FlatButton(
            child: const Text('CONFIRM'),
            onPressed: () {
              _moveBatch(id, batch_id);
            })
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _moveBatch(student_id, batch_id) async {
    print(jsonEncode({
      "institute_id": user_id,
      "batch_id": batch_id.toString(),
      "student_id": student_id.toString()
    }));
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/batch-move-student"),
      body: {
        "institute_id": user_id,
        "batch_id": batch_id.toString(),
        "student_id": student_id.toString()
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(data);
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  onSearchTextChanged(String text) async {
    print(text);
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          userDetail.mobile
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });
    print(_searchResult);

    setState(() {});
  }
}

class UserDetails {
  final String id, name, mobile;

  UserDetails({
    this.id,
    this.name,
    this.mobile,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
        id: json['id'].toString(),
        name: json['name'].toString(),
        mobile: json['mobile'].toString());
  }
}
