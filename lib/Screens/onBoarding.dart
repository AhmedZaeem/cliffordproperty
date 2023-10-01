import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Models/OnBoardingModel.dart';
import 'package:cliffordproperty/Screens/HomeScreen.dart';
import 'package:cliffordproperty/Screens/auth/Login.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:cliffordproperty/cache/cache_controller.dart';
import 'package:cliffordproperty/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with Nav_Helper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }


    int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    List<OnBoardingModel> screens = [
      OnBoardingModel(
          image: 'boarding1',
          title: appLocale.boardingTitle1,
          subTitle: appLocale.boardingSub1),
      OnBoardingModel(
          image: 'boarding2',
          title: appLocale.boardingTitle2,
          subTitle: appLocale.boardingSub2),
      OnBoardingModel(
          image: 'boarding3',
          title: appLocale.boardingTitle3,
          subTitle: appLocale.boardingSub3),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () async {
                  bool loggedIn = CacheController().getter(CacheKeys.loggedIn) ?? false;
                  jump(context,  loggedIn ? const HomeScreen() : const Login(), replace: true);
                  },
              child: Text('Skip',
                  style: TextStyle(
                    color: const Color(0xffB1B1B1),
                    fontSize: 16.sp,
                  )),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      selectedPage = value;
                    });
                  },
                  controller: _controller,
                  itemBuilder: (context, index) {
                    final item = screens[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64.w),
                      child: Column(
                        children: [
                          SizedBox(height: 90.h),
                          Hero(
                              tag: 'logo',
                              child: SvgPicture.asset(
                                  'assets/images/${item.image}.svg')),
                          SizedBox(height: 16.h),
                          Text(item.title,
                              style: Theme.of(context).textTheme.headlineSmall),
                          SizedBox(height: 14.h),
                          Text(
                            item.subTitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: screens.length,
                ),
                PositionedDirectional(
                  bottom: 80.h,
                  start: 165.w,
                  child: SizedBox(
                    height: 10.h,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 8.w);
                      },
                      itemCount: screens.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.w),
            child: My_Button(
              buttonText: appLocale.start,
              onTap: () {
                if (selectedPage == 2) {
                  bool loggedIn = CacheController().getter(CacheKeys.loggedIn) ?? false;
                  jump(context,  loggedIn ? const Login() : const HomeScreen(), replace: true);
                } else {
                  setState(() {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  });
                }
              },
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}
