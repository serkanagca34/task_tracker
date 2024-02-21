import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/services/service_locator.dart';
import 'package:task_tacker/view_model/task/task_cubit.dart';
import 'package:task_tacker/view_model/fake_api/fake_api_cubit.dart';

class FakeApiAddView extends StatefulWidget {
  @override
  State<FakeApiAddView> createState() => _FakeApiAddViewState();
}

class _FakeApiAddViewState extends State<FakeApiAddView> {
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar,
      body: body,
    );
  }

  get appBar => customAppBar(
        title: 'add_fake_form_title'.tr(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
      );

  Widget get body {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Form
          Form(
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
                    SizedBox(height: getScreenHeight(0.05)),
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
                    SizedBox(height: getScreenHeight(0.05)),
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
                    SizedBox(height: getScreenHeight(0.05)),
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
                            print(
                                '_priority : ${_priorityLevelsController.text}');
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'form_priority'.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: getScreenHeight(0.05)),
                  ],
                ),
              ),
            ),
          ),
          // Button
          BlocConsumer<FakeApiCubit, FakeApiState>(
            listener: (context, state) {
              if (state is FakeApiSuccess) {
                // Success Message
                Popups().successPopupSnackBar(context, 'fake_added'.tr());
                // Back to fake list
                Future.delayed(Duration())
                    .then((value) => Navigator.pop(context));
              }
            },
            builder: (context, state) {
              // isloading process
              if (state is FakeApiLoading) {
                return Center(child: CupertinoActivityIndicator());
              }
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(0.05),
                    vertical: getScreenHeight(0.02)),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Api post method
                      context.read<FakeApiCubit>().postFakeApiData(
                          _titleController.text,
                          _descriptionController.text,
                          _dueDateController.text,
                          _priorityLevelsController.text);
                    }
                  },
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 55)),
                    maximumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 55)),
                    backgroundColor: MaterialStatePropertyAll(Colors.blueGrey),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                  ),
                  child: Text(
                    'add_fake_form_button_text'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge!.color,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
