import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  TextInput({this.onChange, this.text});
  final Function onChange;
  final String text;
  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: TextField(
            textAlign: TextAlign.center,
            onChanged: widget.onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15.0),
              fillColor: Colors.white,
              filled: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.green),
                borderRadius: new BorderRadius.circular(25.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: widget.text,
            ),
          ),
        ),
      ),
    );
  }
}
