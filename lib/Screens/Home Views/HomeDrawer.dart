import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Helpers/snakbar.dart';
import 'package:cliffordproperty/Screens/ContactUsScreen.dart';
import 'package:cliffordproperty/Screens/Home%20Views/ProfileView.dart';
import 'package:cliffordproperty/Screens/NotificationsScreen.dart';
import 'package:cliffordproperty/Screens/auth/Login.dart';
import 'package:cliffordproperty/cache/cache_controller.dart';
import 'package:cliffordproperty/enums.dart';
import 'package:cliffordproperty/firebase/fb_auth_controller.dart';
import 'package:cliffordproperty/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget  {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with Nav_Helper, SnackBarHelper {
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return  Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadiusDirectional.horizontal(end: Radius.circular(16.r)),
            ),
            width: MediaQuery.of(context).size.width * .7,
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Container(
                  width: 120.w,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                      imageUrl:
                      'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1985&q=80'),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Mona',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'mona12@gmai.com',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 64.h),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {
                        jump(context, const ProfileView(cameFromDrawer: true));
                      },
                      child: ListTile(
                        leading: Image.asset('assets/images/Profile_Icon.png',
                            width: 32.w),
                        title: Text(
                          appLocale.profile,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 17.w,
                      endIndent: 28.w,
                      thickness: 2.h,
                      height: 30.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        jump(context, const NotificationsScreen());
                      },
                      child: ListTile(
                        leading: Image.asset('assets/images/Notification.png',
                            width: 32.w),
                        title: Text(
                          appLocale.notification,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 17.w,
                      endIndent: 28.w,
                      thickness: 2.h,
                      height: 30.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        jump(context, const ContactUsScreen());
                      },
                      child: ListTile(
                        leading:
                        Image.asset('assets/images/contact_us.png', width: 32.w),
                        title: Text(
                          appLocale.contactUs,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: InkWell(
                        onTap: () async => await _logout(auth),
                        child: Container(
                          height: 31.h,
                          width: 50.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: const Color(0xffEE4451),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/6.png',
                                width: 20.h,
                                height: 20.h,
                              ),
                              SizedBox(width: 27.w),
                              Text(appLocale.logOut,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
    );
  }
  Future<void> _logout(AuthProvider auth) async {
    try {
      print('1');
      auth.logout;
      print('2');
      await FbAuthController().logout();

      print('3');
      await CacheController().setter(CacheKeys.loggedIn, false);
      print('4');
      if(context.mounted){
        showSnackBar(context, message: 'your logout Successfully', error: false);
      }
      print('5');
    } catch (e) {
      ///
    }


    if(context.mounted){
      jump(context, const Login(),replace: true);
    }
  }
}
