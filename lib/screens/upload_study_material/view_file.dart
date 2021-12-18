import 'package:flutter/material.dart';
import 'package:grewal/screens/login_with_logo.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfFile extends StatefulWidget {
  String url;
  String file_name;
  ViewPdfFile({this.url, this.file_name});
  @override
  _ViewPdfFileState createState() => _ViewPdfFileState();
}

class _ViewPdfFileState extends State<ViewPdfFile> {
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
          child: Text(widget.file_name.toString(), style: normalText5),
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
      body: Container(
        child: SfPdfViewer.network(
          widget.file_name,
        ),
      ),
    );
  }
}
