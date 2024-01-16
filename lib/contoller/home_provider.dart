import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/helper/helper_function.dart';
import 'package:mychatapp/main.dart';
import 'package:mychatapp/pages/chat_page.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/groupTile.dart';
import 'package:mychatapp/widgets/widget.dart';

class HomeProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  String userName = '';
  String email = '';
  bool isSelectedGroupsTab = false;
  bool isSelectedProfileTab = false;
  Stream? groups;
  bool isLoading = false;
  bool searchIsLoading = false;
  QuerySnapshot? searchSnapShot;
  bool hasUserSearch = false;
  User? user;
  bool isJoined = false;

  /// Getting User Data
  gettingUserData() async {
    await HelperFunction.getUserNameFromSF().then((value) => userName = value!);
    await HelperFunction.getUserEmailFromSF().then((value) => email = value!);
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      groups = snapshot;
      notifyListeners();
    });
    notifyListeners();
  }

  /// String mainpulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  /// Group List
  groupList(context, HomeProvider homeProvider) {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return Container(
                    height: 80.h,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: snapshot.data['groups'].length,
                        itemBuilder: (contetx, index) {
                          int reverseIndex =
                              snapshot.data['groups'].length - index - 1;

                          return GroupTile(
                              groupId:
                                  getId(snapshot.data['groups'][reverseIndex]),
                              groupName: getName(
                                  snapshot.data['groups'][reverseIndex]),
                              userName: snapshot.data['fullName']);
                        }));
              } else {
                return noGroupWidget(context, isLoading, homeProvider);
              }
            } else {
              return noGroupWidget(context, isLoading, homeProvider);
            }
          } else {
            return Center(child: Text('No Has Data'));
          }
        });
  }

  groupNameValue(value) {
    groupNameController.text = value;
    notifyListeners();
  }

  /// SignOut
  Future signout() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSf("");
      await HelperFunction.saveUserNameSf("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future createGroup(context) async {
    if (groupNameController.text != "") {
      isLoading = true;
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .createGroup(userName, FirebaseAuth.instance.currentUser!.uid,
              groupNameController.text)
          .whenComplete(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(
          context, Constants.blueColor, Text("Group Create Successfully"));
    }
    notifyListeners();
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      notifyListeners();
      isLoading = true;
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchByName(searchController.text)
          .then((snapshot) {
        notifyListeners();
        searchSnapShot = snapshot;
        isLoading = false;
        hasUserSearch = true;
      });
    }
  }

  searchGroupList() {
    return hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapShot!.docs[index]['groupId'],
                searchSnapShot!.docs[index]['groupName'],
                searchSnapShot!.docs[index]['admin'],
                context
              );
            },
            itemCount: searchSnapShot!.docs.length,
          )
        : Container();
  }

  joinedOrNot(String groupName, String groupId, String userName) async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      notifyListeners();
      isJoined = value;
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin,context) {
    // function to check whether user already exists in group
    joinedOrNot(groupName, groupId, userName);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
          radius: 30,
          backgroundColor: Constants.blueColor,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 3.h,
                color: Colors.white),
          )),
      title: Text(
        groupName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            notifyListeners();
            isJoined = !isJoined;
            showSnackBar(context, Colors.green, "Successfully joined in group");
            Future.delayed(Duration(seconds: 2),(){
              nextScreenNavigation(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            });
          }else{
            notifyListeners();
            isJoined =!isJoined;
            showSnackBar(context, Colors.red, "Left The Group $groupName");
            Future.delayed(Duration(seconds: 2));


          }
          
        },
        child: isJoined
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Joined',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Join Now',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.lightBlueColor,
                ),
              ),
      ),
    );
  }
}
