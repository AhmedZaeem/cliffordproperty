import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Helpers/data_checker_helper.dart';
import 'package:cliffordproperty/Helpers/snakbar.dart';
import 'package:cliffordproperty/Screens/HomeScreen.dart';
import 'package:cliffordproperty/Screens/admin_main_screen.dart';
import 'package:cliffordproperty/Screens/auth/Register.dart';
import 'package:cliffordproperty/Widgets/LoadingWidget.dart';
import 'package:cliffordproperty/Widgets/LoginUsingScocialMedia.dart';
import 'package:cliffordproperty/Widgets/MyCheckBox.dart';
import 'package:cliffordproperty/Widgets/MyTextFormFiled.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:cliffordproperty/cache/cache_controller.dart';
import 'package:cliffordproperty/enums.dart';
import 'package:cliffordproperty/firebase/fb_auth_controller.dart';
import 'package:cliffordproperty/firebase/users_fb_controller.dart';
import 'package:cliffordproperty/providers/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Reset Password/ForgotPassword.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Nav_Helper,SnackBarHelper, DataCheckerHelper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _key = GlobalKey<FormState>();
  bool isObscure = true;
  bool isChecked = false;
  bool isLoading = false;
  bool passwordIsShown = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100.w,
                      height: 100.w,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  appLocale.login.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  appLocale.loginSub,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 24.h),
                Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocale.email),
                      SizedBox(height: 8.h),
                      MyTextFormField(
                        prefix: 'email_icon',
                        hint: appLocale.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return appLocale.emailError;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(appLocale.password),
                      SizedBox(height: 8.h),
                      MyTextFormField(
                        prefix: 'password_icon',
                        hint: appLocale.passwordHint,
                        maxLines: 1,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return appLocale.passwordError;
                          }
                          return null;
                        },
                        isObscure: !passwordIsShown,
                        onSubmit: (value) {
                          /// TODO: WHAT THIS IS DO
                        },
                        suffix: IconButton(
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            onPressed: () {
                              setState(() {
                                passwordIsShown = !passwordIsShown;
                              });
                            }),
                        actionType: TextInputAction.done,
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      overlayColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(95.r),
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: MyCheckBox(
                        checked: isChecked,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      appLocale.rememberMe,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => jump(context, const ForgotPassword()),
                      child: Text(
                        appLocale.forgotPassword,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                My_Button(
                    buttonText: appLocale.login,
                    onTap: () async => _performLogin),
                SizedBox(height: 32.h),
                const LoginUsingSocialMedia(),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocale.doNotAlreadyHaveAnAccount,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        jump(context, const Register());
                      },
                      child: Text(
                        appLocale.signUp,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoading ? const LoadingWidget() : const SizedBox.shrink(),
        ],
      ),
    );
  }
  AuthProvider get _auth => Provider.of<AuthProvider>(context, listen: false);

  Future<void> get _performLogin async {
    if (_checkData) {
      await _login;
    }
  }

  Future<void> get _login async {
    setState(() => isLoading = true);

    try {
      var user = await UsersFbController().login(
        context,
        email: _emailController.text,
        password: _passwordController.text,
      );
      var authStatus = await FbAuthController().login(
          email: _emailController.text,
          password: _passwordController.text);


      if (user != null) {
        /// FCM => Update
        var fcm = await FirebaseMessaging.instance.getToken();
        user.fcm = fcm;
        await UsersFbController().update(user);

        /// Cache => Logged in, email
        await CacheController().setter(CacheKeys.loggedIn, true);
        await CacheController().setter(CacheKeys.email, user.email);

        /// Auth Provider => User
        _auth.user = user;

        /// Favorites
        //await _favorites;

        /// Navigate => Main
        if (context.mounted) {
          jump(
            context,
             user.permission == AppPermission.user.name
                ? const HomeScreen()
                : const AdminMainScreen(),
            replace: true,
          );
        }
      }
    } catch (e) {
      showSnackBar(context, message: e.toString(), error: true);
    }
    setState(() => isLoading = false);

  }


  bool get _checkData =>
    checkText(
      context,
      text: _emailController.text,
      message: 'Enter your email!',
      email: true,
    ) &&
        checkText(
          context,
          text: _passwordController.text,
          message: 'Enter your password!',
          password: true,
        );


}

/// Cache:
/// - id, name, email, fcm
/// - Model => toJson => jsonEncode => String
/// Provider:
/// Full Model

