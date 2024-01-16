import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/shared/constants.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sendByMe;
  MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: sendByMe?0:24,right: sendByMe?24:0,top: 4,bottom: 4),
      child: Container(
         margin: sendByMe?const EdgeInsets.only(left: 30):const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: sendByMe ? Constants.lightBlueColor : Colors.grey[300],
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topRight: Radius.circular(35),
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30))
              :const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(35),
                  bottomRight: Radius.circular(30)),
        ),
        child: Container(
        //  margin: sendByMe?const EdgeInsets.only(left: 30):const EdgeInsets.only(right: 30),
margin: EdgeInsets.only(left: 30,right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(
                height: 2.h,
              ),
              Text(
                sender.toUpperCase(),
                textAlign: TextAlign.center,
                style:const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style:const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
