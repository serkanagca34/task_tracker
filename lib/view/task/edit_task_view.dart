import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/services/service_locator.dart';
import 'package:task_tacker/view_model/task/task_cubit.dart';

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

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  final _priorityLevels = locator<TaskCubit>().priorityLevels;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.taskDetail.title;
    _descriptionController.text = widget.taskDetail.description;
    _dueDateController.text = widget.taskDetail.dueDate;
    _priorityLevelsController.text = widget.taskDetail.priorityLevels;
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
      appBar: appBar,
      body: body,
    );
  }

  get appBar => customAppBar(
        title: 'edit_task_form_title'.tr(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
      );

  get body {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35.h),
              // Title
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                autovalidateMode: _autovalidateMode,
                onChanged: (value) => onFieldInteraction(),
                decoration: customInputDecoration(
                  hintText: "form_title_hint".tr(),
                  label: Text("form_title".tr()),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'form_title_error'.tr();
                  } else if (value.length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.h),
              // Description
              TextFormField(
                controller: _descriptionController,
                textInputAction: TextInputAction.done,
                decoration: customInputDecoration(
                    hintText: "form_description_hint".tr(),
                    label: Text("form_description".tr())),
                autovalidateMode: _autovalidateMode,
                onChanged: (value) => onFieldInteraction(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'form_description_error'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.h),
              // Due Date
              TextFormField(
                controller: _dueDateController,
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: customInputDecoration(
                  hintText: 'form_duedate_hint'.tr(),
                  label: Text("form_duedate".tr()),
                ),
                autovalidateMode: _autovalidateMode,
                onChanged: (value) => onFieldInteraction(),
                onTap: () => selectDatePicker(
                  context,
                  onDateTimeChanged: (value) {
                    setState(() {
                      final _dueDate = value.toString().substring(0, 16);
                      _dueDateController.text = _dueDate;
                      print('_dueDate: ${_dueDateController.text}');
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'form_duedate_error'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.h),
              // PriorityLevel
              TextFormField(
                controller: _priorityLevelsController,
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: customInputDecoration(
                    hintText: "form_priority_hint".tr(),
                    label: Text("form_priority".tr())),
                autovalidateMode: _autovalidateMode,
                onChanged: (value) => onFieldInteraction(),
                onTap: () => selectListPicker(
                  context,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      final _priority = _priorityLevels[index];
                      _priorityLevelsController.text = _priority;
                      print('_priority : ${_priorityLevelsController.text}');
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'form_priority_error'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.h),
              // Edit Button
              BlocConsumer<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is TaskLoaded) {
                    // Success Message
                    Popups().successPopupSnackBar(context, 'task_edited'.tr());
                    // Back to fake list
                    Future.delayed(Duration())
                        .then((value) => Navigator.pop(context));
                  }
                },
                builder: (context, state) {
                  // isloading process
                  if (state is TaskLoading) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Hive update method
                        context.read<TaskCubit>().updateTask(
                              widget.taskKey,
                              TaskModel(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                dueDate: _dueDateController.text,
                                priorityLevels: _priorityLevelsController.text,
                              ),
                            );

                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(310.w, 45.h)),
                      maximumSize: MaterialStatePropertyAll(Size(310.w, 45.h)),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blueGrey),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Text(
                      'edit_task_form_button_text'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AutovalidateMode change
  void onFieldInteraction() {
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
