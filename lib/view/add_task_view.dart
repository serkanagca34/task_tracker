import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/constans/colors.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';

class AddTaskView extends StatefulWidget {
  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _priorityLevelsController = TextEditingController();

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  List<String> _priorityLevels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _titleController.text;
    _descriptionController.text;
    _dueDateController.text;
    _priorityLevelsController.text;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _priorityLevelsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 70,
          centerTitle: false,
          titleSpacing: getScreenWidth(0.05),
          title: Text(
            'Add Task',
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          actions: [
            // Add Button
            BlocConsumer<AddTaskCubit, AddTaskState>(
              listener: (context, state) {
                if (state is AddTaskLoaded) {
                  clearForm();
                  Popups().successPopup(context, 'Task Added');
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getScreenWidth(0.05),
                      vertical: getScreenHeight(0.02)),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AddTaskCubit>().addTask(
                              TaskModel(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                dueDate: _dueDateController.text,
                                priorityLevels: _priorityLevelsController.text,
                              ),
                            );
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(
                          Size(getScreenWidth(0.20), 55)),
                      maximumSize: MaterialStatePropertyAll(
                          Size(getScreenWidth(0.20), 55)),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge!.color),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AddTaskCubit, AddTaskState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getScreenWidth(0.05)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: getScreenHeight(0.05)),
                      // Title
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: _autovalidateMode,
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        decoration: inputDecoration(
                          hintText: "Enter Title",
                          label: Text("Title"),
                        ),
                        onChanged: (value) => onFieldInteraction(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is Required';
                          } else if (value.length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: getScreenHeight(0.05)),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: _autovalidateMode,
                        decoration: inputDecoration(
                            hintText: "Enter Description",
                            label: Text("Description")),
                        onChanged: (value) => onFieldInteraction(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is Required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: getScreenHeight(0.05)),
                      // Due Date
                      TextFormField(
                        controller: _dueDateController,
                        autovalidateMode: _autovalidateMode,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: inputDecoration(
                          hintText: 'Enter Due Date',
                          label: Text("Due Date"),
                        ),
                        onChanged: (value) => onFieldInteraction(),
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                actions: [chooseDueDate()],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Due Date is Required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: getScreenHeight(0.05)),
                      // PriorityLevel
                      TextFormField(
                        controller: _priorityLevelsController,
                        keyboardType: TextInputType.none,
                        autovalidateMode: _autovalidateMode,
                        readOnly: true,
                        decoration: inputDecoration(
                            hintText: "Enter Priority Level",
                            label: Text("Priority Level")),
                        onChanged: (value) => onFieldInteraction(),
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                actions: [choosePriority()],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Priority is Required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: getScreenHeight(0.05)),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  void onFieldInteraction() {
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  void clearForm() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _dueDateController.clear();
      _priorityLevelsController.clear();
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }

  Widget chooseDueDate() => SizedBox(
        height: 180,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.of(context).pop(true),
          child: CupertinoDatePicker(
            backgroundColor: Colors.transparent,
            initialDateTime: DateTime(DateTime.now().year),
            mode: CupertinoDatePickerMode.dateAndTime,
            onDateTimeChanged: (value) {
              setState(() {
                final _dueDate =
                    value.toString().substring(0, 16).split(' ').join(' / ');
                _dueDateController.text = _dueDate;
                print('_dueDate: ${_dueDateController.text}');
              });
            },
          ),
        ),
      );

  Widget choosePriority() => SizedBox(
        height: 200,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.of(context).pop(true),
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: 0),
            backgroundColor: Colors.transparent,
            itemExtent: 64,
            onSelectedItemChanged: (index) {
              setState(() {
                final _priority = _priorityLevels[index];
                _priorityLevelsController.text = _priority;
                print('_priority : ${_priorityLevelsController.text}');
              });
            },
            children: _priorityLevels
                .map((item) => Center(
                        child: Text(
                      item.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    )))
                .toList(),
          ),
        ),
      );

  InputDecoration inputDecoration({
    required String hintText,
    required Widget label,
  }) {
    return InputDecoration(
      hintText: hintText,
      label: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: kTextColorLight),
        gapPadding: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.blue),
        gapPadding: 10,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red),
        gapPadding: 10,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red),
        gapPadding: 10,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }
}
