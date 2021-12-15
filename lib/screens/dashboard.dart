import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'dart:io' as Io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/components/tab_item.dart';
import 'package:grewal/screens/sign_up.dart';
import 'package:grewal/screens/support_list.dart';
import 'package:grewal/screens/update_profile.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'chapters_list.dart';
import 'home_page.dart';
import 'institute_test_list.dart';
import 'leaderboard.dart';

class Dashboard extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

final tabs = ['', '', ''];

class _MainScreenState extends State<Dashboard> {
  int selectedPosition = 0;
  bool show_drawer1 = true;
  String name = '';
  String email_id = '';
  String mobile_no = '';
  String profile_image = '';
  String user_id = "";
  String order_id = "";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel;
  void initState() {
    super.initState();
   /* channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
*/
    //_requestPermissions();

    _getUser();
  }
  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        name = prefs.getString('name').toString();
        email_id = prefs.getString('email_id').toString();
        mobile_no = prefs.getString('mobile_no').toString();
        user_id = prefs.getString('user_id').toString();
      //  order_id = prefs.getString('order_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        //showNotification();

      });
    });
  }
  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  showNotification() async {

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('hhhhhhhhhhhh');

        /*Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));*/
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      RemoteNotification notification = message.notification;
      var data = message.data;

      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print("opnnnnnn");
        print(notification.body);
        print(data['moredata']);
        print(data['bigPicture']);

      final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl(data['bigPicture']));

      final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
          bigPicture,
          largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      contentTitle: notification.title,
      htmlFormatContentTitle: true,
      summaryText: notification.body,
      htmlFormatSummaryText: true);
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails( channel.id,
      channel.name,
      channel.description,
      icon: '@mipmap/ic_launcher',

      fullScreenIntent: true,
     /* importance: Importance.max,
      priority: Priority.high,*/
      ongoing: false,
      styleInformation: bigPictureStyleInformation);
      final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
      platformChannelSpecifics,

          payload:""

        );
      if(data['moredata']=="payment") {
        Navigator.pushNamed(
          context,
          '/plan',
          arguments: <String, String>{
            'order_id': order_id.toString(),
            'signupid': user_id.toString(),
            'mobile': mobile_no,
            'email': email_id,
            'out': 'in'
          },
        );
      }
      else if(data['moredata']=="model test paper"){
        Navigator.pushNamed(
          context,
          '/mts',
        );
      }
      else if(data['moredata']=="test"){
        Navigator.pushNamed(
          context,
          '/test-list',
          arguments: <String, String>{
            'chapter_id': "",
            'chapter_name': "",
            'type': "outside"
          },
        );
      }
      else{
        Navigator.pushNamed(context, '/dashboard');
      }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      var data = message.data;
      print(data);
        print("wffewf");
        print(notification.body);

        print(data['moredata']);
        print(data['bigPicture']);

        final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
            await _getByteArrayFromUrl(data['bigPicture']));
        final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
            bigPicture,
            largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
            contentTitle: notification.title,
            htmlFormatContentTitle: true,
            summaryText: notification.body,
            htmlFormatSummaryText: true);
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails( channel.id,
            channel.name,
            channel.description,
            icon: '@mipmap/ic_launcher',

            fullScreenIntent: true,
           // importance: Importance.max,
           // priority: Priority.high,
            ongoing: false,
            styleInformation: bigPictureStyleInformation);
        final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            platformChannelSpecifics
          ,

            payload:""

        );
        if(data['moredata']=="payment") {
          Navigator.pushNamed(
            context,
            '/plan',
            arguments: <String, String>{
              'order_id': order_id.toString(),
              'signupid': user_id.toString(),
              'mobile': mobile_no,
              'email': email_id,
              'out': 'in'
            },
          );
        }
        else if(data['moredata']=="model test paper"){
          Navigator.pushNamed(
            context,
            '/mts',
          );
        }
        else if(data['moredata']=="test"){
          Navigator.pushNamed(
            context,
            '/test-list',
            arguments: <String, String>{
              'chapter_id': "",
              'chapter_name': "",
              'type': "outside"
            },
          );
        }
        else{
          Navigator.pushNamed(context, '/dashboard');
        }

    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              "Are you sure",
            ),
            content: new Text("Do you want to exit the App"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  "No",
                  style: TextStyle(
                    color: Color(0xff2E2A4A),
                  ),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  exit(0);
                },
                child:
                    new Text("Yes", style: TextStyle(color: Color(0xff2E2A4A))),
              ),
            ],
          ),
        )) ??
        false;
  }

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  buildUserInfo(context) => Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 25.0, left: 30, top: 50),
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
             Row(
                mainAxisSize: MainAxisSize.max,

                  children: <Widget>[
               Expanded(
                 child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Hello, " + name,
                          maxLines: 2,
                          softWrap: true,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff2E2A4A),
                          ),
                        ),

                  ),
               ),

               /* SizedBox(
                  width: 5.0,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Image(
                        image: AssetImage("assets/images/hand.png"),
                        height: 20.0,
                        width: 20.0,
                      ),
                ),*/


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
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  _launchCaller(String s) async {
    var url = "tel:"+s;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
  Future<void> whatsAppOpen(String s) async {
    var whatsappUrl = "whatsapp://send?phone=+91"+s;
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
        child:

        SingleChildScrollView(
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
                    }
                    else if (item.title == "Profile") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/update-profile');
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
                      onTap: (){
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
                      onTap: (){
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
                      onTap: (){
                        _launchInBrowser("https://www.facebook.com/Grewal-Academy-218288866835782/");

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
                      onTap: (){
                        _launchInBrowser("https://www.youtube.com/channel/UCJnneibYlAUKBH6SiLa1Z9Q");

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
                      onTap: (){
                        _launchInBrowser("https://www.instagram.com/invites/contact/?i=1wacb3ps73z2r&utm_content=mnnvbxj");

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

  Widget _name() {
    if (selectedPosition == 0) {
      return Container(
        child: Text("My Dashboard", style: normalText5),
      );
    } else if (selectedPosition == 1) {
      return Container(
        child: Text("Test List ", style: normalText5),
      );
    } else if (selectedPosition == 2) {
      return Container(
        child: Text("Student Registration", style: normalText5),
      );
    }
    else if (selectedPosition == 3) {
      return Container(
        child: Text("Leaderboard", style: normalText5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              buildUserInfo(context),
              buildDrawerItem(),
            ],
          ),
        ),
        appBar:AppBar(
          elevation: 0.0,
          leading: InkWell(
            child: Row(children: <Widget>[
              IconButton(
                icon: Image(
                  image: AssetImage("assets/images/list_icon.png"),
                  height: 25.0,
                  width: 25.0,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ]),
          ),
          centerTitle: true,
          title: _name(),
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

        bottomNavigationBar: _buildBottomTab(),
        body: _children[selectedPosition],
      ),
    );
  }

  final List<Widget> _children = [
    HomePage(),
    InstituteTestList(""),
    SignIn(""),
    LeaderBoard(""),
  ];

  _buildBottomTab() {
    return Container(
      height: kBottomNavigationBarHeight,
      width: MediaQuery.of(context).size.width,
      child: BottomAppBar(
        color: Colors.white,
        notchMargin: 6,
        elevation: 0.0,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              TabItem(
                icon: "assets/images/dash_1.png",
                dot: "•",
                isSelected: selectedPosition == 0,
                onTap: () {
                  setState(() {
                    selectedPosition = 0;
                  });
                },
              ),
              TabItem(
                icon: "assets/images/mcq.png",
                dot: "•",
                isSelected: selectedPosition == 1,
                onTap: () {
                  setState(() {
                    selectedPosition = 1;
                  });
                },
              ),
              TabItem(
                icon: "assets/images/tp.png",
                dot: "•",
                isSelected: selectedPosition == 2,
                onTap: () {
                  setState(() {
                    selectedPosition = 2;
                  });
                },
              ),
              TabItem(
                icon: "assets/images/leaderboard.png",
                dot: "•",
                isSelected: selectedPosition == 3,
                onTap: () {
                  setState(() {
                    selectedPosition = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
