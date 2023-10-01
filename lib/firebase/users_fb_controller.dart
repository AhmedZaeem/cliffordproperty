import 'package:cliffordproperty/Helpers/snakbar.dart';
import 'package:cliffordproperty/Models/user_model.dart';
import 'package:cliffordproperty/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UsersFbController with SnackBarHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collectionPath = FbCollection.users.name;

  Future<bool> register(BuildContext context, UserModel user) async {
    var data = await checkUserByEmail(user.email ?? '');
    if (data == null) {
      await _firestore
          .collection(collectionPath)
          .doc(user.id)
          .set(user.toJson());

      return true;
    } else {
      if (context.mounted) {
        showSnackBar(context, message: 'User exist!', error: true);
        return false;
      }
    }

    return false;
  }

  Future<UserModel?> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    var user = await checkUserByEmail(email);
    if (user != null) {
      /// Check Password
      if (user.password != password) {
        if (context.mounted) {
          showSnackBar(
            context,
            message: 'Wrong password!',
            error: true,
          );
        }
        return null;
      } else {
        return user;
      }
    } else {
      if (context.mounted) {
        showSnackBar(
          context,
          message: 'User not found!',
          error: true,
        );
      }

      return null;
    }
  }

  Future<UserModel?> checkUserByEmail(String email) async {
    var data = await _firestore
        .collection(collectionPath)
        .where('email', isEqualTo: email)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .get();

    List<UserModel> list = data.docs.map((e) => e.data()).toList();

    if (list.isNotEmpty) {
      return list.first;
    }

    return null;
  }

  Future<bool> update(UserModel user) async {
    await _firestore
        .collection(collectionPath)
        .doc(user.id)
        .update(user.toJson())
        .catchError((onError) => false);

    return true;
  }
}
