import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/contoller/group_info_provider.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';
import 'package:provider/provider.dart';

class GroupInfo extends StatefulWidget {
  String groupId;
  String groupName;
  String adminName;
  GroupInfo(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // Get the provider instance
      final groupInfoProvider =
          Provider.of<GroupInfoProvider>(context, listen: false);
      // Call the asynchronous method
      await groupInfoProvider.getMembers(widget.groupId);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupInfoProvider = Provider.of<GroupInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.blueColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Exit'),
                        content: const Text('Are you sure exit the group?'),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 4.h,
                              )),
                          IconButton(
                              onPressed: () async {
                                DatabaseService(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroupJoin(
                                        widget.groupId,
                                        groupInfoProvider
                                            .getName(widget.adminName),
                                        widget.groupName)
                                    .whenComplete(() => nextScreenNavigation(
                                        context, const HomePage()));
                                // await homeProvider.signout();
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => const LoginPage()),
                                //         (route) => false);
                              },
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 4.h,
                              ))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              height: 12.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Constants.lightBlueColor.withOpacity(0.2)),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.blueColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 2.5.h),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(fontSize: 1.5.h),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "Admin: ${groupInfoProvider.getName(widget.adminName)}",
                        style: TextStyle(fontSize: 1.5.h),
                      ),
                    ],
                  )
                ],
              ),
            ),
            groupInfoProvider.memberList(),
          ],
        ),
      ),
    );
  }
}
