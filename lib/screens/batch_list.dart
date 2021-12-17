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


class BatchList extends StatefulWidget {
  final String modal;

  BatchList(this.modal);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<BatchList> {
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

  String batchName = '';
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
  @override
  void initState() {
    super.initState();
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

  Widget _networkImage(url) {
    return Image(
      image: NetworkImage(url),
    );
  }
  List<bool> showExpand = new List();
  Future _getChapterData() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/batch-list"),
      body: {
        "institute_id":user_id
      },
      headers: headers,

    );
    print({
      "institute_id":user_id
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(data);
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Widget _buildWikiCategory(
      String icon, String label, Color color, Color circle_color, String batchId) {
    batchName = label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      // height: 100,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: circle_color,
        borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: color,
            width: 0.5,
          ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
         /* CircleAvatar(
            backgroundColor: color,
            radius: 20,
            child: Image(
              image: AssetImage(icon),
              height: 18.0,
              width: 18.0,
            ),
          ),*/
         // const SizedBox(width: 10.0),
          Expanded(
            child: Center(
              child: Text(
                batchName,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

           IconButton(onPressed: (){
             _showRenameDialog(batchId);
           }, icon: Icon ( Icons.edit , size: 20,), )
        ],
      ),
    );
  }

  _showRenameDialog(String batchId) async {
    final editController = TextEditingController();
     var alert = new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text ("Rename"),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: editController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter New Batch Name', hintText: 'eg. Batch 1'),
              ),
            )
          ],
        ),


        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('SAVE'),
              onPressed: () {
                _renameBatch(editController.text, batchId).then((value) => {
                  setState(() {
                    _chapterData= _getChapterData();
                  }
                  ),
                Navigator.pop(context)

              }
                );
                //Navigator.pop(context);

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

  Future _renameBatch(String newName, String batchId) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/batch-edit"),
      body: {
        "institute_id":user_id,
        "batch_id":batchId,
        "batch_name":newName
      },
      headers: headers,

    );
    print({
      "institute_id":user_id
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(data);
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
          if(snapshot.data['Response'].length!=0) {
            return
            Container(
              child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: (2 / 1),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  children:
                  List.generate(snapshot.data['Response'].length, (index) {
                    return InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                          context,
                          '/student-list',
                          arguments: <String, String>{
                            'batch_id': snapshot.data['Response']
                            [index]['id'].toString(),
                          },
                        );
                      },
                      child: Container(
                      //  height: 50,
                        padding: EdgeInsets.only(
                            bottom: 10, top: 10,left: 10,right: 10),
                        child: _buildWikiCategory(
                                    "assets/images/ordered_list.png",
                                    snapshot.data['Response'][index]['batch_name'],
                                    index%2==0?Color(0xff415EB6): Color(0xffF45656),
                                    index%2==0? Color(0xffEEF7FE):Color(0xffFEEEEE),
                                    snapshot.data['Response'][index]['id'].toString()
                        ),
                      ),
                    );
                  }))

              /*  ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data['Response'].length,
                  itemBuilder: (context, index) {
                    return  InkWell(
                      onTap: (){

                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(

                                child: _buildWikiCategory(
                                    "assets/images/ordered_list.png",
                                    snapshot.data['Response'][index]['batch_name'],
                                    Color(0xff415EB6),
                                    Color(0xffEEF7FE)),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: InkWell(

                                child: _buildWikiCategory(
                                    "assets/images/mcq.png",
                                    snapshot.data['Response'][index]['batch_name'],
                                    Color(0xff415EB6),
                                    Color(0xffFEEEEE)),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  }

              ),*/
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
                Navigator.pushNamed(context, '/dashboard');
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
                Navigator.pushNamed(context, '/dashboard');
              },
            ),

          ]),
          centerTitle: true,
          title: Container(
            child: Text("Batch List", style: normalText6),
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
        ):null,
        floatingActionButton:  FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/create-batch',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
      if (userDetail.chapter_name
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });
    print(_searchResult);

    setState(() {});
  }
}

class UserDetails {
  final String id,
      chapter_name,
      short_description;

  UserDetails(
      {this.id,
        this.chapter_name,
        this.short_description,
      });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
        id: json['id'].toString(),
        chapter_name: json['chapter_name'].toString(),
        short_description: json['short_description'].toString());
  }
}
