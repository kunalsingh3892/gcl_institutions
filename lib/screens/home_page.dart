import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/screens/update_profile.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<HomePage> {
  String _name = "";
  String _mobile = "";
  String email_id = '';
  String user_id = "";
  String class_id = "";
  String board_id = "";
  String profile_image = '';
  final completeController = TextEditingController();
  bool _loading = false;

  String bestPerformance = "0";
  String total_student = "0";
  String total_test_taken = "0";
  String total_batch = "0";
  String bestPerformancename = "0";
  String lasttestgiven = "0";
  String activestudent = "0";
  String banner = "";

  double avgPerformance = 0.0;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        _name = prefs.getString('name').toString();
        email_id = prefs.getString('email_id').toString();
        _mobile = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
        /* order_id = prefs.getString('order_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();*/
        profile_image = prefs.getString('profile_image').toString();

        GetConnect();
        _homeData();
      });
    });
  }

  Future _homeData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/institute-dashboard"),
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
      print(data);
      setState(() {
        bestPerformance = data['Response']['bestPerformance'].toString();
        total_student = data['Response']['total-student'].toString();
        total_test_taken = data['Response']['total-test-taken'].toString();
        total_batch = data['Response']['total-batch'].toString();
        bestPerformancename =
            data['Response']['bestPerformancename'].toString();
        lasttestgiven = data['Response']['lasttestgiven'].toString();
        activestudent = data['Response']['activestudent'].toString();
        avgPerformance =
            double.parse(data['Response']['avgPerformance'].toString());
        banner = data['Response']['banner'].toString();
      });

      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Text(
        "You are not Connected to Internet",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle normalText9 = GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText = GoogleFonts.inter(
      fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff2E2A4A));

  TextStyle normalText1 = GoogleFonts.inter(
      fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white);
  TextStyle normalText2 = GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText10 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff017EFF));
  TextStyle normalText8 = GoogleFonts.montserrat(
      fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText11 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff2E2A4A));
  TextStyle normalText12 = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));

  Widget _buildWikiCategory(
      String icon, String label, Color color, Color circle_color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),

      // height: 100,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: circle_color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 8.0),
          /* Text(
            label1,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w400),
          ),*/
          Text(
            label,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  buildUserInfo(context) => Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 20.0, left: 30, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.clear,
                    size: 20.0,
                    color: Color(0xff757D8A),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffffffff),
                  image: DecorationImage(
                    image: NetworkImage(profile_image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hello, " + _name,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff2E2A4A),
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Image(
                  image: AssetImage("assets/images/hand.png"),
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            ]),
            SizedBox(
              height: 5.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                email_id,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff2E2A4A),
                ),
              ),
            ),
          ],
        ),
      );
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));

  Future<bool> _logoutPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              "Are you sure",
            ),
            content: new Text("Do you want to Log Out?"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  "No",
                  style: TextStyle(
                    color: Color(0xff223834),
                  ),
                ),
              ),
              new FlatButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  //prefs.remove('logged_in');
                  setState(() {
                    prefs.clear();
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login-with-logo');
                  });
                },
                child:
                    new Text("Yes", style: TextStyle(color: Color(0xff223834))),
              ),
            ],
          ),
        )) ??
        false;
  }

  _launchCaller(String s) async {
    var url = "tel:" + s;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> whatsAppOpen(String s) async {
    var whatsappUrl = "whatsapp://send?phone=+91" + s;
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : showAlertDialog(
            context, ALERT_DIALOG_TITLE, "There is no whatsapp installed");
  }

  Widget buildDrawerItem() {
    return Flexible(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for (Draw item in drawerItems)
                InkWell(
                  onTap: () {
                    if (item.title == "Home") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/dashboard');
                    } else if (item.title == "Profile") {
                      /* Navigator.pop(context);
                          Navigator.pushNamed(context, '/update-profile');*/
                    }

                    /* else if (item.title == "Performance") {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/overall-performance',
                          );

                        }
                        else if (item.title == "MCQs") {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/test-list',
                            arguments: <String, String>{
                              'chapter_id': "",
                              'chapter_name': "",
                              'type': "outside"
                            },
                          );
                        }*/
                  },
                  child: ListTile(
                    leading: Text(
                      item.title,
                      style: normalText6,
                    ),
                  ),
                ),
              //upgrade(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/privacy-policy');
                },
                child: ListTile(
                  leading: Text(
                    "Privacy Policy",
                    style: normalText6,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/refund-policies');
                },
                child: ListTile(
                  leading: Text(
                    "Refund Policy",
                    style: normalText6,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/t-c');
                },
                child: ListTile(
                  leading: Text(
                    "Terms and Conditions",
                    style: normalText6,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
                child: ListTile(
                  leading: Text(
                    "Settings",
                    style: normalText6,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _launchCaller("9560102856");
                      },
                      child: Image(
                        image: AssetImage("assets/images/telephone.png"),
                        height: 30.0,
                        width: 30,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        whatsAppOpen("9560102856");
                      },
                      child: Image(
                        image: AssetImage("assets/images/whatsapp.png"),
                        height: 35.0,
                        width: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _launchInBrowser(
                            "https://www.facebook.com/Grewal-Academy-218288866835782/");
                      },
                      child: Image(
                        image: AssetImage("assets/images/facebook.png"),
                        height: 35.0,
                        width: 35,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _launchInBrowser(
                            "https://www.youtube.com/channel/UCJnneibYlAUKBH6SiLa1Z9Q");
                      },
                      child: Image(
                        image: AssetImage("assets/images/youtube.png"),
                        height: 35.0,
                        width: 35,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _launchInBrowser(
                            "https://www.instagram.com/invites/contact/?i=1wacb3ps73z2r&utm_content=mnnvbxj");
                      },
                      child: Image(
                        image: AssetImage("assets/images/instagram.png"),
                        height: 35.0,
                        width: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 60),
                child: InkWell(
                  onTap: () async {
                    _logoutPop();
                  },
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/log_out.png",
                      height: 20,
                    ),
                    title: Text(
                      'LogOut',
                      style: TextStyle(
                          color: Color(0xff2E2A4A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget announce(Size deviceSize) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      child: CarouselSlider.builder(
          options: CarouselOptions(
            //  height: deviceSize.height * 0.20,
            initialPage: 1,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          itemCount: 2,
          itemBuilder: (BuildContext context, int itemIndex) {
            if (itemIndex == 1) {
              return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2E2A4A),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffffffff),
                                        image: DecorationImage(
                                          image: NetworkImage(profile_image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Hello, " + _name,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/hand.png"),
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            email_id,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        /* Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Complete your profile ",
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),


                                ]),
                          ),
                        ),
*/
                      ],
                    ),
                  ));
            } else {
              return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 1, left: 10, right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: banner != ""
                            ? NetworkImage(banner)
                            : AssetImage('assets/images/back.jpeg'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Container(),
                  ));
            }
          }),
    );
  }

  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        /*drawer: Drawer(
          child: Column(
            children: <Widget>[
              buildUserInfo(context),
              buildDrawerItem(),
            ],
          ),
        ),*/
        body: isInternetOn
            ? SingleChildScrollView(
                child: Column(children: <Widget>[
                  /* Container(
                      child:

                          new Stack(
                        children: <Widget>[
                          new Container(
                            height: MediaQuery.of(context).size.height * .42,
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                                color: Color(0xff2E2A4A),
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(20.0),
                                  bottomRight: const Radius.circular(20.0),
                                )),
                          ),
                          new Container(
                            alignment: Alignment.topCenter,
                            padding: new EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .01,
                                right: 5.0,
                                left: 10.0),
                            child: Container(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 40, left: 5),
                                      child: InkWell(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                          IconButton(
                                            icon: Image(
                                              image: AssetImage(
                                                  "assets/images/list_icon.png"),
                                              height: 25.0,
                                              width: 25.0,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              _scaffoldKey.currentState
                                                  .openDrawer();
                                            },
                                          ),
                                              total_notification!=0?  InkWell(
                                                  onTap: () {

                                                    Navigator.pushNamed(context, '/notifications');
                                                  },
                                                child: Badge(
                                                  padding: EdgeInsets.all(5),
                                                  badgeColor:Color(0xff017EFF),
                                                  position: BadgePosition.topEnd(top: 1, end: 8),
                                                  animationDuration: Duration(milliseconds: 300),
                                                  animationType: BadgeAnimationType.fade,
                                                  badgeContent: Text(total_notification.toString(),style: TextStyle(color: Colors.white,fontSize: 13),),
                                                  child:  IconButton(
                                                      icon: const
                                                      Icon(Icons.notifications,color:Colors.white,size: 24,),
                                                  )
                                                ),
                                              ):IconButton(
                                                icon: const
                                                Icon(Icons.notifications,color:Colors.white,size: 24,),
                                                onPressed: () {

                                                  Navigator.pushNamed(context, '/notifications');
                                                },
                                              )
                                        ]),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(children: <Widget>[
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Hello, " + _name,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: normalText1,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    email_id,
                                                    style: normalText2,
                                                  ),
                                                ),
                                              ]),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/update-profile');
                                                },
                                                child: Stack(children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xffffffff),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            profile_image),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 22,
                                                        width: 22,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor,
                                                          ),
                                                          color:
                                                              Color(0xffFF317B),
                                                        ),
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                      )),
                                                ]),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    Container(
                                      decoration: new BoxDecoration(
                                          color: Color(0xffF9F9FB),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 3.0,
                                            ),
                                          ],
                                          borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(15.0),
                                              bottomLeft:
                                                  const Radius.circular(15.0),
                                              bottomRight:
                                                  const Radius.circular(15.0),
                                              topRight:
                                                  const Radius.circular(15.0))),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 30.0),
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                ),
                                                child: Text("My Progress",
                                                    style: normalText9),
                                              ),
                                            ),
                                            Container(
                                              child: new Stack(
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      child:
                                                          new CircularPercentIndicator(
                                                        //  radius: 45.0,
                                                        animation: true,
                                                        animationDuration: 1200,
                                                        radius: 120.0,
                                                        lineWidth: 5.0,
                                                        arcType: ArcType.HALF,
                                                        percent: avgPerformance / 100,
                                                        backgroundColor:
                                                            Color(0xffF2F2F2),

                                                        center: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  top: 30),
                                                          child: Column(
                                                              children: <Widget>[
                                                                Text(
                                                                    avgPerformance.toString() +
                                                                        "%",
                                                                    style:
                                                                        normalText10),
                                                                Center(
                                                                  child: Text(
                                                                      "Avg. Performance",
                                                                      style:
                                                                          normalText8),
                                                                ),
                                                              ]),
                                                        ),
                                                        linearGradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xff017EFF),
                                                            Color(0xff017EFF),
                                                          ],
                                                          begin: FractionalOffset
                                                              .topCenter,
                                                          end: FractionalOffset
                                                              .bottomCenter,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 80),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width:100,
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              total_student,
                                                                              style:
                                                                                  normalText11),
                                                                          Text(
                                                                              "No. of Students",
                                                                              style:
                                                                                  normalText12),
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Container(
                                                                    width:100,
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              total_batch,
                                                                              style:
                                                                                  normalText11),
                                                                          Text(
                                                                              "No. of Batches",
                                                                              style:
                                                                                  normalText12),
                                                                        ]),
                                                                  ),
                                                                ]),
                                                            SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width:100,
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              total_test_taken,
                                                                              style:
                                                                                  normalText11),
                                                                          Text(
                                                                              "Total Tests",
                                                                              style:
                                                                                  normalText12),
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Container(
                                                                    width:100,
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              bestPerformance+"%",
                                                                              style:
                                                                                  normalText11),
                                                                          Text(
                                                                              "Best Performance",
                                                                              style:
                                                                                  normalText12),
                                                                        ]),
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                    ),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),*/

                  Column(children: <Widget>[
                    announce(deviceSize),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: new BoxDecoration(
                          color: Color(0xffF9F9FB),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 3.0,
                            ),
                          ],
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(15.0),
                              bottomLeft: const Radius.circular(15.0),
                              bottomRight: const Radius.circular(15.0),
                              topRight: const Radius.circular(15.0))),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Text("My Progress", style: normalText9),
                              ),
                            ),
                            Container(
                              child: new Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: new CircularPercentIndicator(
                                        //  radius: 45.0,
                                        animation: true,
                                        animationDuration: 1200,
                                        radius: 120.0,
                                        lineWidth: 5.0,
                                        arcType: ArcType.HALF,
                                        percent: avgPerformance / 100,
                                        backgroundColor: Color(0xffF2F2F2),

                                        center: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 30),
                                          child: Column(children: <Widget>[
                                            Text(
                                                avgPerformance.toString() + "%",
                                                style: normalText10),
                                            Center(
                                              child: Text("Avg. Performance",
                                                  style: normalText8),
                                            ),
                                          ]),
                                        ),
                                        linearGradient: LinearGradient(
                                          colors: [
                                            Color(0xff017EFF),
                                            Color(0xff017EFF),
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 80),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(total_student,
                                                              style:
                                                                  normalText11),
                                                          Text(
                                                              "No. of Students",
                                                              style:
                                                                  normalText12),
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(total_batch,
                                                              style:
                                                                  normalText11),
                                                          Text("No. of Batches",
                                                              style:
                                                                  normalText12),
                                                        ]),
                                                  ),
                                                ]),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(total_test_taken,
                                                              style:
                                                                  normalText11),
                                                          Text("Total Tests",
                                                              style:
                                                                  normalText12),
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                              bestPerformancename,
                                                              style:
                                                                  normalText11),
                                                          Text("Best Performer",
                                                              style:
                                                                  normalText12),
                                                        ]),
                                                  ),
                                                ]),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(lasttestgiven,
                                                              style:
                                                                  normalText11),
                                                          Text(
                                                              "Last test given",
                                                              style:
                                                                  normalText12),
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(activestudent,
                                                              style:
                                                                  normalText11),
                                                          Text(
                                                              "Active Students",
                                                              style:
                                                                  normalText12),
                                                        ]),
                                                  ),
                                                ]),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 5,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign-up');
                            },
                            child: _buildWikiCategory(
                                "assets/images/tp.png",
                                "Student Registration",
                                Color(0xff567DF4),
                                Color(0xffEEF7FE)),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/batch-list');
                            },
                            child: _buildWikiCategory(
                                "assets/images/performance.png",
                                "Student Report Card",
                                Color(0xffFFB110),
                                Color(0xffFFFBEC)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 5,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/institute-test-list',
                              );
                            },
                            child: _buildWikiCategory(
                                "assets/images/mcq.png",
                                "Create a Test",
                                Color(0xffF45656),
                                Color(0xffFEEEEE)),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/leaderboard',
                              );
                            },
                            child: _buildWikiCategory(
                                "assets/images/leaderboard.png",
                                "Leader Board",
                                Color(0xff34DEDE),
                                Color(0xffF0FFFF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 5,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/question-chapter-select',
                              );
                            },
                            child: _buildWikiCategory(
                                "assets/images/add_question.png",
                                "Add Question",
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
                                '/notification-app',
                              );
                            },
                            child: _buildWikiCategory(
                                "assets/images/notification.png",
                                "Notification",
                                Color(0xff567DF4),
                                Color(0xffEEF7FE)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 5,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/upload-study-material',
                              );
                            },
                            child: _buildWikiCategory(
                                "assets/images/add_question.png",
                                "Upload Study\nMaterial",
                                Color(0xffFFB110),
                                Color(0xffFFFBEC)),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/upload-offline-test-paper',
                              );
                            },
                            child: _buildWikiCategory(
                                "assets/images/add_question.png",
                                "Upload Offline\Test",
                                Color(0xffF45656),
                                Color(0xffFEEEEE)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80.0),
                ]),
              )
            : buildAlertDialog(),
      ),
    );
  }

  bool iswificonnected = false;
  bool isInternetOn = true;
  var wifiBSSID;
  var wifiIP;
  var wifiName;

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
    }
  }

  final TextStyle stats = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);

  Widget _noInternet() {
    return Center(
      child: Container(child: Text('Please Check Internet Connection!!!')),
    );
  }
}
