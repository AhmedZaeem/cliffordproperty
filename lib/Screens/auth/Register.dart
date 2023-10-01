import 'package:circle_flags/circle_flags.dart';
import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Helpers/checker_helper.dart';
import 'package:cliffordproperty/Helpers/data_checker_helper.dart';
import 'package:cliffordproperty/Helpers/snakbar.dart';
import 'package:cliffordproperty/Models/user_model.dart';
import 'package:cliffordproperty/Widgets/LoadingWidget.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:cliffordproperty/enums.dart';
import 'package:cliffordproperty/firebase/fb_auth_controller.dart';
// import 'package:cliffordproperty/firebase/fb_auth_controller.dart';
import 'package:cliffordproperty/firebase/users_fb_controller.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../Widgets/LoginUsingScocialMedia.dart';
import '../../Widgets/MyTextFormFiled.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with Nav_Helper, SnackBarHelper,DataCheckerHelper,CheckerHelper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool isLoading = false;
  bool passwordIsShown = false;
  @override
  void initState() {
    super.initState();
    initCountry();

    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  late Country? _selectedCountry;
  void initCountry() async {
    final country = await getCountries(context);
    setState(() {
      _selectedCountry = country.first;
    });
  }

  final _key = GlobalKey<FormState>();

  void _showCountryPicker() async {
    final country = await showCountryPickerSheet(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 40.h),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 32.h),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 90.w),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80.w,
                      height: 80.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(appLocale.signUp,
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 12.h),
              Text(appLocale.sampleText,
                  style: Theme.of(context).textTheme.displaySmall),
              SizedBox(height: 24.h),
              Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocale.fullName),
                    SizedBox(height: 8.h),
                    MyTextFormField(
                      prefix: 'user_icon',
                      hint: appLocale.fullNameHint,
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocale.fullNameError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
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
                    Text(appLocale.phoneNumber),
                    SizedBox(height: 8.h),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _showCountryPicker(),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            width: 112.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.1),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  child: _selectedCountry == null
                                      ? Container()
                                      : CircleFlag(
                                          _selectedCountry!.countryCode,
                                          size: 32.w,
                                        ),
                                ),
                                Text(_selectedCountry?.callingCode ?? '+93'),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: MyTextFormField(
                            controller: _phoneController,
                            hint: appLocale.phoneHint,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return appLocale.phoneError;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(appLocale.password),
                    SizedBox(height: 8.h),
                    MyTextFormField(
                      prefix: 'password_icon',
                      hint: appLocale.passwordHint,
                      controller: _passwordController,
                      maxLines: 1,
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
                        ///TODO: What THIS
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
              Text.rich(TextSpan(children: [
                TextSpan(text: appLocale.signUpPolicy),
                TextSpan(
                    text: appLocale.termsOfCondition,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ])),
              SizedBox(height: 28.h),
              My_Button(buttonText: appLocale.signUp, onTap:() async => preformAction),
              SizedBox(height: 24.h),
              const LoginUsingSocialMedia(),
              SizedBox(height: 28.h),
            ],
          ),
          isLoading ? const LoadingWidget() : const SizedBox.shrink(),
        ],
      ),
    );
  }
  Future<void> get preformAction async {
    if (_checkData) {
       action();
    }
  }

  Future<void> action() async{
    // if (_key.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        /// Auth
        var authStatus = await FbAuthController().createAccount(
            email: _emailController.text,
            password: _passwordController.text);

        if (authStatus == null) throw Exception('Auth Error!');

        /// FCM
        String fcm = await FirebaseMessaging.instance.getToken() ?? '';

        /// Firestore
        bool firestoreStatus = await UsersFbController().register(
            context,
            UserModel(
          id: const Uuid().v4(),
          email: _emailController.text,
          name: _fullNameController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          fcm: fcm,
          permission: AppPermission.user.name,
        ));

        if (!firestoreStatus) throw Exception('Firestore Error!');

        if (context.mounted) {
          showSnackBar(
            context, message: 'Account Created Successfully!', error: false,
          );
          Navigator.pop(context);
        }
      } catch (e) {
        showSnackBar(context, message: e.toString(), error: true);
      }
  }
  bool get _checkData {
    checkText(
      context,
      text: _fullNameController.text,
      message: 'Enter your name!',
    ) &&
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
        ) &&
        checkText(
          context,
          text: _phoneController.text,
          message: 'Enter your phone!',
          password: true,
        );
    return true;
  }
}
