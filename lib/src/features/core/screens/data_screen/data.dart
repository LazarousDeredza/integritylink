import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/data_screen/data_list.dart';
import 'package:integritylink/src/features/core/screens/group_chat/helper/helper_function.dart';
import 'package:integritylink/src/repository/authentication_repository/authentication_repository.dart';


class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await CommunityGroupHelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
        print('Email' + email);
      });
    });
    await CommunityGroupHelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
        print('Username' + userName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Data Access'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 56),
          child: Drawer(
              width: 230,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);

                      Get.to(() => DataListScreen(
                            reportType: "Government Budgets",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.attach_money,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Government Budgets",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      Get.to(() => DataListScreen(
                            reportType: "Expenditure Reports",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.book,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Expenditure Reports",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      Get.to(() => DataListScreen(
                            reportType: "Revenue Reports",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.library_books,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Revenue Reports",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      Get.to(() => DataListScreen(
                            reportType: "Procurement Reports",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Procurement Reports",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      // Get.to(() => InstututionalHomeGroupScreen());
                      Get.to(() => DataListScreen(
                            reportType: "Debt Reports",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.deblur,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Debt Reports",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      Get.to(() => DataListScreen(
                            reportType: "Financial Statements",
                          ));

                      // Get.to(() => InstututionalHomeGroupScreen());
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.monetization_on,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Financial Statements",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      // Get.to(() => InstututionalHomeGroupScreen());
                      Get.to(() => DataListScreen(
                            reportType: "Audit Reports",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.ad_units,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Audit Reports",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      // Get.to(() => InstututionalHomeGroupScreen());
                      Get.to(() => DataListScreen(
                            reportType: "Public Debt Reports",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.photo_album,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Public Debt Reports",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //close drawer
                      Navigator.pop(context);
                      // Get.to(() => InstututionalHomeGroupScreen());
                      Get.to(() => DataListScreen(
                            reportType: "Government Transparency",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      Icons.public,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      "Government Transparency",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    onTap: () {
                      // nextScreenReplace(
                      //   context,
                      //   ProfilePage(
                      //     userName: userName,
                      //     email: email,
                      //   ),
                      // );
                      //close drawer
                      Navigator.pop(context);
                      // Get.to(() => UpdateProfileScreen());
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.person),
                    title: Text(
                      "Profile",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      _showConfirmationBottomSheet(context);
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.exit_to_app),
                    title: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              )),
        ),
      ),
      body: Center(
        child: Text('Data'),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //  Perform logout action
                        // Navigator.pop(context);
                        // Close the bottom sheet

                        //logout
                        AuthenticationRepository.instance.logout();
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
