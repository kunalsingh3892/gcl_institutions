// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:grewal/screens/upload_study_material/show_uploaded_files.dart';
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

class UploadStudyMaterial extends StatefulWidget {
  @override
  _UploadStudyMaterialState createState() => _UploadStudyMaterialState();
}

class _UploadStudyMaterialState extends State<UploadStudyMaterial> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextEditingController _folder_name = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = true;
  String institute_id;
  List folderList = [];
  _getUser() async {
    Preference().getPreferences().then((prefs) async {
      setState(() {
        institute_id = prefs.getString('user_id').toString();
      });
      await UploadStudyMaterialAPI()
          .getFolderList(prefs.getString('user_id').toString())
          .then((value) {
        setState(() {
          folderList = value;

          isLoading = false;
        });
      });
    });
  }

  Future<List> _getFilesList(id) async {
    UploadStudyMaterialAPI().getUploadedFileList(institute_id, id.toString());
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
        centerTitle: true,
        title: Container(
          child: Text("Upload Study Material", style: normalText6),
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
                  child: folderList.length == 0
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "No Folder\nClick on Add Folder Button",
                            textAlign: TextAlign.center,
                            style: normalText5,
                          ),
                        )
                      : ListView(
                          children: folderList
                              .map((e) => Card(
                                    elevation: 8,
                                    child: ListTile(
                                      title: Text(e['institute_folder_name']
                                          .toString()),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            FilePickerResult result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'pdf',
                                              ],
                                            );

                                            if (result != null) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            title: Text(
                                                                "Confirmation"),
                                                            content: Text(
                                                                "Selected File : \n" +
                                                                    result
                                                                        .files
                                                                        .single
                                                                        .name
                                                                        .toString()),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style:
                                                                        normalText5,
                                                                  )),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    var uri = Uri.https(
                                                                        BASE_URL,
                                                                        API_PATH +
                                                                            "/upload-file-to-folder");
                                                                    var request =
                                                                        http.MultipartRequest(
                                                                            'POST',
                                                                            uri);
                                                                    request.fields[
                                                                            "institute_id"] =
                                                                        institute_id
                                                                            .toString();
                                                                    request.fields[
                                                                        "folder_id"] = e[
                                                                            "id"]
                                                                        .toString();
                                                                    request.fields[
                                                                            "file_name"] =
                                                                        result
                                                                            .files
                                                                            .single
                                                                            .name;
                                                                    request.files.add(http.MultipartFile(
                                                                        'file',
                                                                        File(result.files.single.path)
                                                                            .readAsBytes()
                                                                            .asStream(),
                                                                        File(result.files.single.path)
                                                                            .lengthSync(),
                                                                        filename: result
                                                                            .files
                                                                            .single
                                                                            .name));
                                                                    ProgressBar()
                                                                        .showLoaderDialog(
                                                                            context);
                                                                    await request
                                                                        .send()
                                                                        .then(
                                                                            (value) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Fluttertoast.showToast(
                                                                          msg: value.statusCode == 200
                                                                              ? "File Uploaded"
                                                                              : "File Upload Failed",
                                                                          toastLength: Toast
                                                                              .LENGTH_LONG,
                                                                          gravity:
                                                                              ToastGravity.CENTER);
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    "Upload",
                                                                    style:
                                                                        normalText5,
                                                                  )),
                                                            ],
                                                          ));
                                            }
                                          },
                                          icon: Icon(Icons.upload_file)),
                                      onTap: () async {
                                        ProgressBar().showLoaderDialog(context);
                                        UploadStudyMaterialAPI()
                                            .getUploadedFileList(
                                                institute_id.toString(),
                                                e['id'].toString())
                                            .then((value) {
                                          Navigator.of(context).pop();
                                          if (value.length == 0) {
                                            Fluttertoast.showToast(
                                                msg: "No file upload",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowUploadedFiles(
                                                          folderName:
                                                              e['institute_folder_name']
                                                                  .toString(),
                                                          filesList: value,
                                                          user_id: institute_id
                                                              .toString(),
                                                        )));
                                          }
                                        });
                                      },
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
            _folder_name.text = "";
          });
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      "Add Folder",
                      style: normalText5,
                    ),
                    content: Form(
                      key: formKey,
                      child: TextFormField(
                          autofocus: true,
                          controller: _folder_name,
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
                              hintText: 'Folder Name',
                              hintStyle: TextStyle(
                                  color: Color(0xffBBBFC3), fontSize: 16),
                              fillColor: Color(0xfff9f9fb),
                              filled: true)),
                    ),
                    actions: [
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
                            if (formKey.currentState.validate()) {
                              await UploadStudyMaterialAPI()
                                  .addFolder(institute_id.toString(),
                                      _folder_name.text)
                                  .then((value) {
                                value
                                    ? Fluttertoast.showToast(
                                        msg: "Folder Created",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER)
                                    : Fluttertoast.showToast(
                                        msg: "Folder Creation Failed",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER);
                              }).then((value) {
                                Navigator.of(context).pop();
                              });
                              await _getUser();
                            }
                          },
                          child: Text(
                            "Create",
                            style: normalText5,
                          )),
                    ],
                  ));
        },
        label: Text("Add Folder"),
        backgroundColor: Color(0xff017EFF),
      ),
    );
  }
}
