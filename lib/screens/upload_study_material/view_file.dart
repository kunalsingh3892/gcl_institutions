import 'package:flutter/material.dart';
import 'package:grewal/screens/login_with_logo.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfFile extends StatefulWidget {
  String url;
  String fileName;
  ViewPdfFile({this.url, this.fileName});
  @override
  _ViewPdfFileState createState() => _ViewPdfFileState();
}

class _ViewPdfFileState extends State<ViewPdfFile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
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
          child: Text(widget.fileName.toString(), style: normalText5),
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
            // Uri.parse(widget.file_name).toString(),
            // onDocumentLoadFailed: (val) => Text("Document loading failed"),
            widget.url),
      ),
    );
  }
}
