import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:mychatapp/contoller/register_provider.dart';
import 'package:mychatapp/pages/login_page.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    print('register page');
    return Scaffold(
        body: registerProvider.isLoading
            ?const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key:registerProvider. formKey,
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
                          'create your account now to chat and explore',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                        Lottie.network(
                            'https://lottie.host/fc6bf3ca-3a9f-4a18-b106-979e8b632c05/i7wr3B9brW.json',height: 30.h),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.h),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: registerProvider.fullName,
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Full Name',
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    )),
                                onChanged: (value) {
                                  registerProvider.fullName.text = value;
                                  print(
                                      'this is the full name ${registerProvider.fullName}');
                                },
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Name can not be empty';
                                  }
                                },
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              TextFormField(
                                controller: registerProvider.email,
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Email',
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    )),
                                onChanged: (value) {
                                  registerProvider.email.text = value;
                                  print(
                                      'this is the email ${registerProvider.email}');
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
                                controller: registerProvider.password,
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.password,
                                      color: Colors.black,
                                    )),
                                onChanged: (value) {
                                  registerProvider.password.text = value;
                                  print(
                                      'this is the password ${registerProvider.password}');
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
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      //  registerProvider.   registerUser(registerProvider.email.text, registerProvider.password.text);

                                      registerProvider.register(context);
                                    }),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text.rich(TextSpan(
                                  text: 'Already have an account ',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: 'Login Here',
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreenNavigation(
                                                context, const LoginPage());
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
