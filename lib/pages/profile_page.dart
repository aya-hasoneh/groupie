import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/contoller/home_provider.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/pages/login_page.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.blueColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      drawer: sharedDrawer(context, homeProvider),
      body: Container(
        padding: EdgeInsets.only(top: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 25.h,
              color: Colors.grey[700],
            ),
            SizedBox(height: 3.h,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Full Name :'),

              Text('${homeProvider.userName}'),
              
            ],),
            Divider(height:2.h),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Email :'),
                Text('${homeProvider.email}')
              
            ],)
          ],
        ),
      ),
    );
  }
}
