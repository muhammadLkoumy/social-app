import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastStates { SUCCESS, ERROR, WARNING }

class MyToast {
  String msg;
  ToastStates state;

  MyToast({
    required this.msg,
    required this.state,
});

  void showToast() {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: toastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Color toastColor(ToastStates state) {
    Color color;
    switch (state) {
      case ToastStates.SUCCESS:
        color = Colors.green;
        break;
      case ToastStates.ERROR:
        color = Colors.red;
        break;
      case ToastStates.WARNING:
        color = Colors.amber;
        break;
    }
    return color;
  }

}