import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/services/hive_boxes.dart';
import 'package:task_tacker/services/notifications.dart';
import 'package:task_tacker/view/task/edit_task_view.dart';
import 'package:task_tacker/view/fake_api/fake_api_view.dart';
import 'package:task_tacker/view_model/task/task_cubit.dart';

class TasksView extends StatefulWidget {
  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  bool? horizontalDesingChange;

  String selectedSort = 'high'.tr();

  Set<String> selectedFilters = {};

  bool _isSelectedRemindDate = false;

  TextEditingController _reminderDateController = TextEditingController();

  final _screenWidth = ScreenUtil().screenWidth;

  @override
  void initState() {
    super.initState();
    horizontalDesingChange =
        gridDesingChangeBox.get('gridDesingChangeBox') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  get appBar => customAppBar(
        title: 'get_task_form_title'.tr(),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FakeApiView())),
            icon: Icon(Icons.pages_outlined, color: Colors.white, size: 30)),
        actions: [
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded) {
                return state.tasks.isNotEmpty
                    ? IconButton(
                        padding: EdgeInsets.only(right: 20.w),
                        constraints: BoxConstraints(),
                        onPressed: () async {
                          await gridDesingChangeBox.put(
                              'gridDesingChangeBox', !horizontalDesingChange!);
                          setState(() {
                            horizontalDesingChange = !horizontalDesingChange!;
                          });
                        },
                        icon: gridDesingChangeBox.get('gridDesingChangeBox',
                                defaultValue: false)
                            ? SvgPicture.asset(
                                'assets/icons/grid-svgrepo-com.svg')
                            : SvgPicture.asset('assets/icons/changeDesing.svg'),
                      )
                    : SizedBox.shrink();
              }
              return SizedBox.shrink();
            },
          )
        ],
      );

  get body {
    return Stack(
      children: [
        gridDesingChangeBox.get('gridDesingChangeBox', defaultValue: false)
            ? gridListBuild
            : horizontalDesing,
      ],
    );
  }

  Widget get horizontalDesing {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              sortAndFilter,
              // Tasks List
              state.tasks.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: state.tasks.length,
                        padding: EdgeInsets.only(top: 25.h, bottom: 80.h),
                        itemBuilder: (context, index) {
                          final tasks = state.tasks[index];
                          return GestureDetector(
                            onTap: () => taskDetail(context, tasks),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: Builder(
                                      builder: (context) => Container(
                                        height: 106.h,
                                        margin: EdgeInsets.only(bottom: 21.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Slidable(
                                    key: UniqueKey(),
                                    direction: Axis.horizontal,
                                    endActionPane: ActionPane(
                                      motion: BehindMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        // Edit Button
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTaskView(
                                                            taskKey: tasks.key!,
                                                            taskDetail: tasks),
                                                  ));
                                            },
                                            child: Container(
                                              height: 106.h,
                                              margin:
                                                  EdgeInsets.only(bottom: 21.h),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Colors.orange,
                                                    Colors.orange,
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(14.r),
                                                  topRight:
                                                      Radius.circular(14.r),
                                                ),
                                              ),
                                              child: Icon(Icons.edit,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        // Delete Button
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Popups().QuestionDangerPopup(
                                                  context,
                                                  title:
                                                      'task_delete_popup_title'
                                                          .tr(),
                                                  message:
                                                      'task_delete_popup_message'
                                                          .tr(),
                                                  onTopYes: () {
                                                    if (tasks.key != null) {
                                                      context
                                                          .read<TaskCubit>()
                                                          .deleteTask(
                                                              tasks.key!);

                                                      Popups()
                                                          .successPopupSnackBar(
                                                              context,
                                                              'task_deleted'
                                                                  .tr());
                                                    } else {
                                                      Popups().errorPopupSnackBar(
                                                          context,
                                                          'Task cannot be deleted. No valid key found.'
                                                              .tr());
                                                    }
                                                    Navigator.popUntil(
                                                        context,
                                                        (route) =>
                                                            route.isFirst);
                                                  },
                                                  onTopNo: () =>
                                                      Navigator.pop(context));
                                            },
                                            child: Container(
                                              height: 106.h,
                                              margin:
                                                  EdgeInsets.only(bottom: 21.h),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFD92525),
                                                    Color(0xFFD92525),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(14.r),
                                                  topRight:
                                                      Radius.circular(14.r),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/delete-white.svg',
                                                      height: 15.h),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: 70.h,
                                      margin: EdgeInsets.only(bottom: 20.h),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                108, 74, 115, 168),
                                            blurRadius: 15.r,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 15.w),
                                          // Complete icons
                                          tasks.isCompleted
                                              ? SvgPicture.asset(
                                                  'assets/icons/done.svg',
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.color,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/icons/nodone.svg',
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.color,
                                                ),
                                          SizedBox(width: 15.w),
                                          // Title & date
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Title
                                              Text(
                                                tasks.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsSemiBold',
                                                  fontSize: 12.sp,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.color,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              // Date
                                              Text(
                                                tasks.dueDate,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsSemiBold',
                                                  fontSize: 12.sp,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          // Priority
                                          Container(
                                            height: 35.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              color: getBoxColor(
                                                  tasks.priorityLevels),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                                child: Text(
                                              tasks.priorityLevels,
                                              style: TextStyle(
                                                fontFamily: 'PoppinsSemiBold',
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                          SizedBox(width: 15.w),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : emptyListWidget('no_task'.tr()),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget get gridListBuild {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              sortAndFilter,
              // List
              state.tasks.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        itemCount: state.tasks.length,
                        padding: EdgeInsets.only(
                            right: 15.w, left: 15.w, bottom: 80.h),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 20.h,
                          mainAxisSpacing: 15.w,
                          crossAxisCount: 2,
                          mainAxisExtent: 200.w,
                        ),
                        itemBuilder: (context, index) {
                          final tasks = state.tasks[index];
                          return GestureDetector(
                            onTap: () => taskDetail(context, tasks),
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                Expanded(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Task Info
                                      Container(
                                        width: _screenWidth,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  108, 74, 115, 168),
                                              blurRadius: 15.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // Complete icons
                                            tasks.isCompleted
                                                ? SvgPicture.asset(
                                                    'assets/icons/done.svg',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.color,
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/icons/nodone.svg',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.color,
                                                  ),
                                            // Title
                                            Text(
                                              tasks.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'PoppinsSemiBold',
                                                fontSize: 12.sp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.color,
                                              ),
                                            ),
                                            // Due date
                                            Text(
                                              tasks.dueDate,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'PoppinsSemiBold',
                                                fontSize: 12.sp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .color,
                                              ),
                                            ),
                                            // Priority
                                            Container(
                                              height: 25.h,
                                              width: 55.w,
                                              decoration: BoxDecoration(
                                                color: getBoxColor(
                                                    tasks.priorityLevels),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                tasks.priorityLevels,
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsSemiBold',
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Delete Button
                                      Positioned(
                                        top: -6.h,
                                        right: -3.w,
                                        child: GestureDetector(
                                          onTap: () {
                                            Popups().QuestionDangerPopup(
                                                context,
                                                title: 'task_delete_popup_title'
                                                    .tr(),
                                                message:
                                                    'task_delete_popup_message'
                                                        .tr(),
                                                onTopYes: () {
                                                  if (tasks.key != null) {
                                                    context
                                                        .read<TaskCubit>()
                                                        .deleteTask(tasks.key!);

                                                    Popups()
                                                        .successPopupSnackBar(
                                                            context,
                                                            'task_deleted'
                                                                .tr());
                                                  } else {
                                                    Popups().errorPopupSnackBar(
                                                        context,
                                                        'Task cannot be deleted. No valid key found');
                                                  }
                                                  Navigator.popUntil(context,
                                                      (route) => route.isFirst);
                                                },
                                                onTopNo: () =>
                                                    Navigator.pop(context));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/icons/delete.svg',
                                                height: 10.h),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : emptyListWidget('no_task'.tr()),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget get sortAndFilter {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          SizedBox(width: 5.w),
          // Sort
          DropdownButton<String>(
            icon: Icon(Icons.sort),
            isDense: true,
            value: selectedSort,
            items: <String>[
              'last_date'.tr(),
              'completed'.tr(),
              'high'.tr(),
              'medium'.tr(),
              'low'.tr(),
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                if (newValue == 'last_date'.tr()) {
                  context.read<TaskCubit>().sortTasksByLastDate();
                } else if (newValue == 'completed'.tr()) {
                  context.read<TaskCubit>().sortTasksByCompletion();
                } else if (newValue == 'high'.tr()) {
                  context.read<TaskCubit>().sortTasksByPriority('High');
                } else if (newValue == 'medium'.tr()) {
                  context.read<TaskCubit>().sortTasksByPriority('Medium');
                } else if (newValue == 'low'.tr()) {
                  context.read<TaskCubit>().sortTasksByPriority('Low');
                }
                setState(() {
                  selectedSort = newValue;
                });
              }
            },
          ),
          Spacer(),
          // Filter
          PopupMenuButton(
            icon: Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                ...<String>[
                  'completed'.tr(),
                  'high'.tr(),
                  'medium'.tr(),
                  'low'.tr()
                ].map((String value) {
                  return PopupMenuItem(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return CheckboxListTile(
                          checkColor:
                              Theme.of(context).textTheme.displayLarge!.color,
                          title: Text(value),
                          value: selectedFilters.contains(value),
                          onChanged: (bool? newValue) {
                            setState(() {
                              if (newValue == true) {
                                selectedFilters.add(value);
                              } else {
                                selectedFilters.remove(value);
                              }
                            });
                            context
                                .read<TaskCubit>()
                                .filterTasks(selectedFilters);
                          },
                        );
                      },
                    ),
                  );
                }).toList(),
              ];
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> taskDetail(BuildContext context, TaskModel taskDetail) {
    return showCupertinoModalBottomSheet(
      expand: true,
      enableDrag: true,
      barrierColor: Colors.transparent.withOpacity(0.5),
      topRadius: Radius.circular(35.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      // Modal Title
                      Text(
                        'task_detail_title'.tr(),
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // Description
                      Container(
                        width: _screenWidth,
                        margin: EdgeInsets.only(bottom: 25.h),
                        padding: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff061B3D).withOpacity(0.25),
                              blurRadius: 15.r,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.description),
                            SizedBox(height: 8.h),
                            Text('form_description'.tr(),
                                style: titleTextStyle),
                            SizedBox(height: 12.h),
                            Text(taskDetail.description,
                                style: dataDetailTextStyle),
                          ],
                        ),
                      ),
                      // Due Date
                      Container(
                        height: 100.h,
                        width: _screenWidth,
                        margin: EdgeInsets.only(bottom: 25.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff061B3D).withOpacity(0.25),
                              blurRadius: 15.r,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.calendar_month),
                            Text('form_duedate'.tr(), style: titleTextStyle),
                            Text(taskDetail.dueDate,
                                style: dataDetailTextStyle),
                          ],
                        ),
                      ),
                      // Task completed
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: taskDetail.isCompleted,
                        checkColor:
                            Theme.of(context).textTheme.displayLarge!.color,
                        title: Text('task_completed'.tr()),
                        onChanged: (value) {
                          context
                              .read<TaskCubit>()
                              .toggleTaskCompletion(taskDetail.key!);
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 20.h),
                      // Select Reminder Date
                      TextFormField(
                        controller: _reminderDateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: customInputDecoration(
                          hintText: 'reminder_input_hint'.tr(),
                          label: Text("reminder_input_title".tr()),
                        ),
                        onTap: () => selectDatePicker(
                          context,
                          onDateTimeChanged: (value) {
                            setState(() {
                              _reminderDateController.text =
                                  value.toString().substring(0, 16);
                              _isSelectedRemindDate = true;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Remind Button
                      Visibility(
                        visible: _isSelectedRemindDate,
                        child: ElevatedButton(
                          onPressed: () {
                            LocalNotifications().scheduleNotification(
                              taskDetail.key!,
                              taskDetail.title,
                              taskDetail.priorityLevels,
                              _reminderDateController.text,
                            );

                            setState(() {
                              _reminderDateController.clear();
                              _isSelectedRemindDate = false;
                              Popups().successPopup(
                                  context, 'reminder_message'.tr());
                            });
                          },
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStatePropertyAll(Size(310.w, 45.h)),
                            maximumSize:
                                MaterialStatePropertyAll(Size(310.w, 45.h)),
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.secondary),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          child: Text(
                            'reminder_button_text'.tr(),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // Buttons
                      Row(
                        children: [
                          // Edit Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTaskView(
                                          taskKey: taskDetail.key!,
                                          taskDetail: taskDetail),
                                    ));
                              },
                              child: Container(
                                height: 40.h,
                                width: _screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Center(
                                  child: Text(
                                    'task_detail_edit_button'.tr(),
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20.h),
                          // Delete Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Popups().QuestionDangerPopup(context,
                                    title: 'task_delete_popup_title'.tr(),
                                    message: 'task_delete_popup_message'.tr(),
                                    onTopYes: () {
                                      if (taskDetail.key != null) {
                                        context
                                            .read<TaskCubit>()
                                            .deleteTask(taskDetail.key!);

                                        Popups().successPopupSnackBar(
                                            context, 'task_deleted'.tr());
                                      } else {
                                        Popups().errorPopupSnackBar(context,
                                            'Task cannot be deleted. No valid key found');
                                      }
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    },
                                    onTopNo: () => Navigator.pop(context));
                              },
                              child: Container(
                                height: 40.h,
                                width: _screenWidth,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(44, 244, 67, 54),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Center(
                                  child: Text(
                                    'task_detail_delete_button'.tr(),
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontSize: 14.sp,
                                    ),
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
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
      context.read<TaskCubit>().sortTasksByCompletion();
      _reminderDateController.clear();
      _isSelectedRemindDate = false;
    });
  }

  Color getBoxColor(String priorityLevels) {
    Color priorityBoxColor = Colors.grey;

    switch (priorityLevels) {
      case 'Low':
        priorityBoxColor = Colors.green;
        break;

      case 'Medium':
        priorityBoxColor = Colors.orange;
        break;

      case 'High':
        priorityBoxColor = Colors.red;
        break;

      default:
        priorityBoxColor;
    }

    return priorityBoxColor;
  }

  TextStyle get dataTextStyle {
    return TextStyle(
      fontFamily: 'PoppinsSemiBold',
      fontSize: 16,
      color: Color(0xff0D1863),
    );
  }

  TextStyle get dataDetailTextStyle {
    return TextStyle(
      color: Color(0xffAA975A),
      fontFamily: 'PoppinsSemiBold',
      fontSize: 16,
    );
  }

  TextStyle get titleTextStyle {
    return TextStyle(
      color: Color(0xffABB5C4),
      fontFamily: 'PoppinsSemiBold',
      fontSize: 12,
    );
  }
}
