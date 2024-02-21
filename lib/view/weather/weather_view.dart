import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_tacker/components/custom_widgets.dart';
import 'package:task_tacker/view_model/language_cubit.dart';
import 'package:task_tacker/view_model/theme_cubit.dart';
import 'package:task_tacker/view_model/weather/weather_cubit.dart';

class WeatherView extends StatefulWidget {
  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  get appBar => customAppBar(
        title: 'weather_page_title'.tr(),
        leading: IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: Icon(Icons.theater_comedy_outlined),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10.w),
            onPressed: () {
              context.read<LanguageCubit>().toggleLanguage();
              setState(() {
                _isClicked = !_isClicked;
              });
            },
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                _isClicked ? 'TR' : 'EN',
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Theme.of(context).textTheme.displayLarge!.color),
              ),
            ),
          ),
        ],
      );

  get body {
    return Column(
      children: [
        BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return Center(child: Text('Bilgiler Alınıyor...'));
            } else if (state is WeatherError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is WeatherSuccess) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 70.h),
                    // Title
                    Text(
                      'weather_my_location'.tr(),
                      style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 22.sp,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // My Location City
                    Text(
                      state.weatherData.name!,
                      style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 16.sp,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Tepm
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          convertKelvinToCelsius(state.weatherData.main!.temp!)
                              .toInt()
                              .toString(),
                          style: TextStyle(
                            fontFamily: 'PoppinsSemiBold',
                            fontSize: 30.sp,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                        Positioned(
                            right: -16.w,
                            child: SvgPicture.asset(
                              'assets/icons/temperature.svg',
                              height: 18.h,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
                            )),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Weather State
                    Text(
                      state.weatherData.weather![0].main!,
                      style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 15.sp,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Highest and Lowest
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              'highest'.tr() +
                                  ': ${convertKelvinToCelsius(state.weatherData.main!.tempMax!).toInt().toString()}',
                              style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 14.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                            ),
                            Positioned(
                              right: -6.w,
                              child: SvgPicture.asset(
                                'assets/icons/nodone.svg',
                                height: 6.h,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 20.h),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              'lowest'.tr() +
                                  ': ${convertKelvinToCelsius(state.weatherData.main!.tempMin!).toInt().toString()}',
                              style: TextStyle(
                                fontFamily: 'PoppinsSemiBold',
                                fontSize: 14.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                            ),
                            Positioned(
                              right: -6.w,
                              child: SvgPicture.asset(
                                'assets/icons/nodone.svg',
                                height: 6.h,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        )
      ],
    );
  }

  dynamic convertKelvinToCelsius(dynamic kelvin) {
    return kelvin - 273.15;
  }
}
