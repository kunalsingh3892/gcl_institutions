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


class LeaderBoard extends StatefulWidget {
  final String modal;

  LeaderBoard(this.modal);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<LeaderBoard> {
  bool _value = false;
  Future _chapterData;
  bool isLoading = false;
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white);
  TextStyle normalText9 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.underline,);
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Colors.white);
  TextStyle normalText8 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final completeController = TextEditingController();

  String profile_image = '';
  List<UserDetails> _userDetails = [];
  List<UserDetails> _searchResult = [];
  String user_id="";
  String class_id="";
  String board_id="";
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String batch_id = "";
  List<Region3> _region3 = [];
  String selectedRegion3 ;
  String catData3 = "";
  Future _testData;
  var _type3="";
  @override
  void initState() {
    super.initState();

    _getUser();



  }

  Future _getTestCategories() async {

    Map<String, String> headers = {
     // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/institute-test-list"),
      body: {
        "institute_id": user_id,

      },
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
        });

      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
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
        _testData=_getTestCategories();
        _chapterData= _getChapterData("");
      });
    });
  }

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }
  List<bool> showExpand = new List();
  Future _getChapterData(String type3) async {
  /*  _searchResult.clear();
    _userDetails.clear();
    completeController.text = "";*/

    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/institute-leader-board"),
      body: {
        "institute_id":user_id,
        "inst_test_id":type3

      },
      headers: headers,

    );
    print({
      "institute_id":user_id,
      "inst_test_id":type3
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
  /*    if(data['ErrorCode']==0) {
        var result = data['Response'];
        setState(() {
          for (Map user in result) {
            _userDetails.add(UserDetails.fromJson(user));
          }
        });
        for (int i = 0; i < data['Response'].length; i++) {
          showExpand.add(false);
        }
      }*/
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }



  Widget chapterList(Size deviceSize) {
    return FutureBuilder(
      future: _chapterData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data['ErrorCode']==0) {
            if(snapshot.data['Response']['leaderBoard'].length!=0) {
              return /*_searchResult.length != 0 ||
                completeController.text.isNotEmpty
                ?Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _searchResult.length,
                  itemBuilder: (context, index) {
                    return  InkWell(
                      onTap: (){
                        setState(() {
                          showExpand[index]=!showExpand[index];
                        });

                      },
                      child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                                                    _searchResult[index].name,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: normalText5
                                                ),
                                              ),

                                              showExpand[index]?Icon(
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

                                          Container(
                                            child: Text(
                                                _searchResult[index].mobile,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: normalText7
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),

                            showExpand[index]? Column(children: [
                              const SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 5, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/test-list',
                                            arguments: <String, String>{
                                              'user_id': _searchResult[index].id.toString(),
                                              'chapter_name': "",
                                              'type': "outside"
                                            },
                                          );
                                        },
                                        child: _buildWikiCategory(
                                            "assets/images/performance.png",
                                            "Test Wise Performance",
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
                                            arguments: <String, String>{
                                              'user_id': _searchResult[index].id.toString(),
                                            },
                                          );


                                        },
                                        child: _buildWikiCategory(
                                            "assets/images/performance.png",
                                            "Overall Performance",
                                            Color(0xffAC4141),
                                            Color(0xffFEEEEE)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 5.0),
                            ],):Container(),
                            new Container(
                                padding: EdgeInsets.only(left: 15,right: 10),
                                child: Divider(
                                  color: Color(0xffE8E8E8),
                                  thickness: 1,
                                )),
                          ]
                      ),
                    );
                  }

              ),
            ):*/
                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data['Response']['leaderBoard']
                          .length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {


                          },
                          child: Column(
                              children: <Widget>[
                                const SizedBox(height: 10.0),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 1),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
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
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 15),

                                                    child: Text(
                                                        (index + 1).toString(),
                                                        maxLines: 3,
                                                        softWrap: true,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: normalText5
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 45,
                                                    height: 45,

                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xffffffff),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot
                                                                .data['Response']['leaderBoard'][index]['profile_image']),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Container(

                                                              child: Text(
                                                                  snapshot
                                                                      .data['Response']['leaderBoard'][index]['student_name'],
                                                                  maxLines: 3,
                                                                  softWrap: true,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: normalText5
                                                              ),
                                                            ),

                                                            snapshot
                                                                .data['Response']['leaderBoard'][index]['batch_name'] !=
                                                                null
                                                                ? Container(
                                                              child: Text(
                                                                  snapshot
                                                                      .data['Response']['leaderBoard'][index]['batch_name']
                                                                      .toString(),
                                                                  maxLines: 2,
                                                                  softWrap: true,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: normalText7
                                                              ),
                                                            )
                                                                : Container(
                                                              child: Text(
                                                                  "",
                                                                  maxLines: 2,
                                                                  softWrap: true,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: normalText7
                                                              ),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5,
                                                        bottom: 5),

                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius
                                                          .circular(20.0),
                                                    ),
                                                    child: Text(
                                                        snapshot
                                                            .data['Response']['leaderBoard'][index]['percent']
                                                            .toString() + "%",
                                                        maxLines: 3,
                                                        softWrap: true,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: normalText8
                                                    ),
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ),

                                new Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 10),
                                    child: Divider(
                                      color: Color(0xffffffff),
                                      thickness: 0.2,
                                    )),
                                const SizedBox(height: 10.0),
                              ]
                          ),
                        );
                      }

                  ),
                );
            }
            else{
              return _emptyOrders();
            }
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
            style: TextStyle(fontSize: 20, letterSpacing: 1, color: Colors.white),
          )),
    );
  }



  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.modal != ""?AppBar(
          elevation: 0.0,
          leading: widget.modal != ""? Row(children: <Widget>[
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

          ]):Row(children: <Widget>[
            IconButton(
              icon: Image(
                image: AssetImage("assets/images/list_icon.png"),
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
            child: Text("Leaderboard", style: normalText6),
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
        ):null,
        body:ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xff2E2A4A),

              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceSize.width * 0.01,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                   /* Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      margin: EdgeInsets.only( bottom: 10),
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
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  counterText: "",
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Color(0xfff9f9fb),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
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
                                  hintText: 'Search your chapters... ',
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
                        *//* SizedBox(
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
                      ),*//*
                      ]),
                    ),*/
                    InkWell(
                      onTap: (){
                        setState(() {
                          _type3="";
                          selectedRegion3=null;
                          _chapterData= _getChapterData("");
                        });

                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("No Filter", style: normalText9),
                            Container(

                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                              "Select Test",
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
                                _chapterData = _getChapterData(_type3);

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
                    const SizedBox(height: 20.0),
                    Expanded(child:
                    Container(
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
        )
    );
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
          .contains(text.toLowerCase())||
          userDetail.mobile
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase())

      )
        _searchResult.add(userDetail);
    });
    print(_searchResult);

    setState(() {});
  }
}

class UserDetails {
  final String id,
      name,
      mobile;

  UserDetails(
      {this.id,
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

class Region3 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region3({ this.THIRD_LEVEL_ID,  this.THIRD_LEVEL_NAME});


  factory Region3.fromJson(Map<String, dynamic> json) {
    return new Region3(
      THIRD_LEVEL_ID: json['institute_test_id'].toString(),
      THIRD_LEVEL_NAME: json['name'],
    );
  }
}