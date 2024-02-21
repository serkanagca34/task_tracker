import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:task_tacker/constans/colors.dart';
import 'package:task_tacker/services/service_locator.dart';
import 'package:task_tacker/view_model/task/task_cubit.dart';

customAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
  bool? centerTitle,
  double? toolbarHeight,
  double? titleSpacing,
}) {
  return AppBar(
    elevation: 0,
    centerTitle: centerTitle,
    toolbarHeight: toolbarHeight,
    titleSpacing: titleSpacing,
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'PoppinsBold',
        fontSize: 15.sp,
        color: Colors.white,
      ),
    ),
    leading: leading,
    actions: actions,
  );
}

customInputDecoration({required String hintText, required Widget label}) {
  return InputDecoration(
    hintText: hintText,
    label: label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: kTextColorLight),
      gapPadding: 10.r,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: Colors.blue),
      gapPadding: 10.r,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: Colors.red),
      gapPadding: 10.r,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: Colors.red),
      gapPadding: 10.r,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 18.r),
  );
}

selectDatePicker(BuildContext context,
    {required void Function(DateTime) onDateTimeChanged}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 150.h,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.of(context).pop(true),
              child: CupertinoDatePicker(
                backgroundColor: Colors.transparent,
                minimumDate: DateTime.now(),
                minimumYear: 1,
                use24hFormat: true,
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: onDateTimeChanged,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'cancel'.tr(),
            style: TextStyle(
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
        ),
      );
    },
  );
}

selectListPicker(BuildContext context,
    {required void Function(int)? onSelectedItemChanged}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 150.h,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.of(context).pop(true),
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: 0),
                backgroundColor: Colors.transparent,
                itemExtent: 50.h,
                onSelectedItemChanged: onSelectedItemChanged,
                children: locator<TaskCubit>()
                    .priorityLevels
                    .map((item) => Center(
                            child: Text(
                          item.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        )))
                    .toList(),
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
        ),
      );
    },
  );
}

emptyListWidget(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 60.h),
        Lottie.asset('assets/lottie/7.json', repeat: true, height: 200.h),
        Text(
          message,
          style: TextStyle(
            fontFamily: 'PoppinsSemiBold',
            fontSize: 10.sp,
            color: Color.fromARGB(255, 158, 155, 155),
          ),
        ),
      ],
    ),
  );
}
