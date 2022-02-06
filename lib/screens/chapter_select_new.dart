import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/progress_bar.dart';
import 'package:grewal/screens/api/data_list_api.dart';

class ChapterSelect2 extends StatefulWidget {
  @override
  _ChapterSelect2State createState() => _ChapterSelect2State();
}

class _ChapterSelect2State extends State<ChapterSelect2> {
  TextStyle normalText5 = GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff2E2A4A));
  TextStyle normalText7 = GoogleFonts.montserrat(
      fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff2E2A4A));
  TextStyle normalText6 = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff2E2A4A));

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

  List batchList = [];
  List standardList = [];
  List boardList = [];
  List subjectList = [];
  List contentType = [];
  TextEditingController testType = new TextEditingController();
  TextEditingController batch = new TextEditingController();
  TextEditingController standard = new TextEditingController();
  TextEditingController board = new TextEditingController();
  TextEditingController lastSubmissionDate = new TextEditingController();
  TextEditingController content = new TextEditingController();
  List chaptersList = [];
  bool selectAll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Text("Create Test", style: normalText6),
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
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      items: [
                        {"title": "Objective", "value": "O"},
                        {"title": "Subjective", "value": "S"}
                      ]
                          .map((e) => DropdownMenuItem(
                                child: Text(e['title'].toString()),
                                value: e['value'].toString(),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          testType.text = val;
                        });
                        ProgressBar().showLoaderDialog(context);
                        DataListAPI().getBatchList().then((value) {
                          Navigator.of(context).pop();
                          if (value.length > 0) {
                            setState(() {
                              batchList.clear();
                              batchList.addAll(value);
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Test Type',
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      items: batchList
                          .map((e) => DropdownMenuItem(
                                child: Text(e['batch_name'].toString()),
                                value: e['id'].toString(),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          batch.text = val;
                        });
                        ProgressBar().showLoaderDialog(context);
                        DataListAPI().getStandartList().then((value) {
                          Navigator.of(context).pop();
                          if (value.length > 0) {
                            setState(() {
                              standardList.clear();
                              standardList.addAll(value);
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Batch',
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      items: standardList
                          .map((e) => DropdownMenuItem(
                                child: Text(e['class'].toString()),
                                value: e['id'].toString(),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          standard.text = val;
                        });
                        ProgressBar().showLoaderDialog(context);
                        DataListAPI().getBoardList().then((value) {
                          Navigator.of(context).pop();
                          if (value.length > 0) {
                            setState(() {
                              boardList.clear();
                              boardList.addAll(value);
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Standard',
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      items: boardList
                          .map((e) => DropdownMenuItem(
                                child: Text(e['name'].toString()),
                                value: e['id'].toString(),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          board.text = val;
                          contentType.clear();
                          contentType.addAll([
                            {"item": "GCL Content", "id": "A"},
                            {"item": "Self Content", "id": "I"},
                          ]);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Board',
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: lastSubmissionDate,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        labelText: 'Last Submission Date',
                        isDense: true,
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please select date";
                        }
                        return null;
                      },
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (picked != null)
                          setState(() {
                            lastSubmissionDate.text = picked
                                .toString()
                                .substring(0, 10)
                                .split("-")
                                .reversed
                                .join("-");
                          });
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      items: contentType
                          .map((e) => DropdownMenuItem(
                                child: Text(e['item'].toString()),
                                value: e['id'].toString(),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          content.text = val;
                        });
                        ProgressBar().showLoaderDialog(context);
                        DataListAPI().getSubjectsList().then((value) {
                          Navigator.of(context).pop();
                          if (value.length > 0) {
                            setState(() {
                              subjectList.clear();
                              subjectList.addAll(value);
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Content Type',
                        isDense: true,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      items: subjectList
                          .map((e) => DropdownMenuItem(
                                child: Text(e['subject_name'].toString()),
                                value: e['id'].toString(),
                              ))
                          .toList(),
                      onChanged: (val) {
                        ProgressBar().showLoaderDialog(context);
                        DataListAPI()
                            .getChapterList(
                                board.text, standard.text, val.toString())
                            .then((value) {
                          Navigator.of(context).pop();
                          if (value.length > 0) {
                            setState(() {
                              chaptersList.clear();
                              chaptersList.addAll(value);
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        border: OutlineInputBorder(),
                        labelText: 'Select Subject',
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: chaptersList.length == 0 ? 0 : 1,
              child: chaptersList.length == 0
                  ? SizedBox()
                  : ListTile(
                      title: Text("Select All"),
                      trailing: Checkbox(
                          value: selectAll,
                          onChanged: (val) {
                            setState(() {
                              selectAll = val;
                              chaptersList.forEach((element) {
                                element['selected'] = val;
                              });
                            });
                          }),
                    ),
            ),
            Expanded(
              child: chaptersList.length == 0
                  ? SizedBox()
                  : Container(
                      color: Colors.teal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: chaptersList
                              .map((e) => Card(
                                    child: ListTile(
                                      title: Text(e['chapter_name']),
                                      trailing: Checkbox(
                                          value: e['selected'],
                                          onChanged: (va) {
                                            setState(() {
                                              e['selected'] = va;
                                            });
                                          }),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
              flex: chaptersList.length == 0 ? 0 : 3,
            )
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: TextButton(
            onPressed: () {
              List selectedChapter = [];
              chaptersList.forEach((element) {
                if (element['selected'] == true) {
                  selectedChapter.add(element['id']);
                }
              });
              print(selectedChapter.join(",").toString());
              if (selectedChapter.length == 0) {
                Fluttertoast.showToast(msg: "Please select chapters");
              } else {
                Navigator.pushNamed(context, '/create-test-new',
                    arguments: <String, String>{
                      'chapter_id': selectedChapter.join(",").toString(),
                      'batch_id': batch.text.toString(),
                      'submission_date': lastSubmissionDate.text.toString(),
                      'board_id': board.text.toString(),
                      'class_id': standard.text.toString(),
                      'content_type': content.text.toString(),
                      'test_type': testType.text
                    });
              }
            },
            child: Text(
              "Next",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
