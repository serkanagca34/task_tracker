import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_tacker/components/costume_appbar.dart';
import 'package:task_tacker/constans/colors.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/view_model/weather/weather_cubit.dart';

class WeatherView extends StatefulWidget {
  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: costumeAppBar(title: 'Weather'),
      body: Column(
        children: [
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is WeatherError) {
                return Center(child: Text(state.errorMessage));
              } else if (state is WeatherSuccess) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: getScreenHeight(0.10)),
                      // Title
                      Text(
                        'My Location',
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 25,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(height: getScreenHeight(0.01)),
                      // My Location City
                      Text(
                        state.weatherData.name!,
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 18,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(height: getScreenHeight(0.01)),
                      // Tepm
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            convertKelvinToCelsius(
                                    state.weatherData.main!.temp!)
                                .toInt()
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'PoppinsSemiBold',
                              fontSize: 40,
                              color: kPrimaryColor,
                            ),
                          ),
                          Positioned(
                              right: -20,
                              child: SvgPicture.asset(
                                  'assets/icons/temperature.svg')),
                        ],
                      ),
                      SizedBox(height: getScreenHeight(0.01)),
                      // Weather State
                      Text(
                        state.weatherData.weather![0].main!,
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 18,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(height: getScreenHeight(0.01)),
                      // Highest and Lowest
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                'H:${convertKelvinToCelsius(state.weatherData.main!.tempMax!).toInt().toString()}',
                                style: TextStyle(
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: 18,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Positioned(
                                right: -10,
                                child: SvgPicture.asset(
                                  'assets/icons/nodone.svg',
                                  height: 10,
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: getScreenWidth(0.04)),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                'L:${convertKelvinToCelsius(state.weatherData.main!.tempMin!).toInt().toString()}',
                                style: TextStyle(
                                  fontFamily: 'PoppinsSemiBold',
                                  fontSize: 18,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Positioned(
                                right: -10,
                                child: SvgPicture.asset(
                                  'assets/icons/nodone.svg',
                                  height: 10,
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
      ),
    );
  }

  double convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}