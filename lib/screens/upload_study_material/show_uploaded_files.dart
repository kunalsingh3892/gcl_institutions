// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/screens/login_with_logo.dart';
import 'package:grewal/screens/notification/notification_api.dart';
import 'package:grewal/screens/upload_study_material/upload_study_material_api.dart';
import 'package:grewal/screens/upload_study_material/view_file.dart';
import 'package:grewal/services/shared_preferences.dart';
import 'package:group_radio_button/group_radio_button.dart';

class ShowUploadedFiles extends StatefulWidget {
  List filesList;
  String user_id;
  String folderName;
  ShowUploadedFiles({this.filesList, this.user_id, this.folderName});
  @override
  _ShowUploadedFilesState createState() => _ShowUploadedFilesState();
}

class _ShowUploadedFilesState extends State<ShowUploadedFiles> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText5Btn = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));
  TextEditingController _folder_name = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List batchList = [];
  TextEditingController _selectedBatch = new TextEditingController();
  String _verticalGroupValue = "Batch";

  List<String> _status = ["Batch", "Institute"];
  List data = [];
  List dataCopy = [];
  bool isSearching = false;
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
    SendNotificationAPI()
        .getAllBatchList(widget.user_id.toString())
        .then((value) {
      if (value.length > 0) {
        setState(() {
          batchList = value;
        });
      }
    });
    setState(() {
      data.addAll(widget.filesList);
      dataCopy.addAll(widget.filesList);
    });
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
              : Column(
                  children: [
                    Text("Folder : " + widget.folderName.toString(),
                        style: normalText6),
                    Text("Tap to assign / No : " + dataCopy.length.toString(),
                        style: normalText3),
                  ],
                ),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: data
                .map((e) => Card(
                      elevation: 8,
                      child: ListTile(
                        minLeadingWidth: 2,
                        leading: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPdfFile(
                                        url: e['fullFilePath'].toString(),
                                        fileName: e['name'].toString().isEmpty
                                            ? "Unnamed File"
                                            : e['name'].toString())));
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.blue,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e['created_at'].toString().split(" ")[0],
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            Text(
                              e['name'].toString().isEmpty ||
                                      e['name'].toString() == "null"
                                  ? "Unnamed File"
                                  : e['name'].toString(),
                              style: normalText5,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.all(8),
                        subtitle: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
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
                                              if (formKey.currentState
                                                  .validate()) {
                                                ProgressBar()
                                                    .showLoaderDialog(context);
                                                await UploadStudyMaterialAPI()
                                                    .assignFileToBatch(
                                                        _verticalGroupValue ==
                                                                "Batch"
                                                            ? true
                                                            : false,
                                                        widget.user_id,
                                                        e['institute_folder_id'],
                                                        _selectedBatch.text,
                                                        e['id'])
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                  value
                                                      ? Fluttertoast.showToast(
                                                          msg: "File Assigned",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER)
                                                      : Fluttertoast.showToast(
                                                          msg:
                                                              "File Assign Failed",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER);
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Assign",
                                              style: normalText5,
                                            )),
                                      ],
                                      content: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Container(
                                            height: 200,
                                            width: 300,
                                            child: Form(
                                              key: formKey,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    RadioGroup<String>.builder(
                                                      horizontalAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction:
                                                          Axis.horizontal,
                                                      groupValue:
                                                          _verticalGroupValue,
                                                      onChanged: (value) =>
                                                          setState(() {
                                                        _verticalGroupValue =
                                                            value;
                                                      }),
                                                      items: _status,
                                                      itemBuilder: (item) =>
                                                          RadioButtonBuilder(
                                                        item,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    _verticalGroupValue ==
                                                            "Batch"
                                                        ? DropdownButtonFormField(
                                                            autofocus: true,
                                                            validator: (value) =>
                                                                value == null
                                                                    ? "Required"
                                                                    : null,
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(14),
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Select Batch',
                                                              isDense: true,
                                                            ),
                                                            items: batchList
                                                                .map((e) =>
                                                                    DropdownMenuItem(
                                                                      child: Text(
                                                                          e['batch_name']
                                                                              .toString()),
                                                                      value: e[
                                                                          'id'],
                                                                    ))
                                                                .toList(),
                                                            onChanged: (val) {
                                                              print(val);
                                                              setState(() {
                                                                _selectedBatch
                                                                    .text = "";
                                                                _selectedBatch
                                                                        .text =
                                                                    val.toString();
                                                              });
                                                            })
                                                        : Text(
                                                            "Send to Institute",
                                                            style: normalText5,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ));
                          },
                          child: Text(
                            "\nAssig Batch",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              ProgressBar().showLoaderDialog(context);
                              UploadStudyMaterialAPI()
                                  .getAssignedBatchListOfSelectedFile(
                                      widget.user_id.toString(), e['id'])
                                  .then((value) {
                                Navigator.of(context).pop();
                                value.length > 0
                                    ? showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                "Assigned Batch",
                                                style: normalText5,
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: normalText5,
                                                    ))
                                              ],
                                              content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                child: ListView(
                                                  children: value
                                                      .map((e) => ListTile(
                                                          title: e['batch_name'] !=
                                                                  "null"
                                                              ? Text(
                                                                  e['batch_name']
                                                                      .toString())
                                                              : Text(
                                                                  "Assigned to all batch institute")))
                                                      .toList(),
                                                ),
                                              ),
                                            ))
                                    : Fluttertoast.showToast(
                                        msg: "No batch assigned",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM);
                              });
                            },
                            icon: Icon(
                              Icons.list,
                              color: Colors.green,
                            )),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
