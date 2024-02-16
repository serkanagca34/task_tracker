import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_tacker/constans/colors.dart';
import 'package:task_tacker/responsive/media_query.dart';
import 'package:task_tacker/view/add_task_view.dart';
import 'package:task_tacker/view/weather_view.dart';
import 'tasks_view.dart';

class HomeView extends StatefulWidget {
  final int index;
  const HomeView({super.key, required this.index});
  @override
  State<HomeView> createState() => _HomeViewState(selectedIndex: index);
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  _HomeViewState({required this.selectedIndex});
  static List<Widget> _widgetOptions = <Widget>[
    TasksView(),
    AddTaskView(),
    WeatherView(),
  ];

  List<String> _iconList = [
    'assets/icons/list_icon.svg',
    'assets/icons/add.svg',
    'assets/icons/weather.svg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          Center(child: _widgetOptions.elementAt(selectedIndex)),
          botNavBar(),
        ],
      ),
    );
  }

  Widget botNavBar() {
    SizeConfig().init(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: screenHeight * 0.90,
      left: screenWidth * 0.035,
      width: screenWidth,
      child: Padding(
        padding: EdgeInsets.only(left: getScreenWidth(0.00)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Icon List
            ClipPath(
              clipper: BarizeCurved(),
              child: Container(
                width: screenWidth,
                height: 896,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: getScreenWidth(0.10),
                    right: getScreenWidth(0.17),
                    top: getScreenHeight(0.015),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 0; i < _iconList.length; i++)
                        Visibility(
                          visible: _iconList[i] == 'assets/icons/add.svg'
                              ? false
                              : true,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            iconSize: 30,
                            onPressed: () {
                              _onItemTapped(i);
                              print('index : ${i}');
                            },
                            icon: Container(
                              child: SvgPicture.asset(
                                _iconList[i],
                                color: selectedIndex == i
                                    ? kSecondryColor
                                    : Colors.white,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Add Task
            Positioned(
              top: screenWidth < 360
                  ? -screenHeight * 0.045
                  : -screenHeight * 0.035,
              left: screenWidth * 0.26,
              right: screenWidth * 0.33,
              child: GestureDetector(
                onTap: () => _onItemTapped(1),
                child: Container(
                    height: 59,
                    width: 59,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/add.svg',
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarizeCurved extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 896;
    path.lineTo(368 * _xScaling, 75 * _yScaling);
    path.cubicTo(
      368 * _xScaling,
      75 * _yScaling,
      17 * _xScaling,
      75 * _yScaling,
      17 * _xScaling,
      75 * _yScaling,
    );
    path.cubicTo(
      12.488847470770452 * _xScaling,
      75.01238559303056 * _yScaling,
      8.160226950533115 * _xScaling,
      73.21950678193603 * _yScaling,
      4.979000000000042 * _xScaling,
      70.021 * _yScaling,
    );
    path.cubicTo(
      1.7803983309413525 * _xScaling,
      66.83983594037184 * _yScaling,
      -0.012497609098772955 * _xScaling,
      62.511175148599555 * _yScaling,
      0 * _xScaling,
      58 * _yScaling,
    );
    path.cubicTo(
      0 * _xScaling,
      58 * _yScaling,
      0 * _xScaling,
      17 * _yScaling,
      0 * _xScaling,
      17 * _yScaling,
    );
    path.cubicTo(
      -0.012386044608319935 * _xScaling,
      12.488846887037838 * _yScaling,
      1.780492802822664 * _xScaling,
      8.160227362558889 * _yScaling,
      4.979000000000042 * _xScaling,
      4.978999999999999 * _yScaling,
    );
    path.cubicTo(
      8.160226950533115 * _xScaling,
      1.7804932180639668 * _yScaling,
      12.488847470770452 * _xScaling,
      -0.012385593030550979 * _yScaling,
      17 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      17 * _xScaling,
      0 * _yScaling,
      121.76599999999996 * _xScaling,
      0 * _yScaling,
      121.76599999999996 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      123.14650705340296 * _xScaling,
      0.3664718707028385 * _yScaling,
      124.57210339132462 * _xScaling,
      0.5348228580839347 * _yScaling,
      126 * _xScaling,
      0.5 * _yScaling,
    );
    path.cubicTo(
      129.37050861411046 * _xScaling,
      0.4796819572486726 * _yScaling,
      132.7158403457537 * _xScaling,
      1.081421073076534 * _yScaling,
      135.86800000000005 * _xScaling,
      2.2749999999999986 * _yScaling,
    );
    path.cubicTo(
      138.83387118925054 * _xScaling,
      3.425011546117336 * _yScaling,
      141.61381271654147 * _xScaling,
      5.0063770706902915 * _yScaling,
      144.11800000000005 * _xScaling,
      6.967999999999996 * _yScaling,
    );
    path.cubicTo(
      149.2030000000001 * _xScaling,
      10.857999999999997 * _yScaling,
      153.673 * _xScaling,
      16.167999999999996 * _yScaling,
      157.9960000000001 * _xScaling,
      21.305999999999997 * _yScaling,
    );
    path.cubicTo(
      167.0630000000001 * _xScaling,
      32.077999999999996 * _yScaling,
      176.4380000000001 * _xScaling,
      43.217 * _yScaling,
      192.4960000000001 * _xScaling,
      43.217 * _yScaling,
    );
    path.cubicTo(
      208.52800000000013 * _xScaling,
      43.217 * _yScaling,
      217.85000000000014 * _xScaling,
      32.108999999999995 * _yScaling,
      226.86500000000012 * _xScaling,
      21.366 * _yScaling,
    );
    path.cubicTo(
      231.18600000000015 * _xScaling,
      16.217 * _yScaling,
      235.6540000000001 * _xScaling,
      10.892999999999999 * _yScaling,
      240.75600000000009 * _xScaling,
      6.990000000000002 * _yScaling,
    );
    path.cubicTo(
      243.27249599488323 * _xScaling,
      5.019770759924899 * _yScaling,
      246.06678062563878 * _xScaling,
      3.43290554849019 * _yScaling,
      249.04800000000012 * _xScaling,
      2.2810000000000024 * _yScaling,
    );
    path.cubicTo(
      252.2279372266952 * _xScaling,
      1.0816680593617392 * _yScaling,
      255.6014839558096 * _xScaling,
      0.4779417376858426 * _yScaling,
      259 * _xScaling,
      0.5 * _yScaling,
    );
    path.cubicTo(
      260.4394221358857 * _xScaling,
      0.5346918334106654 * _yScaling,
      261.87655163768557 * _xScaling,
      0.3663702592607301 * _yScaling,
      263.269 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      263.269 * _xScaling,
      0 * _yScaling,
      368 * _xScaling,
      0 * _yScaling,
      368 * _xScaling,
      0 * _yScaling,
    );
    path.cubicTo(
      372.51115252922955 * _xScaling,
      -0.012385593030554531 * _yScaling,
      376.83977304946677 * _xScaling,
      1.7804932180639739 * _yScaling,
      380.02099999999996 * _xScaling,
      4.978999999999999 * _yScaling,
    );
    path.cubicTo(
      383.21950719717745 * _xScaling,
      8.160227362558889 * _yScaling,
      385.0123860446083 * _xScaling,
      12.488846887037836 * _yScaling,
      385 * _xScaling,
      17 * _yScaling,
    );
    path.cubicTo(
      385 * _xScaling,
      17 * _yScaling,
      385 * _xScaling,
      58 * _yScaling,
      385 * _xScaling,
      58 * _yScaling,
    );
    path.cubicTo(
      385.01234182872736 * _xScaling,
      62.51085080595466 * _yScaling,
      383.21944929311803 * _xScaling,
      66.83914328620878 * _yScaling,
      380.02099999999996 * _xScaling,
      70.02 * _yScaling,
    );
    path.cubicTo(
      376.8399372637667 * _xScaling,
      73.21887445666373 * _yScaling,
      372.5112981480364 * _xScaling,
      75.01212191696743 * _yScaling,
      368 * _xScaling,
      75 * _yScaling,
    );
    path.cubicTo(
      368 * _xScaling,
      75 * _yScaling,
      368 * _xScaling,
      75 * _yScaling,
      368 * _xScaling,
      75 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
