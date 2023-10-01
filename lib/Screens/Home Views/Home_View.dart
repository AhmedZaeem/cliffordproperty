import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Screens/NotificationsScreen.dart';
import 'package:cliffordproperty/Widgets/MySearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Home View Sections/Category.dart';
import 'Home View Sections/NearestSection.dart';
import 'Home View Sections/RecommendedSection.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with Nav_Helper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  late TextEditingController _searchController;
  int indexOfSections = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center ,
              children: [
                // IconButton(
                //   icon: Icon(Icons.menu, size: 32.w),
                //   onPressed: () {
                //     Scaffold.of(context).openDrawer();
                //   },
                // ),
                InkWell(
                    child: Icon(Icons.menu,size: 32.w),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                 ),
                Image.asset('assets/images/logo.png', height: 64.h),
                // IconButton(
                //   icon: Icon(Icons.notifications_none_rounded, size: 32.w),
                //   onPressed: () {
                //     jump(context, const NotificationsScreen());
                //   },
                // ),
                InkWell(
                  child: Icon(Icons.notifications_none_rounded,size: 32.w),
                  onTap: () {
                    jump(context, const NotificationsScreen());
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              appLocale.findYourProperty,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                right: 16.w, left: 16.w, top: 24.h, bottom: 16.h),
            child: MySearchBar(controller: _searchController),
          ),

          ///Category section

          Category(
            selectedIndex: indexOfSections,
            onTap: (index) {
              setState(() {
                indexOfSections = index;
              });
            },
          ),

          ///Nearest to you section
          const NearestSection(),

          ///Recommended section

          const RecommendedSection(),
        ],
      ),
    );
  }
}
