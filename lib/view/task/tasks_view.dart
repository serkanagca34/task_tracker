import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/responsive/media_query.dart';
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
                        padding: EdgeInsets.only(right: getScreenWidth(0.05)),
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
          return state.tasks.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: getScreenHeight(0.01)),
                    sortAndFilter,
                    // Tasks List
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.tasks.length,
                        padding: EdgeInsets.only(
                            top: getScreenHeight(0.03),
                            bottom: getScreenHeight(0.15)),
                        itemBuilder: (context, index) {
                          final tasks = state.tasks[index];
                          return GestureDetector(
                            onTap: () => taskDetail(context, tasks),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getScreenWidth(0.04)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: Builder(
                                      builder: (context) => Container(
                                        height: 106,
                                        margin: EdgeInsets.only(
                                            bottom: getScreenHeight(0.03)),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              height: getScreenHeight(0.10),
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      getScreenHeight(0.03)),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Colors.orange,
                                                    Colors.orange,
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(14),
                                                  topRight: Radius.circular(14),
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
                                              height: getScreenHeight(0.10),
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      getScreenHeight(0.03)),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFD92525),
                                                    Color(0xFFD92525),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(14),
                                                  topRight: Radius.circular(14),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/delete-white.svg',
                                                    height: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: getScreenHeight(0.10),
                                      margin: EdgeInsets.only(
                                          bottom: getScreenHeight(0.03)),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                108, 74, 115, 168),
                                            blurRadius: 15,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: getScreenWidth(0.05)),
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
                                          SizedBox(width: getScreenWidth(0.04)),
                                          // Title & date
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // Title
                                              Text(
                                                tasks.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsSemiBold',
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.color,
                                                ),
                                              ),
                                              // Date
                                              Text(
                                                tasks.dueDate,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'PoppinsSemiBold',
                                                  fontSize: 14,
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
                                            height: getScreenHeight(0.05),
                                            width: getScreenWidth(0.15),
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
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                          SizedBox(width: getScreenWidth(0.05)),
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
                    ),
                  ],
                )
              : emptyListWidget('no_task'.tr());
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
              SizedBox(height: getScreenHeight(0.01)),
              sortAndFilter,
              // List
              Expanded(
                child: state.tasks.isNotEmpty
                    ? GridView.builder(
                        itemCount: state.tasks.length,
                        padding: EdgeInsets.only(
                            right: getScreenWidth(0.04),
                            left: getScreenWidth(0.04),
                            bottom: getScreenHeight(0.15)),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 15,
                          crossAxisCount: 2,
                          mainAxisExtent: 225,
                        ),
                        itemBuilder: (context, index) {
                          final tasks = state.tasks[index];
                          return GestureDetector(
                            onTap: () => taskDetail(context, tasks),
                            child: Column(
                              children: [
                                SizedBox(height: getScreenHeight(0.03)),
                                Expanded(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Task Info
                                      Container(
                                        height: 300,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getScreenWidth(0.04),
                                          vertical: getScreenHeight(0.02),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  108, 74, 115, 168),
                                              blurRadius: 15,
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
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.color,
                                              ),
                                            ),
                                            // Priority
                                            Container(
                                              height: 30,
                                              width: getScreenWidth(0.15),
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
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Delete Button
                                      Positioned(
                                        top: -getScreenHeight(0.009),
                                        right: -getScreenWidth(0.01),
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
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/icons/delete.svg'),
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
                      )
                    : emptyListWidget('no_task'.tr()),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget get sortAndFilter {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getScreenWidth(0.05)),
      child: Row(
        children: [
          SizedBox(width: getScreenWidth(0.02)),
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
      topRadius: Radius.circular(35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: getScreenWidth(0.05)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: getScreenHeight(0.02)),
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
                      SizedBox(height: getScreenHeight(0.03)),
                      // Modal Title
                      Text(
                        'task_detail_title'.tr(),
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: getScreenHeight(0.05)),
                      // Description
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: getScreenHeight(0.04)),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff061B3D).withOpacity(0.25),
                              blurRadius: 15,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.description),
                            SizedBox(height: getScreenHeight(0.02)),
                            Text('form_description'.tr(),
                                style: titleTextStyle),
                            SizedBox(height: getScreenHeight(0.02)),
                            Text(taskDetail.description,
                                style: dataDetailTextStyle),
                          ],
                        ),
                      ),
                      // Due Date
                      Container(
                        height: 120,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: getScreenHeight(0.04)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff061B3D).withOpacity(0.25),
                              blurRadius: 15,
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
                      SizedBox(height: getScreenHeight(0.03)),
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
                      SizedBox(height: getScreenHeight(0.03)),
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
                            minimumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 55)),
                            maximumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 55)),
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
                      SizedBox(height: getScreenHeight(0.03)),
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
                                height: getScreenHeight(0.06),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Center(
                                  child: Text(
                                    'task_detail_edit_button'.tr(),
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(0.05)),
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
                                height: getScreenHeight(0.06),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(44, 244, 67, 54),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Center(
                                  child: Text(
                                    'task_detail_delete_button'.tr(),
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getScreenHeight(0.05)),
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
