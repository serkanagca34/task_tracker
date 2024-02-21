import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tacker/responsive/media_query.dart';

class Popups {
  QuestionDangerPopup(
    context, {
    required String title,
    required String message,
    required onTopYes,
    required onTopNo,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          insetPadding: EdgeInsets.symmetric(horizontal: getScreenWidth(0.05)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: getScreenHeight(0.04)),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: getScreenHeight(0.07)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onTopNo,
                      child: Container(
                        height: getScreenHeight(0.06),
                        width: getScreenWidth(0.35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Text(
                            "task_delete_popup_no_button".tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTopYes,
                      child: Container(
                        height: getScreenHeight(0.06),
                        width: getScreenWidth(0.35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "task_delete_popup_yes_button".tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  successPopupSnackBar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message, style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.green,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  errorPopupSnackBar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message, style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.red,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  successPopup(BuildContext context, String message) {
    FToast _ftoast = FToast();
    _ftoast.init(context);
    _ftoast.showToast(
      positionedToastBuilder: (context, child) {
        return Positioned(
          bottom: getScreenHeight(0.25),
          left: getScreenWidth(0.05),
          right: getScreenWidth(0.05),
          child: child,
        );
      },
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.green,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }
}
