import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/color_constants.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class InstituteTestList extends StatefulWidget {
  final String modal;

  InstituteTestList(this.modal);
  /*final Object argument;

  const InstituteTestList({Key key, this.argument}) : super(key: key);*/

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<InstituteTestList> {
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

  String user_id = "";
  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String profile_image = '';
  String payment = '';
  String total_test_quetion = '';
  String _mobile = "";
  String email_id = '';
  String order_id = "";
  String users_id = "";

  @override
  void initState() {
    super.initState();
    /* var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);*/
    /* users_id = data['user_id'];
    chapter_name = data['chapter_name'];
    type = data['type'];
    print(type);*/
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        //  order_id = prefs.getString('order_id').toString();
        profile_image = prefs.getString('profile_image').toString();

        _chapterData = _getChapterData();
      });
    });
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

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }

  Future _getChapterData() async {
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

    print(jsonEncode({
      "institute_id": user_id,
    }));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      /* setState(() {
        payment = data['student_info']['payment_flag'].toString();
        total_test_quetion = data['total_test'].toString();
      });*/

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  showConfirmDialog(id, cancel, done, title, content) {
    print(id);

    Widget cancelButton = FlatButton(
      child: Text(cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget doneButton = FlatButton(
      child: Text(done),
      onPressed: () {
        Navigator.of(context).pop();
        removeItemFromCart(id);
      },
    );

    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        doneButton,
      ],
    );

    // Show the Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void removeItemFromCart(Id) async {
    final msg = jsonEncode({
      "test_id": Id,
      "user_id": user_id,
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/test-delete"),
      body: {
        "test_id": Id,
        "user_id": user_id,
      },
      headers: headers,
    );
    print(msg);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var errorCode = data['ErrorCode'];
      var errorMessage = data['ErrorMessage'];

      if (errorCode == 0) {
        Fluttertoast.showToast(msg: "Deleted Successfully");
        setState(() {
          _chapterData = _getChapterData();
        });
      } else {
        showAlertDialog(context, ALERT_DIALOG_TITLE, errorMessage);
      }
    } else {
      throw Exception('Something went wrong');
    }
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
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/test-dash',
                            arguments: <String, String>{
                              'test_id': snapshot.data['Response'][index]
                                      ['institute_test_id']
                                  .toString(),
                              'test_name': snapshot.data['Response'][index]
                                      ['name']
                                  .toString()
                            },
                          );
                        },
                        child: Column(children: <Widget>[
                          Stack(children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              color: Color(0xffF9F9FB),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                        height: 50,
                                        width: 50,
                                        decoration: new BoxDecoration(
                                            // color: Color(0xffF6F6F6),
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(5.0),
                                                bottomLeft:
                                                    const Radius.circular(5.0),
                                                bottomRight:
                                                    const Radius.circular(5.0),
                                                topRight: const Radius.circular(
                                                    5.0))),
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff017EFF),
                                          radius: 40,
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/ribbon.png',
                                            ),
                                            height: 22.0,
                                            width: 22.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                    snapshot.data['Response']
                                                        [index]['name'],
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: normalText5),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Text(
                                                snapshot.data['Response'][index]
                                                    ['created_at'],
                                                maxLines: 1,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: normalText7),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*   SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      color: Color(0xff017EFF),
                                      size: 20,
                                    )*/
                                  ]),
                            ),
                          ]),
                        ]),
                      ),
                      secondaryActions: <Widget>[
                        /*  snapshot.data['Response'][index]['is_taken'] == 0
                            ? IconSlideAction(
                          caption: 'Delete',
                          color: Color(0xff017EFF),
                          icon: Icons.delete,
                          onTap: () {
                            showConfirmDialog(
                                snapshot.data['Response'][index]['id']
                                    .toString(),
                                'Cancel',
                                'Remove',
                                'Remove Item',
                                'Are you sure want to remove this item?');
                          },
                        )
                            : Container(),*/
                      ],
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
        'NO TEST FOUND!',
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
                child: Text("Test List", style: normalText6),
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
      /* floatingActionButton:  FloatingActionButton.extended(

          onPressed: () {
            Navigator.pushNamed(
              context,
              '/chapter-select',
            );
          },
          backgroundColor:Color(0xff017EFF),
          label: Text("Create"),
          icon: Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation,*/

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
                  /* Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: deviceSize.width*0.30,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:Color(0xff017EFF), elevation: 2),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/chapter-select',
                            );
                          },
                          child: Row(
                            children: [
                              Icon( Icons.add),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Create'),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                  SizedBox(
                    height: 5.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: chapterList(deviceSize),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     width: deviceSize.width * 0.30,
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           primary: Color(0xff017EFF), elevation: 2),
                  //       onPressed: () {
                  //         Navigator.pushNamed(
                  //           context,
                  //           '/chapter-select-2',
                  //         );
                  //       },
                  //       child: Row(
                  //         children: [
                  //           Icon(Icons.add),
                  //           SizedBox(
                  //             width: 10.0,
                  //           ),
                  //           Text('Create'),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/chapter-select-2',
              );
            },
            child: Text(
              "Create",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
