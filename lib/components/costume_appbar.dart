import 'package:flutter/material.dart';
import 'package:task_tacker/constans/colors.dart';

AppBar costumeAppBar(
    {required String title, List<Widget>? actions, bool? centerTitle}) {
  return AppBar(
    elevation: 0,
    backgroundColor: kPrimaryColor,
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
    actions: actions,
  );
}
