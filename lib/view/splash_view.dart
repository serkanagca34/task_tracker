import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_tacker/view/home_view.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..animateTo(10);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'splash_title'.tr(),
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: Theme.of(context).textTheme.displayLarge!.color,
                    fontSize: 40.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future onLoad() async {
    Future.delayed(
      const Duration(seconds: 5),
      () async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeView(index: 0)));
      },
    );
  }
}
