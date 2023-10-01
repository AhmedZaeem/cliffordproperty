import 'package:cliffordproperty/Models/user_model.dart';
import 'package:cliffordproperty/cache/cache_controller.dart';
import 'package:cliffordproperty/enums.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? _) => [_user = _, notifyListeners()];

  Future<void> get logout async {
    _user = null;
    await CacheController().setter(CacheKeys.loggedIn, false);
    await CacheController().setter(CacheKeys.email, null);
    await FirebaseMessaging.instance.deleteToken();
  }
}
