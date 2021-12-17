import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';



class Summary extends StatefulWidget {
  final Object argument;

  const Summary({Key key, this.argument}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Summary> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();
  String _dropdownValue = 'Select Student Type';
  String name = "";
  String profile_image = '';

  String user_id="";
  String class_id="";
  String board_id="";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String test_id = "";
  String student_id = "";
  String batch_id = "";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    student_id = data['student_id'];
    batch_id = data['batch_id'];
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

        _chapterData= _getChapterData();
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
      new Uri.https(BASE_URL, API_PATH + "/studentsummary"),
      body: {
        "batch_id":batch_id,
        "institute_id":user_id,
        "student_id":student_id
      },
      headers: headers,

    );
    print({
      "batch_id":batch_id,
      "institute_id":user_id,
      "student_id":student_id
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
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
  bool showExpand = true;
  bool showExpand2 = true;

  TextStyle normalText3 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);
  TextStyle normalText2 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TableRow _getDataRow1( data) {

    return TableRow(
      decoration: BoxDecoration(color: kDarkWhite),
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          alignment: Alignment.center,
          child: Container(
              child: AutoSizeText(data['total_test_institute'].toString(),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: normalText7)),
        ),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
            alignment: Alignment.center,
            child: Container(
                child: AutoSizeText(data['average_institute'].toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: normalText2))),


      ],
    );
  }

  TableRow _getDataRow(data) {

    return TableRow(
      decoration: BoxDecoration(color: kDarkWhite),
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          alignment: Alignment.center,
          child: Container(
              child: AutoSizeText(data['total_test_self'].toString(),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: normalText7)),
        ),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
            alignment: Alignment.center,
            child: Container(
                child: AutoSizeText(data['average_self'].toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: normalText2))),



      ],
    );
  }

  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data['ErrorCode']==0) {
            return
              Container(
                child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          setState(() {
                            showExpand=!showExpand;
                          });

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Color(0xffEEF7FE),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Color(0xff415EB6),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                                "Test Self",
                                                maxLines: 3,
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: normalText5
                                            ),
                                          ),

                                          const SizedBox(width: 5),
                                          showExpand?Icon(
                                            Icons.arrow_drop_up_outlined,
                                            color: Color(0xff017EFF),
                                            size: 24,
                                          ): Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff017EFF),
                                            size: 24,
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),


                      showExpand? Column(children: [
                        const SizedBox(height: 5),
                        Container(
                          child: Column(children: <Widget>[
                            Container(
                              child: Column(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 12, right: 10),
                                  child: Table(
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                          width: 0.2,
                                          color: Color(0xff2E2A4A),
                                        ),
                                        outside: BorderSide(width: 0.2)),
                                    // defaultColumnWidth: FixedColumnWidth(130),
                                    defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FlexColumnWidth(300.0),
                                      1: FlexColumnWidth(300.0),


                                    },
                                    children: [
                                      TableRow(
                                          decoration:
                                          BoxDecoration(color: Color(0xff017EFF)),
                                          children: [
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 8,
                                                    bottom: 8),
                                                alignment: Alignment.center,
                                                child: AutoSizeText('No. of self test attempted',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: normalText3)),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 8,
                                                    bottom: 8),
                                                alignment: Alignment.center,
                                                child: AutoSizeText('Avg %',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: normalText3)),


                                          ]),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 12, right: 10),
                                  child: Table(
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                          width: 0.2,
                                          color: Color(0xff2E2A4A),
                                        ),
                                        outside: BorderSide(
                                          width: 0.2,
                                          color: Color(0xff2E2A4A),
                                        )),
                                    defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FlexColumnWidth(300.0),
                                      1: FlexColumnWidth(300.0),


                                    },
                                    children: List.generate(
                                       1,
                                            (index) => _getDataRow(

                                            snapshot.data['Response']['Test_Self']
                                        )),
                                  ),
                                ),

                              ]),
                            ),


                          ]),
                        ),
                        const SizedBox(height: 5.0),
                      ],):Container(),
                      const SizedBox(height: 15),
                      new Container(
                          padding: EdgeInsets.only(left: 5,right: 5),
                          child: Divider(
                            color: Color(0xffE8E8E8),
                            thickness: 1,
                          )),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: (){
                          setState(() {
                            showExpand2=!showExpand2;
                          });

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Color(0xffEEF7FE),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Color(0xff415EB6),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                                "Test Institute",
                                                maxLines: 3,
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: normalText5
                                            ),
                                          ),

                                          const SizedBox(width: 5),
                                          showExpand2?Icon(
                                            Icons.arrow_drop_up_outlined,
                                            color: Color(0xff017EFF),
                                            size: 24,
                                          ): Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff017EFF),
                                            size: 24,
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),

                      showExpand2? Column(children: [
                        const SizedBox(height: 5),
                        Container(
                          child: Column(children: <Widget>[
                            Container(
                              child: Column(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 12, right: 10),
                                  child: Table(
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                          width: 0.2,
                                          color: Color(0xff2E2A4A),
                                        ),
                                        outside: BorderSide(width: 0.2)),
                                    // defaultColumnWidth: FixedColumnWidth(130),
                                    defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FlexColumnWidth(300.0),
                                      1: FlexColumnWidth(300.0),


                                    },
                                    children: [
                                      TableRow(
                                          decoration:
                                          BoxDecoration(color: Color(0xff017EFF)),
                                          children: [
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 8,
                                                    bottom: 8),
                                                alignment: Alignment.center,
                                                child: AutoSizeText('No. of institute test attempted',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: normalText3)),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 8,
                                                    bottom: 8),
                                                alignment: Alignment.center,
                                                child: AutoSizeText('Avg %',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: normalText3)),


                                          ]),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 12, right: 10),
                                  child: Table(
                                    border: TableBorder.symmetric(
                                        inside: BorderSide(
                                          width: 0.2,
                                          color: Color(0xff2E2A4A),
                                        ),
                                        outside: BorderSide(
                                          width: 0.2,
                                          color: Color(0xff2E2A4A),
                                        )),
                                    defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FlexColumnWidth(300.0),
                                      1: FlexColumnWidth(300.0),


                                    },
                                    children: List.generate(
                                        1,
                                            (index) => _getDataRow1(
                                            snapshot.data['Response']['Test_Institute']
                                        )),
                                  ),
                                ),


                              ]),
                            ),


                          ]),
                        ),
                        const SizedBox(height: 5.0),
                      ],):Container(),
                    ]
                ),
              );


          }
          else{
            return _emptyOrders();
          }

        }  else {
          return Center(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: SpinKitFadingCube(
                    itemBuilder: (_, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Color(0xff017EFF) :Color(0xffFFC700),
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
            style: TextStyle(fontSize: 20, letterSpacing: 1, color: Color(0xff2E2A4A)),
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
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),

          ]),
          centerTitle: true,
          title: Container(
            child: Text("Summary", style: normalText6),
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
        body:ModalProgressHUD(
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(child:
                    ListView(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: chapterList(deviceSize),
                          ),
                        ]
                    ),

                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )),
        )
    );
  }

}

