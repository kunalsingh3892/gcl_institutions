import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grewal/components/general.dart';
import 'package:grewal/services/shared_preferences.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../constants.dart';

class CreateMCQ extends StatefulWidget {
  final Object argument;

  const CreateMCQ({Key key, this.argument}) : super(key: key);

  @override
  _LoginWithLogoState createState() => _LoginWithLogoState();
}

class _LoginWithLogoState extends State<CreateMCQ> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final chapterController = TextEditingController();

  bool showDrop = false;
  bool _loading = false;
  bool _isHidden = true;
  bool isEnabled1 = true;

  bool isEnabled2 = false;

  Future _diffData;
  Future _chapData;
  Future _topicData;
  List<Region> _region = [];
  List<Region3> _region3 = [];
  List<Region4> _region4 = [];
  var _type = "";

  var _type3 = "";
  var _type4 = "";
  String selectedRegion;
  String selectedRegion3;
  String selectedRegion4;
  String catData = "";
  String catData3 = "";
  String catData4 = "";
  bool _autoValidate = false;

  String chapter_id = "";
  String chapter_name = "";
  String type = "";
  String user_id = "";
  String class_id = "";
  String board_id = "";
  List<Animal> _animals = [];
  List<Animal1> _animals1 = [];
  List<Animal2> _animals2 = [];
  var _items;
  var _items1;
  var _items2;
  List<Animal> _selectedAnimals = [];
  List<Animal1> _selectedAnimals1 = [];
  List<Animal2> _selectedAnimals2 = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();
  final _multiSelectKey1 = GlobalKey<FormFieldState>();
  final _multiSelectKey2 = GlobalKey<FormFieldState>();
  String profile_image = '';
  String selectedChapterId="";
  String selectedTopicId="";
  String selectedLeveId="";
  @override
  void initState() {
    super.initState();
    var encodedJson = json.encode(widget.argument);
    var data = json.decode(encodedJson);
    chapter_id = data['chapter_id'];
    chapter_name = data['chapter_name'];
    type = data['type'];
    _getUser();
  }

  _getUser() async {
    Preference().getPreferences().then((prefs) {
      setState(() {
        user_id = prefs.getString('user_id').toString();
        class_id = prefs.getString('class_id').toString();
        board_id = prefs.getString('board_id').toString();
        profile_image = prefs.getString('profile_image').toString();
        if (type == "outside") {
          _chapData = _getChapterCategories();
        }
        if (type == "inside") {
          _topicData = _getTopicCategories(chapter_id);
        }
        _diffData = _getDifficultCategories();
      });
    });
  }

  Future _getDifficultCategories() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/question-level"),
      body: "",
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      print(result);

      for (int i = 0; i < result.length; i++) {
        _animals.add(Animal(
            id: result[i]['id'].toString(),
            name: result[i]['type'].toString()));
      }
      setState(() {
        _items = _animals
            .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
            .toList();
        _selectedAnimals = _animals;
      });

      /* if (mounted) {
        setState(() {

          catData = jsonEncode(result);

          final json = JsonDecoder().convert(catData);

          _region = (json).map<Region>((item) => Region.fromJson(item)).toList();
          List<String> item = _region.map((Region map) {
            for (int i = 0; i < _region.length; i++) {
              if (selectedRegion == map.THIRD_LEVEL_NAME) {
                _type = map.THIRD_LEVEL_ID;

                print(selectedRegion);
                return map.THIRD_LEVEL_ID;
              }
            }
          }).toList();
          if (selectedRegion == "") {
            selectedRegion = _region[0].THIRD_LEVEL_NAME;
            _type = _region[0].THIRD_LEVEL_ID;
          }

        });

      }*/

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getChapterCategories() async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/chapter"),
      body: {"board_id": board_id, "class_id": class_id, "subject_id": "8"},
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var result = data['Response'];
      for (int i = 0; i < result.length; i++) {
        _animals1.add(Animal1(
            id: result[i]['id'].toString(),
            name: result[i]['chapter_name'].toString()));
      }
      setState(() {
        _items1 = _animals1
            .map((animal) => MultiSelectItem<Animal1>(animal, animal.name))
            .toList();
        _selectedAnimals1 = _animals1;
      });


      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future _getTopicCategories(String type) async {
    _selectedAnimals2.clear();
    _animals2.clear();
    print(type.toString());
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // "authorization": basicAuth
    };
    var response = await http.post(
      new Uri.https(BASE_URL, API_PATH + "/topic"),
      body: {"chapter_id": type.toString()},
      headers: headers,
    );
    print({"chapter_id": type.toString()});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var result = data['Response'];
      var errocode = data['ErrorCode'];
      if (errocode == 0) {
        for (int i = 0; i < result.length; i++) {
          _animals2.add(Animal2(
              id: result[i]['id'].toString(),
              name: result[i]['name'].toString()));
        }
        setState(() {

         /* _items2 = _animals2
              .map((animal) => MultiSelectItem<Animal2>(animal, animal.name))
              .toList();*/
          _selectedAnimals2 = _animals2;
        //  showDrop=true;
        });

        /*if (mounted) {
          setState(() {
            showDrop=true;
            catData4 = jsonEncode(result);

            final json = JsonDecoder().convert(catData4);
            _region4 =
                (json).map<Region4>((item) => Region4.fromJson(item)).toList();
            List<String> item = _region4.map((Region4 map) {
              for (int i = 0; i < _region4.length; i++) {
                if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                  _type4 = map.THIRD_LEVEL_ID;

                  print(selectedRegion4);
                  return map.THIRD_LEVEL_ID;
                }
              }
            }).toList();
            //if (selectedRegion4 == "") {
            selectedRegion4 = _region4[0].THIRD_LEVEL_NAME;
            _type4 = _region4[0].THIRD_LEVEL_ID;
            // }

          });
        }*/
      } else {
        Fluttertoast.showToast(msg: "No Topic Found");
        setState(() {
      //    selectedRegion4 = null;
          showDrop = false;
        });
      }

      return result;
    } else {
      throw Exception('Something went wrong');
    }
  }

 /* Widget _customContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: nameController,
                //  maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter test name';
                  }
                  return null;
                },
                onSaved: (value) {
                  nameController.text = value;
                },
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
                    hintText: 'Name your Test',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 15.0),
          type == "outside"
              ?

              Container(
                  // margin: const EdgeInsets.only(right: 8.0, left: 8),
                  padding: EdgeInsets.all(10),

                  child: MultiSelectBottomSheetField(
                    items: _items1,
                    minChildSize: 0.4,
                    initialChildSize: 0.5,
                    key: _multiSelectKey1,
                  //  initialValue: _selectedAnimals1,
                    listType: MultiSelectListType.CHIP,
                    searchable: true,
                    selectedColor: Color(0xff017EFF),
                    selectedItemsTextStyle: TextStyle(color: Colors.white),

                    title: Text("Select Chapters"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Select Chapters";
                      }
                      return null;
                    },

                    decoration: BoxDecoration(
                      color: Color(0xfff9f9fb),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Color(0xfff9f9fb),
                        width: 1,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff017EFF),
                    ),
                    buttonText: Text(
                      "Select Chapters",
                      style: TextStyle(
                        color: Color(0xffBBBFC3),
                        fontSize: 16,
                      ),
                    ),

                    onConfirm: (results) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    *//*  setState(() {
                        _selectedAnimals1 = results;

                      });*//*
                      _multiSelectKey1.currentState.validate();
                      selectedChapterId="";
                      for(int i=0;i<results.length;i++){
                        if(i==(results.length-1)){
                          selectedChapterId=selectedChapterId+results[i].id.toString();
                        }
                        else{
                          selectedChapterId=selectedChapterId+results[i].id.toString()+",";
                        }

                      }
                      print(selectedChapterId);
                      setState(() {
                        _topicData =_getTopicCategories(selectedChapterId);
                      });

                    },
                    chipDisplay: MultiSelectChipDisplay(
                      scroll: true,
                      height: 50,

                    ),

                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 8.0, left: 8),
                  child: TextFormField(
                      initialValue: chapter_name,
                      //  maxLength: 10,
                      keyboardType: TextInputType.text,
                      cursorColor: Color(0xff000000),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter test name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        chapterController.text = value;
                      },
                      decoration: InputDecoration(
                          enabled: false,
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
                          hintText: 'Name your Test',
                          hintStyle:
                              TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                          fillColor: Color(0xfff9f9fb),
                          filled: true)),
                ),
          const SizedBox(height: 15.0),

          *//* Container(
                  width: MediaQuery.of(context).size.width ,
                  margin: const EdgeInsets.only(right: 5.0, left: 8),
                  padding: EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: Color(0xfff9f9fb),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.0,
                        color: Color(0xfff9f9fb),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: EdgeInsets.only(right: 0, left: 3),
                      child: new DropdownButton<String>(
                        isExpanded: true,
                        hint: new Text(
                          "Select Topic",
                          style: TextStyle(color: Color(0xffBBBFC3)),
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ),
                        value: selectedRegion4,
                        isDense: true,
                        onChanged: showDrop==false?null:(newValue) {
                          setState(() {
                            selectedRegion4 = newValue;
                            List<String> item = _region4.map((Region4 map) {
                              for (int i = 0; i < _region4.length; i++) {
                                if (selectedRegion4 == map.THIRD_LEVEL_NAME) {
                                  _type4 = map.THIRD_LEVEL_ID;
                                  return map.THIRD_LEVEL_ID;
                                }
                              }
                            }).toList();


                          });
                        },
                        items: _region4.map((Region4 map) {
                          return new DropdownMenuItem<String>(
                            value: map.THIRD_LEVEL_NAME,
                            child: new Text(map.THIRD_LEVEL_NAME,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(color: Colors.black87)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),*//*

       Column(
          children: [
            Container(
              // margin: const EdgeInsets.only(right: 8.0, left: 8),
              padding: EdgeInsets.all(10),
              child: MultiSelectBottomSheetField(
                items: _animals2
                    .map((animal) => MultiSelectItem<Animal2>(animal, animal.name))
                    .toList(),
                key: _multiSelectKey2,
                initialChildSize: 0.5,

               // initialValue: _selectedAnimals2,
                listType: MultiSelectListType.CHIP,

                searchable: true,
                selectedColor: Color(0xff017EFF),
                selectedItemsTextStyle: TextStyle(color: Colors.white),
                title: Text("Select Topic"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select Topic";
                  }
                  return null;
                },

                decoration: BoxDecoration(
                  color: Color(0xfff9f9fb),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xfff9f9fb),
                    width: 1,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff017EFF),
                ),
                buttonText: Text(
                  "Select Topic",
                  style: TextStyle(
                    color: Color(0xffBBBFC3),
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                *//*  setState(() {
                    _selectedAnimals2 = results;
                  });*//*
                  selectedTopicId="";
                  for(int i=0;i<results.length;i++){
                    if(i==(results.length-1)){
                      selectedTopicId=selectedTopicId+results[i].id.toString();
                    }
                    else{
                      selectedTopicId=selectedTopicId+results[i].id.toString()+",";
                    }

                  }
                  print(selectedTopicId);
                  _multiSelectKey2.currentState.validate();
                },
                chipDisplay: MultiSelectChipDisplay(
                  scroll: true,
                  height: 50,

                ),
              ),
            ),
            const SizedBox(height: 15.0),
          ]
         ),

          Container(
            // margin: const EdgeInsets.only(right: 8.0, left: 8),
            padding: EdgeInsets.all(10),
            child: MultiSelectDialogField(
              items: _items,
              key: _multiSelectKey,
              initialValue: _selectedAnimals,
              listType: MultiSelectListType.CHIP,
             // searchable: true,
              selectedColor: Color(0xff017EFF),
              selectedItemsTextStyle: TextStyle(color: Colors.white),
              title: Text("Select Difficult level"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Select Difficult Level";
                }
                return null;
              },
              decoration: BoxDecoration(
                color: Color(0xfff9f9fb),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: Color(0xfff9f9fb),
                  width: 1,
                ),
              ),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: Color(0xff017EFF),
              ),
              buttonText: Text(
                "Select Difficult level",
                style: TextStyle(
                  color: Color(0xffBBBFC3),
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  _selectedAnimals = results;
                });
                selectedLeveId="";
                for(int i=0;i<_selectedAnimals.length;i++){
                  if(i==(_selectedAnimals.length-1)){
                    selectedLeveId=selectedLeveId+_selectedAnimals[i].id.toString();
                  }
                  else{
                    selectedLeveId=selectedLeveId+_selectedAnimals[i].id.toString()+",";
                  }

                }
                print(selectedLeveId);
                _multiSelectKey.currentState.validate();
              },
            ),
          ),

*//*          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            padding: EdgeInsets.all(10),
            decoration: ShapeDecoration(
              color: Color(0xfff9f9fb),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.0,
                  color: Color(0xfff9f9fb),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: EdgeInsets.only(right: 0, left: 3),
                child: new DropdownButton<String>(
                  isExpanded: true,
                  hint: new Text(
                    "Select Difficult level",
                    style: TextStyle(color: Color(0xffBBBFC3)),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  value: selectedRegion,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedRegion = newValue;
                      List<String> item = _region.map((Region map) {
                        for (int i = 0; i < _region.length; i++) {
                          if (selectedRegion == map.THIRD_LEVEL_NAME) {
                            _type = map.THIRD_LEVEL_ID;
                            return map.THIRD_LEVEL_ID;
                          }
                        }
                      }).toList();


                    });
                  },
                  items: _region.map((Region map) {
                    return new DropdownMenuItem<String>(
                      value: map.THIRD_LEVEL_NAME,
                      child: new Text(map.THIRD_LEVEL_NAME,

                          style: new TextStyle(color: Colors.black87)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),*//*
          const SizedBox(height: 30.0),
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: ButtonTheme(
              height: 28.0,
              child: RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                textColor: Colors.white,
                color: Color(0xff017EFF),
                onPressed: () async {
                  if (type == "inside") {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (selectedRegion4 != "") {
                        setState(() {
                          _loading = true;
                        });
                        final msg = jsonEncode({
                          "type": "0",
                          "name": nameController.text,
                          "student_id": user_id,
                          "chapter": chapter_id,
                          "topic": selectedTopicId,
                          "level": selectedLeveId
                        });
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                        };
                        var response = await http.post(
                          new Uri.http(BASE_URL, API_PATH + "/test-create"),
                          body: {
                            "type": "0",
                            "name": nameController.text,
                            "student_id": user_id,
                            "chapter": chapter_id,
                            "topic": selectedTopicId,
                            "level": selectedLeveId
                          },
                          headers: headers,
                        );
                        print(msg);

                        if (response.statusCode == 200) {
                          setState(() {
                            _loading = false;
                          });
                          var data = json.decode(response.body);
                          print(data);
                          var errorCode = data['ErrorCode'];
                          var errorMessage = data['ErrorMessage'];

                          if (errorCode == 0) {
                            setState(() {
                              _loading = false;
                            });

                            Fluttertoast.showToast(msg: errorMessage);
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/test-correct',
                              arguments: <String, String>{
                                'test_id': data['test_id'].toString(),
                              },
                            );
                           *//* Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/test-list',
                              arguments: <String, String>{
                                'chapter_id': chapter_id.toString(),
                                'chapter_name': chapter_name.toString(),
                                'type': "inside"
                              },
                            );*//*
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            showAlertDialog(
                                context, ALERT_DIALOG_TITLE, errorMessage);
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please select difficulty level");
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  } else {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (selectedRegion4 != "") {
                        setState(() {
                          _loading = true;
                        });
                        final msg = jsonEncode({
                          "type": "0",
                          "name": nameController.text,
                          "student_id": user_id,
                          "chapter": selectedChapterId,
                          "topic": selectedTopicId,
                          "level": selectedLeveId
                        });
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                        };
                        var response = await http.post(
                          new Uri.http(BASE_URL, API_PATH + "/test-create"),
                          body: {
                            "type": "0",
                            "name": nameController.text,
                            "student_id": user_id,
                            "chapter": selectedChapterId,
                            "topic": selectedTopicId,
                            "level": selectedLeveId
                          },
                          headers: headers,
                        );
                        print(msg);

                        if (response.statusCode == 200) {
                          setState(() {
                            _loading = false;
                          });
                          var data = json.decode(response.body);
                          print(data);
                          var errorCode = data['ErrorCode'];
                          var errorMessage = data['ErrorMessage'];

                          if (errorCode == 0) {
                            setState(() {
                              _loading = false;
                            });

                            Fluttertoast.showToast(msg: errorMessage);
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/test-correct',
                              arguments: <String, String>{
                                'test_id': data['test_id'].toString(),
                              },
                            );
                            *//*Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/test-list',
                              arguments: <String, String>{
                                'chapter_id': "",
                                'chapter_name': "",
                                'type': "outside"
                              },
                            );*//*
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            showAlertDialog(
                                context, ALERT_DIALOG_TITLE, errorMessage);
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please select difficulty level");
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  }
                },
                child: Text(
                  "Start Test",
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/

/*  Widget _randomContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: TextFormField(
                controller: nameController,
                //  maxLength: 10,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff000000),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter test name';
                  }
                  return null;
                },
                onSaved: (value) {
                  nameController.text = value;
                },
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
                    hintText: 'Name your Test',
                    hintStyle:
                        TextStyle(color: Color(0xffBBBFC3), fontSize: 16),
                    fillColor: Color(0xfff9f9fb),
                    filled: true)),
          ),
          const SizedBox(height: 30.0),
          Container(
            width: MediaQuery.of(context).size.height * 0.80,
            margin: const EdgeInsets.only(right: 8.0, left: 8),
            child: ButtonTheme(
              height: 28.0,
              child: RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                textColor: Colors.white,
                color: Color(0xff017EFF),
                onPressed: () async {
                  if (type == "inside") {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        _loading = true;
                      });
                      final msg = jsonEncode({
                        "type": "1",
                        "name": nameController.text,
                        "student_id": user_id,
                        "chapter": chapter_id,
                      });
                      Map<String, String> headers = {
                        'Accept': 'application/json',
                      };
                      var response = await http.post(
                        new Uri.http(
                            BASE_URL, API_PATH + "/test-create-random"),
                        body: {
                          "type": "1",
                          "name": nameController.text,
                          "student_id": user_id,
                          "chapter": chapter_id,
                        },
                        headers: headers,
                      );
                      print(msg);

                      if (response.statusCode == 200) {
                        setState(() {
                          _loading = false;
                        });
                        var data = json.decode(response.body);
                        print(data);
                        var errorCode = data['ErrorCode'];
                        var errorMessage = data['ErrorMessage'];

                        if (errorCode == 0) {
                          setState(() {
                            _loading = false;
                          });

                          Fluttertoast.showToast(msg: errorMessage);
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/test-correct',
                            arguments: <String, String>{
                              'test_id': data['test_id'].toString(),
                            },
                          );
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/test-list',
                            arguments: <String, String>{
                              'chapter_id': chapter_id.toString(),
                              'chapter_name': chapter_name.toString(),
                              'type': "inside"
                            },
                          );
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          showAlertDialog(
                              context, ALERT_DIALOG_TITLE, errorMessage);
                        }
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  } else {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (selectedRegion4 != "") {
                        setState(() {
                          _loading = true;
                        });
                        final msg = jsonEncode({
                          "type": "1",
                          "name": nameController.text,
                          "student_id": user_id,
                          "class_id": class_id,
                          "board_id": board_id
                        });
                        Map<String, String> headers = {
                          'Accept': 'application/json',
                        };
                        var response = await http.post(
                          new Uri.http(
                              BASE_URL, API_PATH + "/test-create-direct"),
                          body: {
                            "type": "1",
                            "name": nameController.text,
                            "student_id": user_id,
                            "class_id": class_id,
                            "board_id": board_id
                          },
                          headers: headers,
                        );
                        print(msg);

                        if (response.statusCode == 200) {
                          setState(() {
                            _loading = false;
                          });
                          var data = json.decode(response.body);
                          print(data);
                          var errorCode = data['ErrorCode'];
                          var errorMessage = data['ErrorMessage'];

                          if (errorCode == 0) {
                            setState(() {
                              _loading = false;
                            });

                            Fluttertoast.showToast(msg: errorMessage);
                           Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/test-correct',
                              arguments: <String, String>{
                                'test_id': data['test_id'].toString(),
                              },
                            );
                            Navigator.pushNamed(
                              context,
                              '/test-list',
                              arguments: <String, String>{
                                'chapter_id': chapter_id.toString(),
                                'chapter_name': chapter_name.toString(),
                                'type': "outside"
                              },
                            );
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            showAlertDialog(
                                context, ALERT_DIALOG_TITLE, errorMessage);
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please select difficulty level");
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  }
                },
                child: Text(
                  "Start Test",
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
  TextStyle normalText1 = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  TextStyle normalText2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
  TextStyle normalText3 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle next = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: 1);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: Color(0xff2E2A4A),
        body: SingleChildScrollView(
          child: Container(
              child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 50),
                            child: Image.asset(
                              'assets/images/intro_2.png',
                              width: 180,
                              height: 180,
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("This test comprises of easy, medium and difficult questions.", style: normalText1),
                          ),
                          const SizedBox(height: 25.0),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                                "MCQ- 9 Questions.",
                                style: normalText2),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                                "Assertion / Reasoning- 2 Questions.",
                                style: normalText2),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                                "Case based Questions- 1 (4 Questions).",
                                style: normalText2),
                          ),
                          const SizedBox(height: 25.0),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                                "Time to complete this test - 30 Minutes.",
                                style: normalText3),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: const EdgeInsets.only(
                              right: 8.0, left: 8, bottom: 20),
                          child: ButtonTheme(
                            height: 28.0,
                            minWidth:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.80,
                            child: RaisedButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0)),
                              textColor: Colors.white,
                              color: Color(0xff017EFF),
                              onPressed: () async {
                               // if (type == "inside") {
                                  setState(() {
                                    _loading = true;
                                  });
                                  final msg = jsonEncode({
                                    "type": type == "outside" ? "1" : "0",
                                    "student_id": user_id,
                                    "chapter": chapter_id,
                                  });
                                  Map<String, String> headers = {
                                    'Accept': 'application/json',
                                  };
                                  var response = await http.post(
                                    new Uri.https(
                                        BASE_URL,
                                        API_PATH + "/test-create-random"),
                                    body: {
                                      "type": type == "outside" ? "1" : "0",
                                      "student_id": user_id,
                                      "chapter": chapter_id,
                                    },
                                    headers: headers,
                                  );
                                  print(msg);

                                  if (response.statusCode == 200) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    var data = json.decode(response.body);
                                    print(data);
                                    var errorCode = data['ErrorCode'];
                                    var errorMessage = data['ErrorMessage'];

                                    if (errorCode == 0) {
                                      setState(() {
                                        _loading = false;
                                      });

                                      Fluttertoast.showToast(msg: errorMessage);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        '/test-correct',
                                        arguments: <String, String>{
                                          'test_id': data['test_id'].toString(),
                                        },
                                      );

                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      showAlertDialog(
                                          context, ALERT_DIALOG_TITLE,
                                          errorMessage);
                                    }
                                  }
                               /* }
                                  else {

                                      setState(() {
                                        _loading = true;
                                      });
                                      final msg = jsonEncode({
                                        "type": "1",
                                        "student_id": user_id,
                                        "class_id": class_id,
                                        "board_id": board_id
                                      });
                                      Map<String, String> headers = {
                                        'Accept': 'application/json',
                                      };
                                      var response = await http.post(
                                        new Uri.http(
                                            BASE_URL, API_PATH + "/test-create-direct"),
                                        body: {
                                          "type": "1",

                                          "student_id": user_id,
                                          "class_id": class_id,
                                          "board_id": board_id
                                        },
                                        headers: headers,
                                      );
                                      print(msg);

                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _loading = false;
                                        });
                                        var data = json.decode(response.body);
                                        print(data);
                                        var errorCode = data['ErrorCode'];
                                        var errorMessage = data['ErrorMessage'];

                                        if (errorCode == 0) {
                                          setState(() {
                                            _loading = false;
                                          });

                                          Fluttertoast.showToast(msg: errorMessage);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                            context,
                                            '/test-correct',
                                            arguments: <String, String>{
                                              'test_id': data['test_id'].toString(),
                                            },
                                          );

                                        } else {
                                          setState(() {
                                            _loading = false;
                                          });
                                          showAlertDialog(
                                              context, ALERT_DIALOG_TITLE, errorMessage);
                                        }
                                      }

                                }*/
                              },
                              child: Text("Start Test", style: next),
                            ),
                          ),
                        ),
                      ]))
          ),
        )
      ),
    );
  }

}

class Region {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        THIRD_LEVEL_ID: json['id'].toString(), THIRD_LEVEL_NAME: json['type']);
  }
}

class Region3 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region3({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region3.fromJson(Map<String, dynamic> json) {
    return new Region3(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['chapter_name'],
    );
  }
}

class Region4 {
  final String THIRD_LEVEL_ID;
  final String THIRD_LEVEL_NAME;

  Region4({this.THIRD_LEVEL_ID, this.THIRD_LEVEL_NAME});

  factory Region4.fromJson(Map<String, dynamic> json) {
    return new Region4(
      THIRD_LEVEL_ID: json['id'].toString(),
      THIRD_LEVEL_NAME: json['name'],
    );
  }
}

class Animal {
  final String id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}

class Animal1 {
  final String id;
  final String name;

  Animal1({
    this.id,
    this.name,
  });
}

class Animal2 {
  final String id;
  final String name;

  Animal2({
    this.id,
    this.name,
  });
}
