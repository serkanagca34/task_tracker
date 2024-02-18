import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_tacker/components/costume_appbar.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/services/hive_boxes.dart';
import 'package:task_tacker/view/edit_task_view.dart';
import 'package:task_tacker/view/fake_api/fake_api_view.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';

class TasksView extends StatefulWidget {
  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  bool? horizontalDesingChange;

  @override
  void initState() {
    super.initState();
    context.read<AddTaskCubit>().getTasks();
    horizontalDesingChange =
        gridDesingChangeBox.get('gridDesingChangeBox') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: costumeAppBar(
          title: 'get_task_form_title'.tr(),
          leading: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FakeApiView())),
              icon: Icon(Icons.pages_outlined, color: Colors.white, size: 30)),
          actions: [
            BlocBuilder<AddTaskCubit, AddTaskState>(builder: (context, state) {
              if (state is AddTaskLoaded) {
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
            })
          ]),
      body: Stack(
        children: [
          gridDesingChangeBox.get('gridDesingChangeBox', defaultValue: false)
              ? gridListBuild()
              : horizontalCard(),
        ],
      ),
    );
  }

  Widget horizontalCard() {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        if (state is AddTaskLoaded) {
          return Column(
            children: [
              Expanded(
                child: state.tasks.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.tasks.length,
                        padding: EdgeInsets.only(
                            top: getScreenHeight(0.03),
                            bottom: getScreenHeight(0.15)),
                        itemBuilder: (context, index) {
                          final tasks = state.tasks[index];
                          Color? _priorityBoxColor = Colors.grey;

                          switch (tasks.priorityLevels) {
                            case 'Low' || 'Düşük':
                              _priorityBoxColor = Colors.green;
                              break;

                            case 'Medium' || 'Orta':
                              _priorityBoxColor = Colors.orange;
                              break;

                            case 'High' || 'Yüksek':
                              _priorityBoxColor = Colors.red;
                              break;
                            default:
                          }
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
                                              height: 106,
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
                                                          .read<AddTaskCubit>()
                                                          .deleteTask(
                                                              tasks.key!);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Task cannot be deleted. No valid key found.')),
                                                      );
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
                                              height: 106,
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
                                      height: 90,
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
                                          SizedBox(width: getScreenWidth(0.05)),
                                          // Title
                                          Expanded(
                                            child: Text(
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
                                          ),
                                          // Priority
                                          Container(
                                            height: 30,
                                            width: getScreenWidth(0.15),
                                            decoration: BoxDecoration(
                                              color: _priorityBoxColor,
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
                      )
                    : emptyListState(),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget gridListBuild() {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        if (state is AddTaskLoaded) {
          return Column(
            children: [
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
                          Color _priorityBoxColor = Colors.grey;

                          switch (tasks.priorityLevels) {
                            case 'Low' || 'Düşük':
                              _priorityBoxColor = Colors.green;
                              break;

                            case 'Medium' || 'Orta':
                              _priorityBoxColor = Colors.orange;
                              break;

                            case 'High' || 'Yüksek':
                              _priorityBoxColor = Colors.red;
                              break;
                            default:
                          }
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
                                            // Title
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
                                            // Priority
                                            Container(
                                              height: 30,
                                              width: getScreenWidth(0.15),
                                              decoration: BoxDecoration(
                                                color: _priorityBoxColor,
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
                                                        .read<AddTaskCubit>()
                                                        .deleteTask(tasks.key!);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Task cannot be deleted. No valid key found.')),
                                                    );
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
                    : emptyListState(),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Future<dynamic> taskDetail(BuildContext context, TaskModel taskDetail) {
    return showCupertinoModalBottomSheet(
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
              body: Column(
                children: [
                  SizedBox(height: getScreenHeight(0.02)),
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: getScreenHeight(0.03)),
                  Text(
                    'task_detail_title'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontFamily: 'PoppinsSemiBold',
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: getScreenHeight(0.05)),
                  // Task Detail Info
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getScreenWidth(0.05)),
                    child: Container(
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
                          Text('form_description'.tr(), style: titleTextStyle),
                          SizedBox(height: getScreenHeight(0.02)),
                          Text(taskDetail.description,
                              style: dataDetailTextStyle),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getScreenWidth(0.05)),
                    child: Container(
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
                          Text(taskDetail.dueDate, style: dataDetailTextStyle),
                        ],
                      ),
                    ),
                  ),
                  // Task completed
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: taskDetail.isCompleted,
                    checkColor: Theme.of(context).textTheme.displayLarge!.color,
                    title: Text('task_completed'.tr()),
                    onChanged: (value) {
                      context
                          .read<AddTaskCubit>()
                          .toggleTaskCompletion(taskDetail.key!);
                      setState(() {});
                    },
                  ),
                  Spacer(),
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getScreenWidth(0.05)),
                            child: Container(
                              height: 50,
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
                      ),
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
                                        .read<AddTaskCubit>()
                                        .deleteTask(taskDetail.key!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Task cannot be deleted. No valid key found.')),
                                    );
                                  }
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                onTopNo: () => Navigator.pop(context));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getScreenWidth(0.05)),
                            child: Container(
                              height: 50,
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
                      ),
                    ],
                  ),
                  SizedBox(height: getScreenHeight(0.05)),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => setState(() {}));
  }

  Widget emptyListState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/7.json',
              repeat: true, height: getScreenHeight(0.3)),
          Text(
            'no_task'.tr(),
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              fontSize: 12,
              color: Color.fromARGB(255, 158, 155, 155),
            ),
          ),
          SizedBox(height: getScreenHeight(0.20)),
        ],
      ),
    );
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
