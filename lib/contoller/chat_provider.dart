import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/widgets/messageTile.dart';

class ChatProvider extends ChangeNotifier {
  String admin = "";
  String userName ="";
  String groupId ="";
  TextEditingController messagesController = TextEditingController();
  Stream<QuerySnapshot>? chats;

  getChatAndAdmin({required String groupId}) {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCharts(groupId)
        .then((val) {
      chats = val;
      notifyListeners();
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getGroupAdmin(groupId)
          .then((value) {
        admin = value;
        notifyListeners();
      });
    });
  }

//   chatMessages() {
//     return StreamBuilder(
//         stream: chats,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   itemCount: snapshot.data.docs.length,
//                   itemBuilder: (context, index) {
//                     return MessageTile(
//                         message: snapshot.data.docs[index]['message'],
//                         sender: snapshot.data.docs[index]['sender'],
//                         sendByMe:
//                             userName == snapshot.data.docs[index]['sender']);
//                   })
//               : Container();
//         });
//   }
//
//   sendMessages() {
//     if(messagesController.text.isNotEmpty){
// Map<String,dynamic> chatMessageMap = {
//   "message": messagesController.text,
//   "sender":userName,
//   "time":DateTime.now().millisecondsSinceEpoch
// };
// DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid ).sendMessage(groupId, chatMessageMap);
// notifyListeners();
// messagesController.clear();
//     }
//   }
}
