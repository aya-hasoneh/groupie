import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/helper/helper_function.dart';
import 'package:mychatapp/main.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';

class RegisterProvider with ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// Register Firebase

  Future register(context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
    }
    await registerUserWithEmailAndPassword(context).then((value) async {
      if (value == true) {
        // save the Shared Preferences State
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserNameSf(fullName.text);
        await HelperFunction.saveUserEmailSf(email.text);
        nextScreenNavigation(context, HomePage());
      } else {
        showSnackBar(context, Constants.blueColor, value);
        isLoading = false;
      }
    });
    notifyListeners();
  }

  Future registerUserWithEmailAndPassword(context) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email.text, password: password.text)).user!;

      if (user != null ) {
        await DatabaseService(uid: user.uid)
            .savingUserData(fullName.text, email.text);
        return true;
      }
      // Perform other registration-related tasks with the User object
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }


}
