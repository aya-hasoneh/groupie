import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:mychatapp/contoller/home_provider.dart';
import 'package:mychatapp/contoller/login_provider.dart';
import 'package:mychatapp/helper/helper_function.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/pages/register_page.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    print('login page');
    return Scaffold(
        body: loginProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: loginProvider.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Groupie',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'login now to see what they are taking!',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                        Lottie.network(
                            'https://lottie.host/e0aa92c2-17d2-4427-99a9-12195f7b0e90/CDDCRIHzPU.json',height: 50.h),
                        Padding(
                          padding: EdgeInsets.all(1.h),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Email',
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    )),
                                onChanged: (value) {
                                  loginProvider.email.text = value;
                                  print(
                                      'this is the email ${loginProvider.email}');
                                },
                                validator: (value) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!)
                                      ? null
                                      : 'Please Enter the correct email ';
                                },
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.password,
                                      color: Colors.black,
                                    )),
                                onChanged: (value) {
                                  loginProvider.password.text = value;
                                  print(
                                      'this is the password ${loginProvider.password}');
                                },
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return 'The password must be at least 6 characters';
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Constants.lightBlueColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      loginProvider.login(context);
                                    }),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text.rich(TextSpan(
                                  text: 'Dont have an account? ',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: 'Register Here',
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print('Register Here');
                                            nextScreenNavigation(
                                                context, const RegisterPage());
                                          })
                                  ])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }

}
