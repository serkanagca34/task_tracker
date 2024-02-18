import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_tacker/components/costume_appbar.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/constans/colors.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/view_model/fake_api/fake_api_cubit.dart';

class FakeApiView extends StatefulWidget {
  @override
  State<FakeApiView> createState() => _FakeApiViewState();
}

class _FakeApiViewState extends State<FakeApiView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _priorityLevelsController = TextEditingController();

  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  List<String> get _priorityLevels {
    return ['priority_low'.tr(), 'priority_medium'.tr(), 'priority_high'.tr()];
  }

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
      appBar: costumeAppBar(
          title: 'get_fake_form_title'.tr(),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  clearForm();
                  postFakeApi(context);
                },
                icon: Icon(Icons.add_box_outlined,
                    color: Colors.white, size: 30)),
          ]),
      body: Column(
        children: [
          Expanded(child: BlocBuilder<FakeApiCubit, FakeApiState>(
            builder: (context, state) {
              if (state is FakeApiLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is FakeApiError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is FakeApiSuccess) {
                return ListView.builder(
                  itemCount: state.fakeApiData.length,
                  padding: EdgeInsets.only(
                      top: getScreenHeight(0.03),
                      bottom: getScreenHeight(0.15)),
                  itemBuilder: (context, index) {
                    final items = state.fakeApiData[index];
                    return GestureDetector(
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
                                    borderRadius: BorderRadius.circular(20),
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
                                  // Put Button
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _titleController.text =
                                              items.title ?? '';
                                          _descriptionController.text =
                                              items.description ?? '';
                                          _dueDateController.text =
                                              items.duedate ?? '';
                                          _priorityLevelsController.text =
                                              items.priority ?? '';
                                        });
                                        putFakeApi(
                                          context,
                                          _titleController.text,
                                          _descriptionController.text,
                                          _dueDateController.text,
                                          _priorityLevelsController.text,
                                          items.id,
                                        );
                                      },
                                      child: Container(
                                        height: 106,
                                        margin: EdgeInsets.only(
                                            bottom: getScreenHeight(0.03)),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.orange,
                                              Colors.orange,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(14),
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
                                        Popups().QuestionDangerPopup(context,
                                            title:
                                                'fake_delete_popup_title'.tr(),
                                            message: 'fake_delete_popup_message'
                                                .tr(),
                                            onTopYes: () {
                                              if (items.id != null) {
                                                context
                                                    .read<FakeApiCubit>()
                                                    .deleteFakeApiData(
                                                        items.id!);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Record cannot be deleted. No valid key found.')),
                                                );
                                              }
                                              SnackBar snackBar = SnackBar(
                                                content: const Text(
                                                    'Record Deleted',
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                backgroundColor: Colors.green,
                                                dismissDirection:
                                                    DismissDirection.up,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            150,
                                                    left: 10,
                                                    right: 10),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);

                                              Navigator.pop(context);
                                            },
                                            onTopNo: () =>
                                                Navigator.pop(context));
                                      },
                                      child: Container(
                                        height: 106,
                                        margin: EdgeInsets.only(
                                            bottom: getScreenHeight(0.03)),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFD92525),
                                              Color(0xFFD92525),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(14),
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
                                height: 100,
                                margin: EdgeInsets.only(
                                    bottom: getScreenHeight(0.03)),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(108, 74, 115, 168),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: getScreenWidth(0.05)),
                                        // Job Title
                                        Expanded(
                                          child: Text(
                                            items.title!,
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
                                        // Job Field
                                        Container(
                                          height: 30,
                                          width: getScreenWidth(0.30),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Text(
                                            items.priority!,
                                            style: TextStyle(
                                              fontFamily: 'PoppinsSemiBold',
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge
                                                  ?.color,
                                            ),
                                          )),
                                        ),
                                        SizedBox(width: getScreenWidth(0.05)),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: getScreenWidth(0.05)),
                                        // Job description
                                        Expanded(
                                          child: Text(
                                            items.description!,
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
                                        // Job duedate
                                        Container(
                                          height: 30,
                                          width: getScreenWidth(0.30),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Text(
                                            items.duedate!.split('T')[0],
                                            style: TextStyle(
                                              fontFamily: 'PoppinsSemiBold',
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge
                                                  ?.color,
                                            ),
                                          )),
                                        ),
                                        SizedBox(width: getScreenWidth(0.05)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return SizedBox.shrink();
            },
          ))
        ],
      ),
    );
  }

  Future<dynamic> postFakeApi(BuildContext context) {
    return showCupertinoModalBottomSheet(
      barrierColor: Colors.transparent.withOpacity(0.5),
      topRadius: Radius.circular(35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
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
                  'add_fake_form_title'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: getScreenHeight(0.05)),
                // Form
                BlocBuilder<FakeApiCubit, FakeApiState>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getScreenWidth(0.05)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: getScreenHeight(0.05)),
                              // Title
                              TextFormField(
                                controller: _titleController,
                                textInputAction: TextInputAction.done,
                                autovalidateMode: _autovalidateMode,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30)
                                ],
                                decoration: inputDecoration(
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
                                decoration: inputDecoration(
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
                                decoration: inputDecoration(
                                  hintText: 'form_duedate_hint'.tr(),
                                  label: Text("form_duedate".tr()),
                                ),
                                onChanged: (value) => onFieldInteraction(),
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        actions: [chooseDueDate()],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                decoration: inputDecoration(
                                    hintText: "form_priority_hint".tr(),
                                    label: Text("form_priority".tr())),
                                onChanged: (value) => onFieldInteraction(),
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        actions: [choosePriority()],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                    );
                  },
                ),
                // Post Button
                BlocConsumer<FakeApiCubit, FakeApiState>(
                  listener: (context, state) {
                    if (state is FakeApiSuccess) {
                      clearForm();
                      Popups().successPopup(context, 'fake_added'.tr());
                      Future.delayed(Duration())
                          .then((value) => Navigator.pop(context));
                    }
                  },
                  builder: (context, state) {
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
                            context.read<FakeApiCubit>().postFakeApiData(
                                _titleController.text,
                                _descriptionController.text,
                                _dueDateController.text,
                                _priorityLevelsController.text);
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(
                              Size(getScreenWidth(0.20), 55)),
                          maximumSize: MaterialStatePropertyAll(
                              Size(getScreenWidth(0.20), 55)),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.secondary),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        child: Text(
                          'add_fake_form_button_text'.tr(),
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> putFakeApi(
      BuildContext context, title, description, duedate, priority, ID) {
    return showCupertinoModalBottomSheet(
      barrierColor: Colors.transparent.withOpacity(0.5),
      topRadius: Radius.circular(35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
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
                  'edit_fake_form_title'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: getScreenHeight(0.05)),
                // Form
                BlocBuilder<FakeApiCubit, FakeApiState>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getScreenWidth(0.05)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: getScreenHeight(0.05)),
                              // Title
                              TextFormField(
                                controller: _titleController,
                                textInputAction: TextInputAction.done,
                                autovalidateMode: _autovalidateMode,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30)
                                ],
                                decoration: inputDecoration(
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
                                decoration: inputDecoration(
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
                                decoration: inputDecoration(
                                  hintText: 'form_duedate_hint'.tr(),
                                  label: Text("form_duedate".tr()),
                                ),
                                onChanged: (value) => onFieldInteraction(),
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        actions: [chooseDueDate()],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                decoration: inputDecoration(
                                    hintText: "form_priority_hint".tr(),
                                    label: Text("form_priority".tr())),
                                onChanged: (value) => onFieldInteraction(),
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        actions: [choosePriority()],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                    return 'form_priority_error'.tr();
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
                ),
                // Post Button
                BlocConsumer<FakeApiCubit, FakeApiState>(
                  listener: (context, state) {
                    if (state is FakeApiSuccess) {
                      clearForm();
                      Popups().successPopup(context, 'fake_edited'.tr());
                      Future.delayed(Duration())
                          .then((value) => Navigator.pop(context));
                    }
                  },
                  builder: (context, state) {
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
                            context.read<FakeApiCubit>().putFakeApiData(
                                title, description, duedate, priority, ID);
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(
                              Size(getScreenWidth(0.25), 55)),
                          maximumSize: MaterialStatePropertyAll(
                              Size(getScreenWidth(0.25), 55)),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.secondary),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        child: Text(
                          'edit_fake_form_button_text'.tr(),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
