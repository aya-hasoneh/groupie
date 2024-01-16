import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/contoller/chat_provider.dart';
import 'package:mychatapp/pages/group_info_page.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/messageTile.dart';
import 'package:mychatapp/widgets/widget.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  String groupId;
  String groupName;
  String userName;
  ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // Get the provider instance
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      // Call the asynchronous method
      await chatProvider.getChatAndAdmin(groupId: widget.groupId);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.blueColor,
          elevation: 0,
          title: Text(widget.groupName),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  nextScreenNavigation(
                      context,
                      GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: chatProvider.admin,
                      ));
                },
                icon: Icon(Icons.info))
          ],
        ),
        body: Stack(
          children: [
            chatMessages(chatProvider),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.grey[600],
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: chatProvider.messagesController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Send a messages....',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 1.7.h),
                        border: InputBorder.none,
                      ),
                    )),
                    SizedBox(
                      width: 2.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessages(chatProvider);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Constants.lightBlueColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  chatMessages(ChatProvider chatProvider) {
    return StreamBuilder(
        stream: chatProvider.chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sendByMe: widget.userName ==
                            snapshot.data.docs[index]['sender']);
                  })
              : Container();
        });
  }

  sendMessages(ChatProvider chatProvider) {
    if (chatProvider.messagesController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": chatProvider.messagesController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        chatProvider.messagesController.clear();
      });
    }
  }
}
