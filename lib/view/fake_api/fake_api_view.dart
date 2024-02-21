import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/components/popup.dart';
import 'package:task_tacker/view/fake_api/fake_api_add_view.dart';
import 'package:task_tacker/view/fake_api/fake_api_edit_view.dart';
import 'package:task_tacker/view_model/fake_api/fake_api_cubit.dart';

class FakeApiView extends StatefulWidget {
  @override
  State<FakeApiView> createState() => _FakeApiViewState();
}

class _FakeApiViewState extends State<FakeApiView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar,
      body: body,
    );
  }

  get appBar => customAppBar(
        title: 'get_fake_form_title'.tr(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FakeApiAddView())),
              icon:
                  Icon(Icons.add_box_outlined, color: Colors.white, size: 30)),
        ],
      );

  Widget get body {
    return Column(
      children: [
        BlocBuilder<FakeApiCubit, FakeApiState>(
          builder: (context, state) {
            if (state is FakeApiLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is FakeApiError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is FakeApiSuccess) {
              return Expanded(
                child: state.fakeApiData.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.fakeApiData.length,
                        padding: EdgeInsets.only(top: 30.h, bottom: 50.h),
                        itemBuilder: (context, index) {
                          final items = state.fakeApiData[index];
                          return GestureDetector(
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
                                        // Put Button
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FakeApiEditView(
                                                    id: items.id!,
                                                    title: items.title!,
                                                    description:
                                                        items.description!,
                                                    duedate: items.duedate!,
                                                    priority: items.priority!,
                                                  ),
                                                )),
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
                                                      'fake_delete_popup_title'
                                                          .tr(),
                                                  message:
                                                      'fake_delete_popup_message'
                                                          .tr(),
                                                  onTopYes: () {
                                                    if (items.id != null) {
                                                      context
                                                          .read<FakeApiCubit>()
                                                          .deleteFakeApiData(
                                                              items.id!);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Record cannot be deleted. No valid key found.')),
                                                      );
                                                    }
                                                    SnackBar snackBar =
                                                        SnackBar(
                                                      content: const Text(
                                                          'Record Deleted',
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                      backgroundColor:
                                                          Colors.green,
                                                      dismissDirection:
                                                          DismissDirection.up,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      margin: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              150,
                                                          left: 10,
                                                          right: 10),
                                                    );

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);

                                                    Navigator.pop(context);
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
                                      height: 90.h,
                                      margin: EdgeInsets.only(bottom: 15.h),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20.w),
                                              // Title
                                              Expanded(
                                                child: Text(
                                                  items.title!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    fontSize: 12.sp,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.color,
                                                  ),
                                                ),
                                              ),
                                              // priority
                                              Container(
                                                height: 30.h,
                                                width: 110.w,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  items.priority!,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    fontSize: 10.sp,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.color,
                                                  ),
                                                )),
                                              ),
                                              SizedBox(width: 20.w),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20.w),
                                              // description
                                              Expanded(
                                                child: Text(
                                                  items.description!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    fontSize: 12.sp,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.color,
                                                  ),
                                                ),
                                              ),
                                              // duedate
                                              Container(
                                                height: 30.h,
                                                width: 110.w,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  items.duedate!.split('T')[0],
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PoppinsSemiBold',
                                                    fontSize: 10.sp,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.color,
                                                  ),
                                                )),
                                              ),
                                              SizedBox(width: 20.w),
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
                      )
                    : emptyListWidget('no_task'.tr()),
              );
            }
            return SizedBox.shrink();
          },
        )
      ],
    );
  }
}
