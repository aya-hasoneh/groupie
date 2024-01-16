import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/services/database_services.dart';
import 'package:mychatapp/shared/constants.dart';

class GroupInfoProvider extends ChangeNotifier {
  Stream? members;
  getMembers(groupId) {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(groupId)
        .then((value) {
      members = value;
      notifyListeners();
    });
  }

  String getName(String name) {
    return name.substring(name.indexOf("_") + 1);
  }
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }
  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
                return Container(
                  height: 70.h,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data["members"].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Constants.blueColor,
                              child: Text(
                                getName(snapshot.data['members'][index])
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 2.5.h,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title:
                                Text(getName(snapshot.data['members'][index])),
                            subtitle: Text(getId(snapshot.data['members'][index]),style: TextStyle(fontSize: 1.3.h),),
                          ),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text("No Members"),
                );
              }
            } else {
              return const Center(
                child: Text("No Members"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
