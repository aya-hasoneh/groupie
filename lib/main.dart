import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/contoller/group_info_provider.dart';
import 'package:mychatapp/contoller/chat_provider.dart';
import 'package:mychatapp/contoller/home_provider.dart';
import 'package:mychatapp/contoller/login_provider.dart';
import 'package:mychatapp/contoller/profile_provider.dart';
import 'package:mychatapp/contoller/register_provider.dart';
import 'package:mychatapp/helper/helper_function.dart';
import 'package:mychatapp/pages/login_page.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/pages/profile_page.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:provider/provider.dart';

final FirebaseAuth  firebaseAuth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    //run the initialization on web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    //run the initialization on android
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_)=> HomeProvider()),
        ChangeNotifierProvider(create: (_)=> ProfileProvider()),
        ChangeNotifierProvider(create: (_)=> ChatProvider()),
        ChangeNotifierProvider(create: (_)=> GroupInfoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isSignedIn = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? HomePage() : LoginPage(),
      );
    });
  }
}
