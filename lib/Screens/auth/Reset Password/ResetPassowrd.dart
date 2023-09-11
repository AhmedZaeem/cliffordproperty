import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Screens/auth/Login.dart';
import 'package:cliffordproperty/Widgets/LoadingWidget.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Widgets/MyTextFormFiled.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with Nav_Helper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  bool passwordIsShown = false;
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 32.w,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: SvgPicture.asset(
                      'assets/images/reset_password_security.svg'),
                ),
                SizedBox(height: 16.h),
                Text(
                  appLocale.resetPassword,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 10.h),
                Text(appLocale.resetYourPasswordAndLogin,
                    style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: 14.h),
                Text(appLocale.password),
                SizedBox(height: 8.h),
                MyTextFormField(
                  prefix: 'password_icon',
                  hint: appLocale.passwordHint,
                  controller: _passwordController,
                  isObscure: !passwordIsShown,
                  maxLines: 1,
                  onChange: (value) {
                    if (value.isEmpty || value.length < 6) {
                      setState(() {
                        error = appLocale.passwordError;
                      });
                    } else {
                      setState(() {
                        error = '';
                      });
                    }
                  },
                  errorMessage: error,
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
                SizedBox(height: 40.h),
                My_Button(buttonText: appLocale.verify, onTap: preformAction),
              ],
            ),
          ),
          isLoading ? const LoadingWidget() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void preformAction() {
    if (_passwordController.text.length >= 6) {
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
      ).then((value) => jump(context, const Login(), replaceUntil: true));
    }
  }
}
