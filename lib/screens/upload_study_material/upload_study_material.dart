// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:grewal/screens/upload_study_material/show_uploaded_files.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/constants.dart';
import 'package:grewal/screens/upload_study_material/upload_study_material_api.dart';
import 'package:grewal/services/shared_preferences.dart';

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

  TextEditingController _fileName = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = true;
  String institute_id;
  List data = [];
  List dataCopy = [];
  bool isSearching = false;
  _getUser() async {
    Preference().getPreferences().then((prefs) async {
      setState(() {
        institute_id = prefs.getString('user_id').toString();
      });
      await UploadStudyMaterialAPI().getFolderList(institute_id).then((value) {
        setState(() {
          data.addAll(value);
          dataCopy.addAll(value);
          isLoading = false;
        });
      });
    });
  }

  Future<List> _getFilesList(id) async {
    UploadStudyMaterialAPI().getUploadedFileList(institute_id, id.toString());
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
              : Text("Upload Study\nMaterial",
                  textAlign: TextAlign.center, style: normalText6),
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
                  child: data.length == 0
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "No Folder\nClick on Add Folder Button",
                            textAlign: TextAlign.center,
                            style: normalText5,
                          ),
                        )
                      : ListView(
                          children: data
                              .map((e) => Card(
                                    elevation: 8,
                                    child: ListTile(
                                      leading: Icon(Icons.folder,
                                          color: Colors.yellow[800]),
                                      title: Text(e['institute_folder_name']
                                          .toString()),
                                      trailing: TextButton(
                                        child: Text(
                                          "Upload",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onPressed: () async {
                                          Fluttertoast.showToast(
                                              msg: "Select PDF File",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM);
                                          FilePickerResult result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'pdf',
                                            ],
                                          );

                                          if (result != null) {
                                            _fileName.text = "";
                                            showDialog(
                                                context:
                                                    _scaffoldKey.currentContext,
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: Text(
                                                              "Confirmation"),
                                                          content: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2.5,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text("Selected File : \n" +
                                                                    result
                                                                        .files
                                                                        .single
                                                                        .name
                                                                        .toString()),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                TextFormField(
                                                                    maxLines: 2,
                                                                    controller:
                                                                        _fileName,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    cursorColor:
                                                                        Color(
                                                                            0xff000000),
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .sentences,
                                                                    validator:
                                                                        (value) {
                                                                      if (value
                                                                          .isEmpty) {
                                                                        return 'Required';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0xfff9f9fb),
                                                                          ),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0xfff9f9fb),
                                                                          ),
                                                                        ),
                                                                        disabledBorder: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0xfff9f9fb),
                                                                          ),
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0xfff9f9fb),
                                                                          ),
                                                                        ),
                                                                        counterText: "",
                                                                        hintText: 'File Name',
                                                                        hintStyle: TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                                                                        fillColor: Color(0xfff9f9fb),
                                                                        filled: true)),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
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
                                                                          "name"] =
                                                                      _fileName
                                                                          .text;
                                                                  request.files.add(http.MultipartFile(
                                                                      'file_name',
                                                                      File(result
                                                                              .files
                                                                              .single
                                                                              .path)
                                                                          .readAsBytes()
                                                                          .asStream(),
                                                                      File(result
                                                                              .files
                                                                              .single
                                                                              .path)
                                                                          .lengthSync(),
                                                                      filename: result
                                                                          .files
                                                                          .single
                                                                          .name));

                                                                  var res =
                                                                      await request
                                                                          .send();

                                                                  Fluttertoast.showToast(
                                                                      msg: res.statusCode ==
                                                                              200
                                                                          ? "File Uploaded"
                                                                          : "File Upload Failed",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .CENTER);
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
                                      ),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: TextButton(
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
            child: Text(
              "Add Folder",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
