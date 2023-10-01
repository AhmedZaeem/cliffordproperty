import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cliffordproperty/Helpers/pickers_helper.dart';
import 'package:cliffordproperty/Models/user_model.dart';
import 'package:cliffordproperty/Widgets/LoadingWidget.dart';
import 'package:cliffordproperty/Widgets/MyTextFormFiled.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:cliffordproperty/firebase/fb_storage_controller.dart';
import 'package:cliffordproperty/firebase/users_fb_controller.dart';
import 'package:cliffordproperty/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final bool cameFromDrawer;
  const ProfileView({this.cameFromDrawer = false, super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with PickersHelper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  AuthProvider get _auth => Provider.of<AuthProvider>(context, listen: false);

  final _key = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _telephoneController;
  late TextEditingController _cityController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _auth.user?.email ?? '');
    _nameController = TextEditingController(text: _auth.user?.name ?? '');
    _telephoneController = TextEditingController(text: _auth.user?.phone ?? '');
    _cityController = TextEditingController(text: _auth.user?.City ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _telephoneController.dispose();
    _cityController.dispose();
  }

  bool loading = false;
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 44.h),
                  Row(
                    children: <Widget>[
                      widget.cameFromDrawer
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 32.h,
                              ),
                              onPressed: () => Navigator.pop(context),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(width: widget.cameFromDrawer ? 100.w : 140.w),
                      Text(
                        appLocale.profile,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 44.h),
                  Stack(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () async {
                            var file = await pickImage();
                            if (file != null) {
                              setState(() => profileImage = file);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 18.h),
                            width: 120.w,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child:profileImage != null
                                ? Image.file(
                              profileImage!,
                              fit: BoxFit.cover,
                            )
                                : _auth.user?.image != null
                                ? CachedNetworkImage(
                              imageUrl: _auth.user?.image ?? '',
                              fit: BoxFit.cover,
                            ): CachedNetworkImage(
                                imageUrl: 'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1985&q=80'),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 0,
                        start: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 58.w, vertical: 4.h),
                          child: Text(
                            appLocale.profile,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 44.h),
                  Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLocale.name, style: _labelStyle),
                        SizedBox(height: 16.h),
                        MyTextFormField(
                          controller: _nameController,
                          filled: false,
                          border: const OutlineInputBorder(),
                          borderRadius: 5.r,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        Text(appLocale.email, style: _labelStyle),
                        SizedBox(height: 16.h),
                        MyTextFormField(
                          controller: _emailController,
                          filled: false,
                          border: const OutlineInputBorder(),
                          borderRadius: 5.r,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return appLocale.emailError;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        Text(appLocale.telephoneNumber, style: _labelStyle),
                        SizedBox(height: 16.h),
                        MyTextFormField(
                          controller: _telephoneController,
                          filled: false,
                          border: const OutlineInputBorder(),
                          borderRadius: 5.r,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid value';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        Text(appLocale.city, style: _labelStyle),
                        SizedBox(height: 16.h),
                        MyTextFormField(
                          controller: _cityController,
                          filled: false,
                          border: const OutlineInputBorder(),
                          borderRadius: 5.r,
                          actionType: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid value';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  My_Button(buttonText: appLocale.save, onTap:() async => _performUpdate),
                  SizedBox(height: 46.h),
                ],
              ),
            ),
          ),
          loading ? const LoadingWidget() : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: const SizedBox(),
    );
  }

  TextStyle get _labelStyle =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);


  Future<void> get _performUpdate async {
    if (_checkDate) {
      await _update;
    }
  }

  Future<void> get _update async {
    setState(() => loading = true);
    try {
      /// Storage
      var imageModel = await FbStorageController()
          .uploadFile(profileImage, path: 'users/${_auth.user?.id}');

      /// Firestore
      var status = await UsersFbController().update(userModel(imageModel));
     // var statu = await UsersFbController().read();
      _auth.user = userModel(imageModel);

      if (context.mounted && status) {
        Navigator.pop(context);
      }
    } catch (e) {
      ///
    }
    setState(() => loading = false);
  }

  UserModel userModel(String? imageModel) {
    return UserModel(
      email: _emailController.text,
      name: _nameController.text,
      fcm: _auth.user?.fcm,
      id: _auth.user?.id,
      phone: _telephoneController.text,
      City: _cityController.text,
      image: imageModel,
    );
  }
  bool get _checkDate {
    return true;
  }
}
