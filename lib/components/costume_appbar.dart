import 'package:flutter/material.dart';

AppBar costumeAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
  bool? centerTitle,
}) {
  return AppBar(
    elevation: 0,
    toolbarHeight: 70,
    centerTitle: centerTitle,
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'PoppinsBold',
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    leading: leading,
    actions: actions,
  );
}
