import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/pages/chat_page.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupName;
  final String groupId;
  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: (){
          nextScreenNavigation(context, ChatPage(groupId: groupId,groupName: groupName,userName: userName,));
        },
        child: ListTile(

          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Constants.blueColor,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(groupName),
          subtitle: Text("Join the conversation as ${userName}",style: TextStyle(fontSize: 1.5.h),),
        ),
      ),
    );
  }
}
