import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/model/task_model.dart';
import 'package:task_tacker/services/service_locator.dart';
import 'package:task_tacker/view_model/task/task_cubit.dart';

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

  final _priorityLevels = locator<TaskCubit>().priorityLevels;

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
      appBar: appBar,
      body: body,
    );
  }

  get appBar => customAppBar(
        title: 'add_task_form_title'.tr(),
        centerTitle: false,
        titleSpacing: 20.w,
        toolbarHeight: 55.h,
        actions: [
          // Add Button
          BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskLoaded) {
                clearForm();
                Popups().successPopup(context, 'task_added'.tr());
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(right: 20.w, top: 10.h, bottom: 10.h),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<TaskCubit>().addTask(
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
                    minimumSize: MaterialStatePropertyAll(Size(75.w, 50.h)),
                    maximumSize: MaterialStatePropertyAll(Size(75.w, 50.h)),
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondary),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r))),
                  ),
                  child: Text(
                    'add_task_form_button_text'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  ),
                ),
              );
            },
          ),
        ],
      );

  get body {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35.h),
              // Title
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                autovalidateMode: _autovalidateMode,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                decoration: customInputDecoration(
                  hintText: "form_title_hint".tr(),
                  label: Text("form_title".tr()),
                ),
                onChanged: (value) => onFieldInteraction(),
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
                autovalidateMode: _autovalidateMode,
                decoration: customInputDecoration(
                    hintText: "form_description_hint".tr(),
                    label: Text("form_description".tr())),
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
                autovalidateMode: _autovalidateMode,
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: customInputDecoration(
                  hintText: 'form_duedate_hint'.tr(),
                  label: Text("form_duedate".tr()),
                ),
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
                autovalidateMode: _autovalidateMode,
                readOnly: true,
                decoration: customInputDecoration(
                    hintText: "form_priority_hint".tr(),
                    label: Text("form_priority".tr())),
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

  // Form clear
  void clearForm() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _dueDateController.clear();
      _priorityLevelsController.clear();
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }
}
