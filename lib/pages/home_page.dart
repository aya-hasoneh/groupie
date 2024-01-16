import 'package:flutter/material.dart';
import 'package:mychatapp/contoller/home_provider.dart';
import 'package:mychatapp/shared/constants.dart';
import 'package:mychatapp/widgets/widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      // Get the provider instance
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      // Call the asynchronous method
      await homeProvider.gettingUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            appbarDesign(context, homeProvider.searchController, homeProvider),
            homeProvider.searchSnapShot != null && homeProvider.searchSnapShot!.docs.isNotEmpty
                ? homeProvider.searchGroupList()
                : homeProvider.groupList(context, homeProvider),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Constants.lightBlueColor,
        elevation: 0,
        onPressed: () {
          popUpDialog(context, homeProvider.isLoading, homeProvider);
        },
      ),
      drawer: sharedDrawer(context, homeProvider),
    );
  }
}
