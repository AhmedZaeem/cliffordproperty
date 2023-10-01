import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin SnackBarHelper {
  void showSnackBar(
    BuildContext context, {
    required String message,
    required bool error,
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.replaceAll('Exception: ', ''),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor:
            error ? const Color(0xffff4d4f) : const Color(0xff52c41a),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.only(
          // right: 20.w,
          // left: 20.w,
          // bottom: 10.h,
        ),
        elevation: 10,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
