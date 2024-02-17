import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/constans/colors.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/view_model/add_task/add_task_cubit.dart';

class EditTaskView extends StatefulWidget {
  final int taskKey;
  final TaskModel taskDetail;

  const EditTaskView({required this.taskKey, required this.taskDetail});

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _priorityLevelsController = TextEditingController();

  List<String> _priorityLevels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    context.read<AddTaskCubit>().getTasks();
    _titleController = TextEditingController(text: widget.taskDetail.title);
    _descriptionController =
        TextEditingController(text: widget.taskDetail.description);
    _dueDateController = TextEditingController(text: widget.taskDetail.dueDate);
    _priorityLevelsController =
        TextEditingController(text: widget.taskDetail.priorityLevels);
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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit Task',
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocBuilder<AddTaskCubit, AddTaskState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
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
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        decoration: inputDecoration(
                          hintText: "Enter Title",
                          label: Text("Title"),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        decoration: inputDecoration(
                            hintText: "Enter Description",
                            label: Text("Description")),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: inputDecoration(
                          hintText: 'Enter Due Date',
                          label: Text("Due Date"),
                        ),
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
                                            ?.color),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        decoration: inputDecoration(
                            hintText: "Enter Priority Level",
                            label: Text("Priority Level")),
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
                                            ?.color),
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
                      // Show Messages
                      BlocConsumer<AddTaskCubit, AddTaskState>(
                        listener: (context, state) {
                          if (state is AddTaskLoaded) {
                            SnackBar snackBar = SnackBar(
                              content: const Text('Task Edited',
                                  style: TextStyle(fontSize: 20)),
                              backgroundColor: Colors.green,
                              dismissDirection: DismissDirection.up,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 150,
                                  left: 10,
                                  right: 10),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                          if (state is AddTaskError) {
                            if (state.errorMessage.isNotEmpty) {
                              return Popups().errorSnackBar(context,
                                  message: state.errorMessage);
                            } else {
                              return null;
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is AddTaskLoading) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue));
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: getScreenHeight(0.15)),
                      // Edit Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getScreenWidth(0.03),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AddTaskCubit>().updateTask(
                                    widget.taskKey,
                                    TaskModel(
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      dueDate: _dueDateController.text,
                                      priorityLevels:
                                          _priorityLevelsController.text,
                                    ),
                                  );
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 55)),
                            maximumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 55)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blueGrey),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
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
