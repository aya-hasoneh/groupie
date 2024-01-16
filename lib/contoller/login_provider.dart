import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/helper/helper_function.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
 final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  /// Login Firebase
  login(context) async {
    if (formKey.currentState!.validate()) {
      notifyListeners();

      isLoading = true;
          loginWithUserNameandPassword(email.text, password.text)
          .then((value) async {
        if (value == true) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email.text)
              .get();

          String fullName =  querySnapshot.docs[0]['fullName'];

          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSf(email.text);
          await HelperFunction.saveUserNameSf(fullName);
          print('go to home page');
          nextScreenNavigation(context, const HomePage());


        } else {
notifyListeners();
         showSnackBar(context, Colors.red, value);
            isLoading = false;
        }
      });
    }
  }
  //  login(context) async {
  //   if (formKey.currentState!.validate()) {
  //     isLoading = true;
  //   }
  //   await loginWithUserNameandPassword(email.text,password.text).then((value) async {
  //     if (value == true) {
  //       //save the Shared Preferences State
  //       await HelperFunction.saveUserLoggedInStatus(true);
  //       await HelperFunction.saveUserEmailSf(email.text);
  //       print('this is email ${email.text}');
  //       DocumentSnapshot userSnapshot =
  //       await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email.text);
  //
  //
  //       nextScreenNavigation(context, HomePage());
  //     } else {
  //       showSnackBar(context, Constants.blueColor, value);
  //       isLoading = false;
  //     }
  //   });
  //     notifyListeners();
  // }
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
//   Future loginWithEmailAndPassword(context) async {
//     try {
//       await firebaseAuth.signInWithEmailAndPassword(email: email.text, password: password.text);
//       // final userCredential =
//       //     await FirebaseAuth.instance.signInWithEmailAndPassword(
//       //   email: email.text.trim(),
//       //   password: password.text.trim(),
//       // );
// return true;
// }on FirebaseAuthException catch(e){
//   return e.message;
//     }
//       // Get the User object from UserCredential
//     //   final user = userCredential.user;
//     //   if (user != null) {
//     //     return true;
//     //   }
//     //   // Perform other registration-related tasks with the User object
//     // } on FirebaseAuthException catch (e) {
//     //   print(e);
//     //   return e.message;
//     // }
//   }

  /// Logout Firebase
}
