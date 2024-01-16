import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:mychatapp/contoller/home_provider.dart';
import 'package:mychatapp/pages/custom_page_route.dart';
import 'package:mychatapp/pages/home_page.dart';
import 'package:mychatapp/pages/login_page.dart';
import 'package:mychatapp/pages/profile_page.dart';
import 'package:mychatapp/shared/constants.dart';

///  Text Form Field ///
const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)));

/// --------------------------------------------------------------------------------- ///

/// Navigation Screen ///

nextScreenNavigation(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

/// ----------------------------------------------------------------------------------- ///

/// Snack BAr ///
showSnackBar(context, color, massage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      massage,
      style: const TextStyle(color: Colors.black),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "Ok",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

/// ---------------------------------------------------------------------------------///

/// App Bar ///

appbarDesign(context, TextEditingController searchController,HomeProvider homeProvider) {
  return Container(
    height: 18.h,
    child: Stack(
      children: [
        Container(
          color: Constants.blueColor,
          width: MediaQuery.of(context).size.width,
          height: 13.h,
          child: Center(
            child: Text(
              "Groups",
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ),
        ),
        Positioned(
          top: 9.h,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5), width: 1.0),
                  color: Colors.white),
              child: Row(
                children: [
                  Builder(
                    builder: (BuildContext builderContext) {
                      return FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        onPressed: () {
                          Scaffold.of(builderContext).openDrawer();
                        },
                        child: Icon(
                          Icons.menu,
                          color: Constants.lightBlueColor,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Constants.lightBlueColor,
                    ),
                    onPressed: () {
                      homeProvider.initiateSearchMethod();
                      print("your search bar here");
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Constants.lightBlueColor,
                    ),
                    onPressed: () {
                      print("your notifications action here");
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}

/// ---------------------------------------------------------------------------------///

/// Drawer ///

sharedDrawer(context, HomeProvider homeProvider) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: [
        Icon(
          Icons.account_circle,
          color: Colors.grey[700],
          size: 20.h,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          homeProvider.userName,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.h,
        ),
        const Divider(
          height: 2,
        ),
        ListTile(
          onTap: () {
            homeProvider.isSelectedProfileTab = false;
            homeProvider.isSelectedGroupsTab = true;
            nextScreenNavigation(context, const HomePage());
          },
          selectedColor: homeProvider.isSelectedGroupsTab == true
              ? Constants.blueColor
              : Colors.black,
          selected: homeProvider.isSelectedGroupsTab == true ? true : false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.group),
          title: const Text(
            'Groups',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {
            homeProvider.isSelectedGroupsTab = false;
            homeProvider.isSelectedProfileTab = true;
            nextScreenNavigation(context, ProfilePage());
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          selectedColor: homeProvider.isSelectedProfileTab == true
              ? Constants.blueColor
              : Colors.black,
          selected: homeProvider.isSelectedProfileTab == true ? true : false,
          leading: const Icon(Icons.account_circle),
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return
                    AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
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
                            await homeProvider.signout();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.exit_to_app),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

/// ----------------------------------------------------------------------------- ///

/// No Group Widget

noGroupWidget(context, isLoading, HomeProvider homeProvider) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            popUpDialog(context, isLoading, homeProvider);
          },
          child: Icon(
            Icons.add_circle,
            color: Colors.grey[700],
            size: 70,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Center(
          child: Text(
            "You've not joined any groups, tap tap on the add icon to create a group os also search from top search button",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
          ),
        ),
      ],
    ),
  );
}

/// ----------------------------------------------------------------------------------------------------------------------------------///

/// Pop Up Dialog
popUpDialog(context, isLoading, HomeProvider homeProvider) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Create Group ",
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Constants.lightBlueColor,
                      ),
                    )
                  : TextField(
                      controller: homeProvider.groupNameController,
                      onChanged: (value) {
                        homeProvider.groupNameValue(value);
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.lightBlueColor,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.lightBlueColor,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 4.h,
                )),
            ElevatedButton(
              onPressed: () async {
                homeProvider.createGroup(context);
              },
              child: Text('Create'),
              style: ElevatedButton.styleFrom(
                primary: Constants.lightBlueColor,
              ),
            ),
          ],
        );
      });
}
