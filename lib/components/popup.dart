import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Popups {
  final _screenWidth = ScreenUtil().screenWidth;
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
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          content: Container(
            width: _screenWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onTopNo,
                      child: Container(
                        height: 40.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Text(
                            "task_delete_popup_no_button".tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTopYes,
                      child: Container(
                        height: 40.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "task_delete_popup_yes_button".tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
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
      content: Text(message, style: TextStyle(fontSize: 18.sp)),
      backgroundColor: Colors.green,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 570.h, left: 10.w, right: 10.w),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  errorPopupSnackBar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message, style: TextStyle(fontSize: 18.sp)),
      backgroundColor: Colors.red,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 570.h, left: 10.w, right: 10.w),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  successPopup(BuildContext context, String message) {
    FToast _ftoast = FToast();
    _ftoast.init(context);
    _ftoast.showToast(
      positionedToastBuilder: (context, child) {
        return Positioned(
          bottom: 150.h,
          left: 15.w,
          right: 15.w,
          child: child,
        );
      },
      child: Container(
        height: 60.h,
        width: _screenWidth,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 2.w),
        ),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              fontSize: 12.sp,
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
