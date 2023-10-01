import 'package:cliffordproperty/Helpers/snakbar.dart';
import 'package:flutter/cupertino.dart';

mixin DataCheckerHelper on SnackBarHelper {
  bool checkText(
    BuildContext context, {
    required String text,
    required String message,
    bool email = false,
    bool password = false,
  }) {
    if (text.isEmpty) {
      _snack(context, message);
      return false;
    } else if (email) {
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text)) {
        _snack(context, 'Enter right email format!');

        return false;
      }
    }

    return true;
  }

  bool checkObject(
    BuildContext context, {
    required dynamic item,
    required String message,
  }) {
    if (item == null) {
      _snack(context, message);
      return false;
    }

    return true;
  }

  bool checkList(
    BuildContext context, {
    required List<dynamic> items,
    required String message,
  }) {
    if (items.isEmpty) {
      _snack(context, message);
      return false;
    }

    return true;
  }

  bool checkTextMatch(
    BuildContext context, {
    required String text1,
    required String text2,
    required String message,
  }) {
    if (text1 != text2) {
      _snack(context, message);
      return false;
    }

    return true;
  }

  void _snack(BuildContext context, String s) =>
      showSnackBar(context, message: s, error: true);
}
