import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? uid;
  DatabaseService({required this.uid});

  /// ref for our collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  /// saving the user data

  Future savingUserData(String fullName, String email) async {
    await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  /// getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  /// get user group
  getUserGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  Future gettingUserDataUser(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  /// creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    /// update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  /// getting the chat
  getCharts(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
  Future getGroupAdmin(String groupId)async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }
  /// getting group members
getGroupMembers(groupId)async{
return groupCollection.doc(groupId).snapshots();
}

/// search
  searchByName(String groupName){
    return groupCollection.where("groupName",isEqualTo: groupName).get();
  }

  /// function -> bool

Future<bool> isUserJoined (String groupName ,String groupId,String userName)async{
    DocumentReference userDocumentRefrences =userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentRefrences.get();
    List<dynamic>groups =await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;


    }else{
      return false;
    }
}

/// toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }
// Future toggleGroupJoin (String groupId, String userName, String groupName)async{
//     // doc reference
//   DocumentReference userDocumentReference = userCollection .doc(uid);
//   DocumentReference groupDocumentReference=groupCollection.doc(uid);
//   DocumentSnapshot documentSnapshot =await userDocumentReference .get();
//   List<dynamic>groups =await documentSnapshot['groups'];
//
//   // if user has our group --> then remove then or also in other part re join
//   if(groups.contains("${groupId}_$groupName")){
//     await userDocumentReference.update({
//       "groups":FieldValue.arrayRemove(["${groupId}_$groupName"])
//     });
//
//     await groupDocumentReference.update({
//       "members":FieldValue.arrayRemove(["${uid}_$userName"])
//     });
//   }else{
//     await userDocumentReference.update({
//       "groups":FieldValue.arrayUnion(["${groupId}_$groupName"])
//     });
//
//     await groupDocumentReference.update({
//       "members":FieldValue.arrayUnion(["${uid}_$userName"])
//     });
//   }
// }
/// send message
  sendMessage(String groupId,Map<String,dynamic>chatMessageData)async{
    groupCollection.doc(groupId).collection("messages").add( chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage":chatMessageData['message'],
      "recentMessageSender":chatMessageData['sender'],
      "recentMessageTimer":chatMessageData['time'].toString(),
    });

  }

}