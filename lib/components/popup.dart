import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tacker/constans/colors.dart';
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
                            "No",
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
                            "Yes",
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

  errorPopup(BuildContext context, String message) {
    FToast _ftoast = FToast();
    _ftoast.init(context);
    _ftoast.showToast(
      positionedToastBuilder: (context, child) {
        return Positioned(
          bottom: getScreenHeight(0.22),
          left: 0,
          right: 0,
          child: child,
        );
      },
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'timesbold',
          fontSize: 16,
          color: Color(0xffEA0048),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }

  successSnackBar(BuildContext context, {required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: kPrimaryColor,
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'timesbold',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  errorSnackBar(BuildContext context, {required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Color.fromARGB(207, 255, 255, 255),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'timesbold',
            fontSize: 16,
            color: Color(0xffEA0048),
          ),
        ),
      ),
    );
  }
}
