// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:grewal/screens/upload_study_material/show_uploaded_files.dart';
import 'package:grewal/screens/upload_study_material/view_file.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/constants.dart';
import 'package:grewal/screens/login_with_logo.dart';
import 'package:grewal/screens/notification/notification_api.dart';
import 'package:grewal/screens/upload_study_material/upload_study_material_api.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class UploadOfflineTestPaper extends StatefulWidget {
  @override
  _UploadOfflineTestPaperState createState() => _UploadOfflineTestPaperState();
}

class _UploadOfflineTestPaperState extends State<UploadOfflineTestPaper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextEditingController _folder_name = new TextEditingController();

  TextEditingController _fileName = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = true;
  String institute_id;
  List data = [];
  List dataCopy = [];
  List batchList = [];
  bool isSearching = false;
  bool uploadFile = false;
  _getUser() async {
    Preference().getPreferences().then((prefs) async {
      setState(() {
        institute_id = prefs.getString('user_id').toString();
      });
      await UploadStudyMaterialAPI()
          .getOfflineFileList(institute_id)
          .then((value) {
        setState(() {
          data.addAll(value);
          dataCopy.addAll(value);
        });
      });
      await SendNotificationAPI().getAllBatchList(institute_id).then((value) {
        setState(() {
          batchList.addAll(value);
        });
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  void seraching(String search) {
    List dummyListData = [];
    print(search);
    if (search.isNotEmpty) {
      dataCopy.forEach((item) {
        item.forEach((key, value) {
          if (value.toString().toUpperCase().contains(search.toUpperCase())) {
            dummyListData.add(item);
          }
        });
      });
      setState(() {
        data.clear();
        data.addAll(dummyListData);
      });
    } else {
      setState(() {
        data.clear();
        data.addAll(dataCopy);
      });
    }
  }

  File file = new File(path);
  List selectedBatch = [];
  String fileName;
  Widget assignFiles() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            icon: Icon(Icons.file_upload),
            label: Text("Select File"),
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: [
                  'pdf',
                ],
              );

              if (result != null) {
                file = File(result.files.single.path);
                setState(() {
                  fileName = "";
                  fileName = result.files.single.name;
                });
              }
            },
          ),
        ),
        file.existsSync()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected File :\n" + fileName,
                    style: normalText5,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          fileName = "";
                          file.delete();
                        });
                      },
                      icon: Icon(Icons.clear))
                ],
              )
            : Text("Selected File :\nNo File Selected"),
        SizedBox(
          height: 15,
        ),
        MultiSelectDialogField(
          height: MediaQuery.of(context).size.height / 3,
          searchable: true,
          items: batchList
              .map((e) => MultiSelectItem(
                  e['id'].toString(), e['batch_name'].toString()))
              .toList(),
          title: Text("Select Batch/s"),
          selectedColor: Colors.blue,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              )),
          onConfirm: (results) {
            setState(() {
              selectedBatch = results;
            });
          },
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            child: Text("Submit"),
            onPressed: () async {
              if (file.existsSync() && selectedBatch.length > 0) {
                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(title: Text("Confirmation"), actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: normalText5,
                              )),
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                UploadStudyMaterialAPI()
                                    .uploadOfflineFile(
                                        institute_id, file, fileName)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: value
                                          ? "File Uploaded & Assigned To Batch/s"
                                          : "File Upload Failed",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER);
                                  setState(() {
                                    uploadFile = false;
                                    data.clear();
                                    dataCopy.clear();
                                    _getUser();
                                  });
                                });
                              },
                              child: Text(
                                "OK",
                                style: normalText5,
                              )),
                        ]));
              } else {
                Fluttertoast.showToast(
                    msg: "Select File & Batch/s",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER);
              }
            },
          ),
        )
      ],
    );
  }

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
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      data.clear();
                      data.addAll(dataCopy);
                    });
                  },
                  icon: Icon(Icons.clear),
                  color: Colors.black,
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                  icon: Icon(Icons.search),
                  color: Colors.black,
                )
        ],
        centerTitle: true,
        title: Container(
          child: isSearching
              ? TextFormField(
                  autofocus: true,
                  onChanged: (val) {
                    seraching(val.toString());
                  },
                  keyboardType: TextInputType.text,
                  cursorColor: Color(0xff000000),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
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
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                      fillColor: Color(0xfff9f9fb),
                      filled: true))
              : Text(
                  "Upload Offline\nTest Material, No. : " +
                      dataCopy.length.toString(),
                  textAlign: TextAlign.center,
                  style: normalText6),
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
          : SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: uploadFile
                      ? assignFiles()
                      : data.length == 0
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "No file/s\nClick on Add file.",
                                textAlign: TextAlign.center,
                                style: normalText5,
                              ),
                            )
                          : ListView(
                              children: data
                                  .map((e) => Card(
                                        elevation: 8,
                                        child: ListTile(
                                          title:
                                              Text(e['file_name'].toString()),
                                          subtitle: Text(e['created_at']
                                              .toString()
                                              .split(" ")[0]),
                                          trailing: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ViewPdfFile(
                                                            url:
                                                                e['fullFilePath']
                                                                    .toString(),
                                                            file_name: e['name']
                                                                    .toString()
                                                                    .isEmpty
                                                                ? "Unnamed File"
                                                                : e['name']
                                                                    .toString())));
                                              },
                                              icon: Icon(Icons.remove_red_eye)),
                                        ),
                                      ))
                                  .toList(),
                            )
                  // expansionCallback: (int index, bool isExpanded) {},
                  ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            uploadFile = !uploadFile;
          });
        },
        label: uploadFile ? Text("Back") : Text("Upload File"),
        backgroundColor: Color(0xff017EFF),
      ),
    );
  }
}
