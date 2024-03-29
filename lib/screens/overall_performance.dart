import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/indicator.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

import '../constants.dart';

class OverAllPerformance extends StatefulWidget {
  final Object argument;

  const OverAllPerformance({Key key, this.argument}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

const double degrees2Radians = math.pi / 180.0;

class _SettingsState extends State<OverAllPerformance> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xff2E2A4A),
      letterSpacing: 1);
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText9 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText8 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextStyle normalText1 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff22215B));
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText4 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText10 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText11 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff017EFF));
  TextStyle normalText12 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xffFF317B));
  TextStyle correct = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xff4CE364));
  TextStyle incorrect = GoogleFonts.montserrat(
      fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xffFF3131));
  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);

  final completeController = TextEditingController();

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String test_id = "";
  String profile_image = '';
  String users_id = '';
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    users_id = data['user_id'];
    _tooltipBehavior = TooltipBehavior(enable: true);
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        _chapterData = _getPerformanceData();
      });
    });
  }

  TooltipBehavior _tooltipBehavior;

  Future _getPerformanceData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/questiontypeperformance"),
      body: {"user_id": users_id},
      headers: headers,
    );
    print({"user_id": users_id});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['question_type'].length != 0) {
        setState(() {
          if (data['question_type'].length == 3) {
            chartData = [
              ChartData(
                  data['question_type'][0]['questiontype_name'],
                  double.parse(data['question_type'][0]['total_percentage']),
                  data['question_type'][0]['total_question'].toString(),
                  data['question_type'][0]['question_type_id'].toString(),
                  Color(0xff017EFF)),
              ChartData(
                  data['question_type'][1]['questiontype_name'],
                  double.parse(data['question_type'][1]['total_percentage']),
                  data['question_type'][1]['total_question'].toString(),
                  data['question_type'][1]['question_type_id'].toString(),
                  Color(0xffFFC700)),
              ChartData(
                  data['question_type'][2]['questiontype_name'],
                  double.parse(data['question_type'][2]['total_percentage']),
                  data['question_type'][2]['total_question'].toString(),
                  data['question_type'][2]['question_type_id'].toString(),
                  Color(0xff4CE364)),
            ];
          } else if (data['question_type'].length == 2) {
            chartData = [
              ChartData(
                  data['question_type'][0]['questiontype_name'],
                  double.parse(data['question_type'][0]['total_percentage']),
                  data['question_type'][0]['total_question'].toString(),
                  data['question_type'][0]['question_type_id'].toString(),
                  Color(0xff017EFF)),
              ChartData(
                  data['question_type'][1]['questiontype_name'],
                  double.parse(data['question_type'][1]['total_percentage']),
                  data['question_type'][1]['total_question'].toString(),
                  data['question_type'][1]['question_type_id'].toString(),
                  Color(0xffFFC700)),
            ];
          } else {
            chartData = [
              ChartData(
                  data['question_type'][0]['questiontype_name'],
                  double.parse(data['question_type'][0]['total_percentage']),
                  data['question_type'][0]['total_question'].toString(),
                  data['question_type'][0]['question_type_id'].toString(),
                  Color(0xff017EFF)),
            ];
          }
        });
      }

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  int _currentSliderValue = 2;

  int touchedIndex = -1;

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['question_type'].length != 0) {
            return Container(
              width: deviceSize.width,
              height: deviceSize.height * 0.50,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      bottomLeft: const Radius.circular(20.0),
                      bottomRight: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
              child: Column(children: [
                Container(
                  child: Text("Question Wise Analysis", style: normalText6),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: SfCircularChart(
                      tooltipBehavior: _tooltipBehavior,
                      legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          height: "150",
                          padding: 20,
                          orientation: LegendItemOrientation.vertical,
                          textStyle: normalText5),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartData, String>(
                          animationDuration: 2000,
                          // enableSmartLabels: true,
                          enableTooltip: true,
                          explode: true,
                          dataSource: chartData,
                          onPointTap: (ChartPointDetails details) {
                            print(details.pointIndex);
                            if (details.pointIndex == 0) {
                              for (int i = 0; i < chartData.length; i++) {
                                if (details.pointIndex == i) {
                                  print(chartData[i].z);
                                  Navigator.pushNamed(
                                    context,
                                    '/overall-performance-details',
                                    arguments: <String, String>{
                                      'question_id': chartData[i].z.toString(),
                                      'users_id': users_id.toString(),
                                    },
                                  );
                                }
                              }
                            } else if (details.pointIndex == 1) {
                              for (int i = 0; i < chartData.length; i++) {
                                if (details.pointIndex == i) {
                                  print(chartData[i].z);
                                  Navigator.pushNamed(
                                    context,
                                    '/overall-performance-details',
                                    arguments: <String, String>{
                                      'question_id': chartData[i].z.toString(),
                                      'users_id': users_id.toString(),
                                    },
                                  );
                                }
                              }
                            } else if (details.pointIndex == 2) {
                              for (int i = 0; i < chartData.length; i++) {
                                if (details.pointIndex == i) {
                                  print(chartData[i].z);
                                  Navigator.pushNamed(
                                    context,
                                    '/overall-performance-details',
                                    arguments: <String, String>{
                                      'question_id': chartData[i].z.toString(),
                                      'users_id': users_id.toString(),
                                    },
                                  );
                                }
                              }
                            }
                          },
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                          ),
                          dataLabelMapper: (ChartData sales, _) =>
                              sales.y1.toString() +
                              " (" +
                              sales.y.toString() +
                              "%" +
                              ") ",
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,

                          radius: "100",
                          innerRadius: "40",
                        )
                      ]),
                )
              ]),
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
        style: TextStyle(fontSize: 20, letterSpacing: 1, color: Colors.white),
      )),
    );
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

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        // Navigator.pushNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff2E2A4A),
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
            child: Text("Over All Performance", style: normalText6),
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
        body: Container(
          color: Color(0xff2E2A4A),
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            child: chapterList(deviceSize),
          ),
        ),
      ),
    );
  }

  Container buildCircle(
    Color color,
    String s,
    double d, {
    double width = 100,
    double height = 100,
  }) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      child: InkWell(
        child: new Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(20.0),
          //I used some padding without fixed width and height
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            // You can use like this way or like the below line
            //                borderRadius: new BorderRadius.circular(30.0),
            color: color,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(s, style: normalText3),
                  SizedBox(
                    height: 5,
                  ),
                  Text(d.round().toString() + "%", style: normalText3),
                ]),
          ),
          alignment: Alignment.center,
          // You can add a Icon instead of text also, like below.
          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.z, [this.color]);
  final String x;
  final double y;
  final String y1;
  final String z;
  final Color color;
}
