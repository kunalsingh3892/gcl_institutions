import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class QuestionView extends StatefulWidget {
  final Object argument;

  const QuestionView({Key key, this.argument}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<QuestionView> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));

  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));

  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();

  String profile_image = '';
  String test_id = "";
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String api_token = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    test_id = data['test_id'];
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
        order_id = prefs.getString('order_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        total_test_quetion = prefs.getString('total_test').toString();
        payment = prefs.getString('payment').toString();
        api_token = prefs.getString('api_token').toString();
        _chapterData = _getChapterData();
      });
    });
  }

  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL,
          API_PATH + "/institute-test-submited_list_question_overview"),
      body: {"test_id": test_id},
      headers: headers,
    );
    print({
      "test_id": test_id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['ErrorCode'] == 0) {
        for (int i = 0; i < data['Response']['question_list'].length; i++) {
          showExpand.add(false);
        }
      }
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  List<bool> showExpand = new List();
  List _items = [];
  Future readJson() async {
    final String response =
        await rootBundle.loadString('assets/images/sample.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
      for (int i = 0; i < _items.length; i++) {
        showExpand.add(false);
      }
    });

    return _items;
  }

  Widget _buildWikiCategory(
      String icon, String label, Color color, Color circle_color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      // height: 100,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: circle_color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              icon,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: normalText5,
            ),
          ),
          const SizedBox(height: 5.0),
          Center(
            child: Text(
              label,
              maxLines: 3,
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: normalText4,
            ),
          ),
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
            if (snapshot.data['Response']['question_list'].length != 0) {
              return Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        snapshot.data['Response']['question_list'].length,
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
                                horizontal: 5.0, vertical: 10),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            /* Expanded(
                                                    child: Text(
                                                        snapshot
                                                            .data['Response']['question_list'][index]['question'],
                                                        maxLines: 10,
                                                        softWrap: true,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: normalText5
                                                    ),
                                                  ),*/
                                            Expanded(
                                              child: Html(
                                                data: snapshot.data['Response']
                                                        ['question_list'][index]
                                                    ['question'],
                                                style: {
                                                  "table": Style(
                                                    backgroundColor:
                                                        Color.fromARGB(0x50,
                                                            0xee, 0xee, 0xee),
                                                  ),
                                                  "tr": Style(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black),
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      left: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  "th": Style(
                                                    padding: EdgeInsets.all(6),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  "td": Style(
                                                    padding: EdgeInsets.all(6),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                  'h5': Style(
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow
                                                          .ellipsis),
                                                },
                                              ),
                                            ),
                                            showExpand[index]
                                                ? Icon(
                                                    Icons
                                                        .arrow_drop_up_outlined,
                                                    color: Color(0xff017EFF),
                                                    size: 24,
                                                  )
                                                : Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color(0xff017EFF),
                                                    size: 24,
                                                  ),
                                          ],
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
                                          left: 5, right: 5, bottom: 5, top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: _buildWikiCategory(
                                                  "Chapter",
                                                  snapshot.data['Response']
                                                          ['question_list']
                                                      [index]['chapter_name'],
                                                  Color(0xff415EB6),
                                                  Color(0xffEEF7FE)),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: _buildWikiCategory(
                                                  "Topic",
                                                  snapshot.data['Response']
                                                          ['question_list']
                                                      [index]['topic_name'],
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
                                          left: 5, right: 5, bottom: 5, top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/stu-list',
                                                  arguments: <String, String>{
                                                    'test_id': test_id,
                                                    'question_id': snapshot
                                                        .data['Response']
                                                            ['question_list']
                                                            [index]
                                                            ['question_id']
                                                        .toString(),
                                                    'result_type': "R",
                                                  },
                                                );
                                              },
                                              child: _buildWikiCategory(
                                                  "Right %",
                                                  snapshot.data['Response']
                                                          ['question_list']
                                                          [index]['R']
                                                      .toString(),
                                                  Color(0xff38CD8B),
                                                  Color(0xffE9FFF5)),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/stu-list',
                                                  arguments: <String, String>{
                                                    'test_id': test_id,
                                                    'question_id': snapshot
                                                        .data['Response']
                                                            ['question_list']
                                                            [index]
                                                            ['question_id']
                                                        .toString(),
                                                    'result_type': "W",
                                                  },
                                                );
                                              },
                                              child: _buildWikiCategory(
                                                  "Wrong %",
                                                  snapshot.data['Response']
                                                          ['question_list']
                                                          [index]['W']
                                                      .toString(),
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
                                          left: 5, right: 5, bottom: 5, top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: _buildWikiCategory(
                                                  "Parameter",
                                                  snapshot.data['Response']
                                                          ['question_list']
                                                      [index]['parameter'],
                                                  Color(0xff38CD8B),
                                                  Color(0xffE9FFF5)),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
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
                              padding: EdgeInsets.only(left: 5, right: 5),
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
            child: Text("Question View", style: normalText6),
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
                  horizontal: deviceSize.width * 0.01,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
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
}
