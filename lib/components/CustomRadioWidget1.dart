import 'package:flutter/material.dart';
class CustomRadioWidget1<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String groupName;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget1({this.value, this.groupValue,this.groupName, this.onChanged, this.width = 16, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () {
          onChanged(this.value);
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 8),

          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[ Padding(
          padding: const EdgeInsets.only(left: 20,right: 15),

          child: Container(
            height: this.height,
            width: this.width,
            decoration: new BoxDecoration(
              border: new Border.all(
                  width: 1,
                  color:
                  Colors.black),
              borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
            ),

            child: Center(
              child: Container(
                height: this.height - 8,
                width: this.width - 8,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(
                      colors: value == groupValue ? [
                      Color(0xff017EFF),
                      Color(0xff017EFF),
                      ] : [
                      Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
        ),

      ),
    Text(
    this.groupName,
    style: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black),
    ),

    ]


    ),
    ),
    );
  }
}