// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/screens/notification/notification_api.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class SendNotificationsToAllTypes extends StatefulWidget {
  @override
  _SendNotificationsToAllTypesState createState() =>
      _SendNotificationsToAllTypesState();
}

class _SendNotificationsToAllTypesState
    extends State<SendNotificationsToAllTypes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  List sendTo = [
    {'item': 'Individual Student', 'value': 'S'},
    {'item': 'Whole Batch', 'value': 'B'},
    {'item': 'All in Institute', 'value': 'A'}
  ];

  List studentList = [];
  List batchList = [];
  TextEditingController _selectedStudent = new TextEditingController();
  TextEditingController _selectedStduentBatch = new TextEditingController();
  TextEditingController _selectedStduentMobileNo = new TextEditingController();
  TextEditingController _selectedBatch = new TextEditingController();
  TextEditingController _message = new TextEditingController();
  TextEditingController _subject = new TextEditingController();
  String institute_id = "";

  String selected = null;
  bool fileSelected = false;
  String selectedFileName = "No file selected";
  bool isLoading = true;
  bool isBatchChanged = false;
  Widget ShowOptionAccordingToSelection() {
    switch (selected) {
      case "S":
        return Container(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                  autofocus: true,
                  validator: (value) => value == null ? "Required" : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(14),
                    border: OutlineInputBorder(),
                    labelText: 'Select Batch',
                    isDense: true,
                  ),
                  items: batchList
                      .map((e) => DropdownMenuItem(
                            child: Text(e['batch_name'].toString()),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      isBatchChanged = true;
                      _selectedStduentBatch.text = val['id'].toString();
                    });
                    SendNotificationAPI()
                        .getBatchWiseStudentList(val['id'].toString(),
                            val['institute_id'].toString())
                        .then((value) {
                      if (value.length != 0) {
                        setState(() {
                          studentList.clear();
                          studentList = value;
                          isBatchChanged = false;
                        });
                      }
                    });
                  }),
              SizedBox(
                height: 10,
              ),
              isBatchChanged
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField(
                      validator: (value) => value == null ? "Required" : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Student',
                        isDense: true,
                      ),
                      items: studentList
                          .map((e) => DropdownMenuItem(
                                child: Text(e['id'].toString() +
                                    " - " +
                                    e['name'].toString()),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          _selectedStudent.text = "";
                          _selectedStduentMobileNo.text = "";
                          _selectedStudent.text = val['id'].toString();
                          _selectedStduentMobileNo.text =
                              val['mobile'].toString();
                        });
                      }),
            ],
          ),
        );
        break;
      case "B":
        return Container(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                  autofocus: true,
                  validator: (value) => value == null ? "Required" : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(14),
                    border: OutlineInputBorder(),
                    labelText: 'Select Batch',
                    isDense: true,
                  ),
                  items: batchList
                      .map((e) => DropdownMenuItem(
                            child: Text(e['batch_name'].toString()),
                            value: e['id'],
                          ))
                      .toList(),
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _selectedBatch.text = "";
                      _selectedBatch.text = val.toString();
                    });
                  }),
            ],
          ),
        );
        break;
      case "A":
        return Container(
          child: Text(
            'Send to all institute batches\nTotal Batches (' +
                batchList.length.toString() +
                ")",
            textAlign: TextAlign.center,
            style: normalText5,
          ),
        );
        break;
      default:
        return Container(
          child: SizedBox(
            height: 1,
          ),
        );
        break;
    }
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      SendNotificationAPI()
          .getAllBatchList(prefs.getString('user_id').toString())
          .then((value) {
        setState(() {
          institute_id = prefs.getString('user_id').toString();
        });
        if (value.length != 0) {
          setState(() {
            batchList = value;
            isLoading = false;
          });
        }
      });
    });
  }

  PickedFile _image;

  _imgFromCamera(bool select) async {
    PickedFile image = await ImagePicker.platform.pickImage(
      source: select ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 80,
      maxHeight: 480,
      maxWidth: 640,
    );

    setState(() {
      _image = image;
      fileSelected = true;
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _selectedStudent.text = "";
                  _selectedBatch.text = "";
                  _message.text = "";

                  selected = null;
                  fileSelected = false;
                  selectedFileName = "No file selected";

                  isBatchChanged = false;
                });
              },
              icon: Icon(
                Icons.restore,
                color: Colors.black,
              ))
        ],
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
              },
            ),
          ]),
        ),
        centerTitle: true,
        title: Container(
          child: Text("Send Notification\nMessages", style: normalText6),
        ),
        flexibleSpace: Container(
          height: 100,
          color: Color(0xffffffff),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButtonFormField(
                            validator: (value) =>
                                value == null ? "Required" : null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(14),
                              border: OutlineInputBorder(),
                              labelText: 'Send To',
                              isDense: true,
                            ),
                            items: sendTo
                                .map((e) => DropdownMenuItem(
                                      child: Text(e['item'].toString()),
                                      value: e['value'],
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selected = val;
                              });
                            }),
                        ShowOptionAccordingToSelection(),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: _subject,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff000000),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 30, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                counterText: "",
                                hintText: 'Subject',
                                hintStyle: TextStyle(
                                    color: Color(0xffBBBFC3), fontSize: 16),
                                fillColor: Color(0xfff9f9fb),
                                filled: true)),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            maxLines: 4,
                            controller: _message,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff000000),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 30, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xfff9f9fb),
                                  ),
                                ),
                                counterText: "",
                                hintText: 'Message',
                                hintStyle: TextStyle(
                                    color: Color(0xffBBBFC3), fontSize: 16),
                                fillColor: Color(0xfff9f9fb),
                                filled: true)),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.photo_library,
                                    color: Colors.white,
                                  ),
                                  label: new Text(
                                    'Photo Library',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    _imgFromCamera(true);
                                  }),
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                                label: new Text(
                                  'Camera',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _imgFromCamera(false);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: fileSelected
                                ? Image.file(File(_image.path))
                                : Image.asset("assets/images/noImage.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (formKey.currentState.validate()) {
            Map map = {};
            switch (selected) {
              case "S":
                map["ntype"] = "individual";
                map["subject"] = _subject.text;
                map["message"] = _message.text;
                map["mobile"] = _selectedStduentMobileNo.text;
                map["batch"] = _selectedStduentBatch.text;
                map["institute_id"] = institute_id;
                if (fileSelected) {
                  map["img"] =
                      base64Encode(File(_image.path).readAsBytesSync());
                }

                break;
              case "B":
                map["ntype"] = "batch";
                map["subject"] = _subject.text;
                map["message"] = _message.text;
                map["batch"] = _selectedBatch.text;
                map["institute_id"] = institute_id;
                if (fileSelected) {
                  map["img"] =
                      base64Encode(File(_image.path).readAsBytesSync());
                }
                break;
              case "A":
                map["ntype"] = "institute";
                map["subject"] = _subject.text;
                map["message"] = _message.text;
                map["institute_id"] = institute_id;
                if (fileSelected) {
                  map["img"] =
                      base64Encode(File(_image.path).readAsBytesSync());
                }
                break;
            }
            print(map);
            ProgressBar().showLoaderDialog(context);
            SendNotificationAPI().sendNotification(map).then((value) {
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: value.toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER);
              Navigator.of(context).pop();
            });
          }
        },
        label: Text("SEND"),
        backgroundColor: Color(0xff017EFF),
      ),
    );
  }
}
