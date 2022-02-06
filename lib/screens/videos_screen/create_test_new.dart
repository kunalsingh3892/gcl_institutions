import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/models/topic_json.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';

class CreateQuestionNew extends StatefulWidget {
  final Object argument;

  const CreateQuestionNew({Key key, this.argument}) : super(key: key);

  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<CreateQuestionNew> {
  Future<dynamic> _topicData;

  bool _loading = false;
  var access_token;
  var mcqController = TextEditingController(text: "");
  List<TopicJson> topicData = new List();
  var detailController = TextEditingController(text: "");
  List<TextEditingController> _controllersMCQ = new List();
  List<TextEditingController> _controllersDetail = new List();
  bool showList = false;
  bool valuefirst = false;
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String batch_id = "";
  String lastSubmissionDate = "";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String profile_image = '';
  List<bool> isChecked = new List();
  List<bool> isChecked1 = new List();
  var _value = 10.0;
  var _value1 = 10.0;
  List<String> list = [];
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String value1 = "0";
  String value2 = "0";

  var _type5 = "";

  String selectedRegion6;

  String catData5 = "";

  int mcq_total = 0;
  int detail_total = 0;
  String mcq1 = "0";
  String mcq2 = "0";
  String mcq3 = "0";
  String detail1 = "0";
  String detail2 = "0";
  String detail3 = "0";
  String content_type = "";
  String test_type = "";
  List<Region5> _region5 = [];

  bool onChange = false;

  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    batch_id = data['batch_id'];
    lastSubmissionDate = data['submission_date'];
    board_id = data['board_id'];
    class_id = data['class_id'];
    content_type = data['content_type'];
    test_type = data['test_type'];
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();

        _topicData = _getTopicData();
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

  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff22215B));
  Future _getTopicData() async {
    Map<String, String> headers = {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/topiclistchapterwise"),
      body: {
        "chapter_id": chapter_id,
      },
      headers: headers,
    );
    print(new Uri.https(BASE_URL, API_PATH + "/topiclistchapterwise"));
    print({
      "chapter_id": chapter_id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      if (mounted) {
        setState(() {
          catData5 = jsonEncode(result);

          final json = JsonDecoder().convert(catData5);
          List temp = [];
          json.forEach((e) {
            if (test_type == "O") {
              if (e['totalmcq'] != 0) {
                temp.add(e);
              }
            } else {
              if (e['totaldetails'] != 0) {
                temp.add(e);
              }
            }
          });
          _region5 =
              (temp).map<Region5>((item) => Region5.fromJson(item)).toList();
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
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget topicList(Size deviceSize) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: topicData.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xff2E2A4A).withOpacity(0.40)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                            "Topic " +
                                (index + 1).toString() +
                                ": " +
                                topicData[index].topicName,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: normalText2),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        topicData.removeAt(index);
                        mcq_total = 0;
                        detail_total = 0;
                        for (int i = 0; i < topicData.length; i++) {
                          if (test_type == "O") {
                            mcq_total =
                                mcq_total + int.parse(topicData[i].attempt);
                          } else {
                            detail_total =
                                detail_total + int.parse(topicData[i].attempt);
                          }
                        }
                      });
                      print(jsonEncode(topicData));
                    },
                    child: Icon(
                      Icons.clear,
                      size: 20.0,
                      color: Color(0xff757D8A),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      test_type == "O"
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      topicData[index].attempt.toString() +
                                          " MCQ",
                                      style: normalText1),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    topicData[index]
                                            .attempt
                                            .toString()
                                            .toString() +
                                        " Detailed",
                                    style: normalText1,
                                  ),
                                ],
                              ),
                            ),
                    ]),
              ]),
            );
          }),
    );
  }

  Widget chapterList(Size deviceSize) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: <
        Widget>[
      // test_type == "O"
      //     ? Container(
      //         width: deviceSize.width,
      //         decoration: new BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: new BorderRadius.only(
      //                 topLeft: const Radius.circular(10.0),
      //                 bottomLeft: const Radius.circular(10.0),
      //                 bottomRight: const Radius.circular(10.0),
      //                 topRight: const Radius.circular(10.0))),
      //         margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      //         padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
      //         child: Column(children: [
      //           Container(
      //             child: Text("No. of Questions", style: normalText6),
      //           ),
      //           Center(
      //             child: Container(
      //               width: MediaQuery.of(context).size.width,
      //               margin: EdgeInsets.only(left: 5, right: 5),
      //               child: Row(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: <Widget>[
      //                     Container(
      //                       height: 25,
      //                       width: MediaQuery.of(context).size.width * 0.09,
      //                       decoration: BoxDecoration(
      //                         gradient: LinearGradient(
      //                           begin: Alignment.topCenter,
      //                           end: Alignment.bottomCenter,
      //                           colors: [
      //                             Color(0xff567DF4),
      //                             Color(0xff567DF4),
      //                           ],
      //                         ),
      //                         borderRadius: BorderRadius.circular(3),
      //                       ),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: <Widget>[
      //                           Text(
      //                             '10',
      //                             // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
      //                             style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontSize: 13,
      //                                 fontWeight: FontWeight.bold),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                     Container(
      //                       width: MediaQuery.of(context).size.width * 0.70,
      //                       child: SliderTheme(
      //                         data: SliderTheme.of(context).copyWith(
      //                           activeTrackColor: Color(0xFFe7bf2e),
      //                           inactiveTrackColor: Color(0xff567DF4),
      //                           trackShape: RoundedRectSliderTrackShape(),
      //                           trackHeight: 3.0,
      //                           thumbShape: RoundSliderThumbShape(
      //                               enabledThumbRadius: 12.0),
      //                           thumbColor: Color(0xFFe7bf2e),
      //                           overlayColor: Colors.red.withAlpha(32),
      //                           overlayShape: RoundSliderOverlayShape(
      //                               overlayRadius: 28.0),
      //                           tickMarkShape: RoundSliderTickMarkShape(),
      //                           activeTickMarkColor: Color(0xFFe7bf2e),
      //                           inactiveTickMarkColor: Color(0xFFe7bf2e),
      //                           valueIndicatorShape:
      //                               PaddleSliderValueIndicatorShape(),
      //                           valueIndicatorColor: Color(0xFFe7bf2e),
      //                           valueIndicatorTextStyle: TextStyle(
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                         child: Slider(
      //                           value: _value,
      //                           min: 10,
      //                           max: 40,
      //                           divisions: 3,
      //                           label: '$_value',
      //                           onChanged: (value) {
      //                             setState(
      //                               () {
      //                                 _value = value;
      //                               },
      //                             );
      //                           },
      //                         ),
      //                       ),
      //                     ),
      //                     Container(
      //                       height: 25,
      //                       width: MediaQuery.of(context).size.width * 0.09,
      //                       decoration: BoxDecoration(
      //                         gradient: LinearGradient(
      //                           begin: Alignment.topCenter,
      //                           end: Alignment.bottomCenter,
      //                           colors: [
      //                             Color(0xff567DF4),
      //                             Color(0xff567DF4),
      //                           ],
      //                         ),
      //                         borderRadius: BorderRadius.circular(3),
      //                       ),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: <Widget>[
      //                           Text(
      //                             "40",
      //                             // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
      //                             style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontSize: 14,
      //                                 fontWeight: FontWeight.bold),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ]),
      //             ),
      //           ),
      //         ]),
      //       )
      //     : Container(
      //   width: deviceSize.width,
      //   decoration: new BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: new BorderRadius.only(
      //           topLeft: const Radius.circular(10.0),
      //           bottomLeft: const Radius.circular(10.0),
      //           bottomRight: const Radius.circular(10.0),
      //           topRight: const Radius.circular(10.0))),
      //   margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      //   padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
      //   child: Column(children: [
      //     Container(
      //       child: Text("Detailed %", style: normalText6),
      //     ),
      //     Center(
      //       child: Container(
      //         width: MediaQuery.of(context).size.width,
      //         margin: EdgeInsets.only(left: 5, right: 5),
      //         child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Container(
      //                 height: 25,
      //                 width: MediaQuery.of(context).size.width * 0.09,
      //                 decoration: BoxDecoration(
      //                   gradient: LinearGradient(
      //                     begin: Alignment.topCenter,
      //                     end: Alignment.bottomCenter,
      //                     colors: [
      //                       Color(0xff567DF4),
      //                       Color(0xff567DF4),
      //                     ],
      //                   ),
      //                   borderRadius: BorderRadius.circular(3),
      //                 ),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: <Widget>[
      //                     Text(
      //                       '10',
      //                       // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
      //                       style: TextStyle(
      //                           color: Colors.white,
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.70,
      //                 child: SliderTheme(
      //                   data: SliderTheme.of(context).copyWith(
      //                     activeTrackColor: Color(0xFFe7bf2e),
      //                     inactiveTrackColor: Color(0xff567DF4),
      //                     trackShape: RoundedRectSliderTrackShape(),
      //                     trackHeight: 3.0,
      //                     thumbShape: RoundSliderThumbShape(
      //                         enabledThumbRadius: 12.0),
      //                     thumbColor: Color(0xFFe7bf2e),
      //                     overlayColor: Colors.red.withAlpha(32),
      //                     overlayShape: RoundSliderOverlayShape(
      //                         overlayRadius: 28.0),
      //                     tickMarkShape: RoundSliderTickMarkShape(),
      //                     activeTickMarkColor: Color(0xFFe7bf2e),
      //                     inactiveTickMarkColor: Color(0xFFe7bf2e),
      //                     valueIndicatorShape:
      //                         PaddleSliderValueIndicatorShape(),
      //                     valueIndicatorColor: Color(0xFFe7bf2e),
      //                     valueIndicatorTextStyle: TextStyle(
      //                       color: Colors.white,
      //                     ),
      //                   ),
      //                   child: Slider(
      //                     value: _value1,
      //                     min: 10,
      //                     max: 100,
      //                     divisions: 9,
      //                     label: '$_value1',
      //                     onChanged: (value) {
      //                       setState(
      //                         () {
      //                           _value1 = value;
      //                         },
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 height: 25,
      //                 width: MediaQuery.of(context).size.width * 0.09,
      //                 decoration: BoxDecoration(
      //                   gradient: LinearGradient(
      //                     begin: Alignment.topCenter,
      //                     end: Alignment.bottomCenter,
      //                     colors: [
      //                       Color(0xff567DF4),
      //                       Color(0xff567DF4),
      //                     ],
      //                   ),
      //                   borderRadius: BorderRadius.circular(3),
      //                 ),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: <Widget>[
      //                     Text(
      //                       "100",
      //                       // snapshot.data['cart_quantity'] > 0 ? 'Go to Basket' : 'Add to Basket',
      //                       style: TextStyle(
      //                           color: Colors.white,
      //                           fontSize: 14,
      //                           fontWeight: FontWeight.bold),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ]),
      //       ),
      //     ),
      //   ]),
      // ),
      Container(
        width: deviceSize.width,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
        child: Column(children: [
          Container(
            child: Text("Select Topic", style: normalText6),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                      value: selectedRegion6,
                      // isDense: true,
                      itemHeight: 100,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRegion6 = newValue;

                          List<String> item = _region5.map((Region5 map) {
                            for (int i = 0; i < _region5.length; i++) {
                              if (selectedRegion6 == map.THIRD_LEVEL_NAME) {
                                _type5 = map.THIRD_LEVEL_ID;

                                if (test_type == "O") {
                                  mcqController.text = map.totalmcq.toString();
                                  if (mcqController.text.isEmpty) {
                                    setState(() {
                                      onChange = false;
                                    });
                                  } else {
                                    setState(() {
                                      onChange = true;
                                    });
                                  }
                                } else {
                                  detailController.text =
                                      map.totaldetails.toString();
                                  if (detailController.text.isEmpty) {
                                    setState(() {
                                      onChange = false;
                                    });
                                  } else {
                                    setState(() {
                                      onChange = true;
                                    });
                                  }
                                }

                                return map.THIRD_LEVEL_ID;
                              }
                            }
                          }).toList();
                        });
                      },
                      items: _region5.map((Region5 map) {
                        return new DropdownMenuItem<String>(
                          value: map.THIRD_LEVEL_NAME,
                          child: test_type == "O"
                              ? Text(
                                  map.THIRD_LEVEL_NAME.toUpperCase() +
                                      " - " +
                                      map.totalmcq +
                                      " MCQ",
                                  style: new TextStyle(color: Colors.black87))
                              : Text(
                                  map.THIRD_LEVEL_NAME.toUpperCase() +
                                      " - " +
                                      map.totaldetails +
                                      " Detailed",
                                  style: new TextStyle(color: Colors.black87)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    test_type == "O"
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 8.0, left: 5),
                                  child: TextFormField(
                                      controller: mcqController,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Color(0xff000000),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (value) {
                                        return null;
                                      },
                                      onSaved: (value) {
                                        mcqController.text = value;
                                      },
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            onChange = false;
                                          });
                                        } else {
                                          setState(() {
                                            onChange = true;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10, 20, 30, 0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          counterText: "",
                                          hintStyle: TextStyle(
                                              color: Color(0xffBBBFC3),
                                              fontSize: 16),
                                          fillColor: Color(0xfff9f9fb),
                                          filled: true)),
                                ),
                                SizedBox(height: 5),
                                Text("MCQ", style: normalText1),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 8.0, left: 5),
                                  child: TextFormField(
                                      controller: detailController,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Color(0xff000000),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (value) {
                                        return null;
                                      },
                                      onSaved: (value) {
                                        detailController.text = value;
                                      },
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            onChange = false;
                                          });
                                        } else {
                                          setState(() {
                                            onChange = true;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10, 20, 20, 0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          counterText: "",
                                          hintStyle: TextStyle(
                                              color: Color(0xffBBBFC3),
                                              fontSize: 16),
                                          fillColor: Color(0xfff9f9fb),
                                          filled: true)),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Detailed",
                                  style: normalText1,
                                ),
                              ],
                            ),
                          ),
                  ]),
            ]),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              margin: EdgeInsets.only(right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff017EFF), elevation: 2),
                onPressed: () {
                  if (_type5 != "") {
                    if (onChange) {
                      TopicJson topicJson = new TopicJson();
                      setState(() {
                        topicJson.topicid = _type5;
                        topicJson.topicName = selectedRegion6;
                        if (test_type == "O") {
                          topicJson.attempt = mcqController.text != ""
                              ? mcqController.text
                              : "0";
                        } else {
                          topicJson.attempt = detailController.text != ""
                              ? detailController.text
                              : "0";
                        }

                        topicData.add(topicJson);
                        print(jsonEncode(topicData));
                        mcq_total = 0;
                        detail_total = 0;
                        for (int i = 0; i < topicData.length; i++) {
                          if (test_type == "O") {
                            mcq_total =
                                mcq_total + int.parse(topicData[i].attempt);
                          } else {
                            detail_total =
                                detail_total + int.parse(topicData[i].attempt);
                          }
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please enter at least one value...");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please select topic");
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Add'),
                  ],
                ),
              ),
            ),
          ),
          topicList(deviceSize)
        ]),
      ),
    ]);
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
        // image: DecorationImage(
        //   image: NetworkImage(profile_image),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    String testFor = test_type == "O" ? "Objective" : "Subjective";
    return Scaffold(
      key: _scaffoldKey,
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
                // Navigator.pushNamed(context, '/dashboard');
              },
            ),
          ]),
        ),
        centerTitle: true,
        title: Container(
          child: Text("Create Test\n(" + testFor + ")",
              textAlign: TextAlign.center, style: normalText6),
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
              // child: _networkImage1(
              //   profile_image,
              // ),
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
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 10.0),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, bottom: 10, top: 5),
                      decoration: BoxDecoration(
                        color: Color(0xff2E2A4A),
                      ),
                      child: ListView(children: <Widget>[
                        Container(child: chapterList(deviceSize))
                      ]))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      test_type == "O"
                          ? Expanded(
                              child: Center(
                                child: Container(
                                  color: Colors.white,
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  // padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'MCQ',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        mcq_total.toString(),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Container(
                                  color: Colors.white,
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  // padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Detailed',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        detail_total.toString(),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Expanded(
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                _loading = true;
                              });

                              int totalQue = 0;
                              topicData.forEach((element) {
                                totalQue = totalQue +
                                    int.parse(element.attempt.toString());
                              });
                              print(totalQue);
                              final msg = jsonEncode({
                                "batch_id": batch_id,
                                "contenttype": content_type,
                                "submission_date": lastSubmissionDate,
                                "board_id": board_id,
                                "class_id": class_id,
                                "total_question": totalQue.toString(),
                                "question_type":
                                    test_type == "O" ? "objective" : "",
                                "institute_id": user_id,
                                "chapter": chapter_id,
                                "topiclist": topicData
                              });
                              Map<String, String> headers = {
                                'Accept': 'application/json',
                                'Content-Type': 'application/json',
                              };
                              print(msg);
                              var response = await http.post(
                                new Uri.https(BASE_URL,
                                    API_PATH + "/institute-test-createnew"),
                                body: msg,
                                headers: headers,
                              );

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
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, '/institute-test-list');
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  showAlertDialog(context, ALERT_DIALOG_TITLE,
                                      errorMessage);
                                }
                              }
                            },
                            child: Container(
                              height: 60,
                              color: Color(0xff017EFF),
                              width: MediaQuery.of(context).size.width * 0.50,
                              // padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
  final String totalmcq;
  final String totaldetails;

  Region5(
      {this.THIRD_LEVEL_ID,
      this.THIRD_LEVEL_NAME,
      this.totalmcq,
      this.totaldetails});

  // ignore: missing_return
  factory Region5.fromJson(Map<String, dynamic> json) {
    // ignore: unrelated_type_equality_checks

    return new Region5(
      THIRD_LEVEL_ID: json['topic_id'].toString(),
      THIRD_LEVEL_NAME: json['name'],
      totalmcq: json['totalmcq'].toString(),
      totaldetails: json['totaldetails'].toString(),
    );
  }
}
