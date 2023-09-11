import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Screens/HomeScreen.dart';
import 'package:cliffordproperty/Screens/auth/Register.dart';
import 'package:cliffordproperty/Widgets/LoadingWidget.dart';
import 'package:cliffordproperty/Widgets/LoginUsingScocialMedia.dart';
import 'package:cliffordproperty/Widgets/MyCheckBox.dart';
import 'package:cliffordproperty/Widgets/MyTextFormFiled.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Reset Password/ForgotPassword.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Nav_Helper {
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
                          preformAction();
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
                My_Button(buttonText: appLocale.login, onTap: preformAction),
                SizedBox(height: 32.h),
                const LoginUsingSocialMedia(),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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

  preformAction() {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            isLoading = false;
          });
        },
      ).then((value) => jump(context, const HomeScreen(), replaceUntil: true));
    }
  }
}
