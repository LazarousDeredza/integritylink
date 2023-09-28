import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/constants/colors.dart';
import 'package:integritylink/src/features/core/screens/cases/cases_list.dart';
import 'package:integritylink/src/features/core/screens/cases/report_case.dart';
import 'package:integritylink/src/features/core/screens/data_screen/data_list.dart';
import 'package:integritylink/src/features/core/screens/education_screens/education_dashboard.dart';
import 'package:integritylink/src/features/core/screens/files/file_list.dart';
import 'package:integritylink/src/features/core/screens/group_chat/helper/helper_function.dart';
import 'package:integritylink/src/features/core/screens/group_chat/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/screens/chat_home_screen.dart';
import 'package:integritylink/src/features/core/screens/profile/settings_screen.dart';
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
    Size size = MediaQuery.of(context).size;

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
                            dataType: "Government Budgets",
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(
                      //198291
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
                            dataType: "Expenditure Reports",
                          ));

                      // Get.to(() => FileList());
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
                            dataType: "Revenue Reports",
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
                            dataType: "Procurement Reports",
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
                            dataType: "Debt Reports",
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
                            dataType: "Financial Statements",
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
                            dataType: "Audit Reports",
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
                            dataType: "Public Debt Reports",
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
                            dataType: "Government Transparency",
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
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: size.height * .35,
                width: size.width,
              ),
              GradientContainer(size),
              Positioned(
                top: size.height * .04,
                width: size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Goverment Documents",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          textAlign: TextAlign.justify,
                          "This is a collection of goverment documents\n that are available for public access.",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [DevicesGridDashboard(size: size)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container GradientContainer(Size size) {
    return Container(
      height: size.height * .3,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            gradient: LinearGradient(colors: [
              tPrimaryColor.withOpacity(0.6),
              primaryColor.withOpacity(0.9)
            ])),
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

class CardWidget extends StatelessWidget {
  final Icon icon;
  final String title;

  CardWidget({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.7),
      child: SizedBox(
        height: 50,
        width: 150,
        child: Center(
          child: ListTile(
            leading: icon,
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class DevicesGridDashboard extends StatelessWidget {
  const DevicesGridDashboard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                "Select a category",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                size,
                Colors.blue,
                Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
                'Government',
                'Budgets',
                () {
                  Get.to(() => DataListScreen(
                        dataType: "Government Budgets",
                      ));
                },
              ),
              CardField(
                size,
                Colors.amber,
                Icon(
                  Icons.book,
                  color: Colors.white,
                ),
                'Expenditure',
                'Reports',
                () {
                  Get.to(() => DataListScreen(
                        dataType: "Expenditure Reports",
                      ));
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                size,
                Colors.orange,
                Icon(
                  Icons.library_books,
                  color: Colors.white,
                ),
                'Revenue',
                'Reports',
                () {
                  Get.to(() => DataListScreen(
                        dataType: "Revenue Reports",
                      ));
                },
              ),
              CardField(
                size,
                Colors.teal,
                Icon(
                  Icons.note,
                  color: Colors.white,
                ),
                'Procurement',
                'Reports',
                () {
                  Get.to(() => DataListScreen(
                        dataType: "Procurement Reports",
                      ));
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                  size,
                  Colors.purple,
                  Icon(
                    Icons.deblur,
                    color: Colors.white,
                  ),
                  'Debt',
                  'Reports', () {
                Get.to(() => DataListScreen(
                      dataType: "Debt Reports",
                    ));
              }),
              CardField(
                  size,
                  Colors.green,
                  Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  'Financial',
                  'Statements', () {
                Get.to(() => DataListScreen(
                      dataType: "Financial Statements",
                    ));
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                  size,
                  Colors.purple,
                  Icon(
                    Icons.ad_units,
                    color: Colors.white,
                  ),
                  'Audit',
                  'Reports', () {
                Get.to(() => DataListScreen(
                      dataType: "Audit Reports",
                    ));
              }),
              CardField(
                  size,
                  Colors.green,
                  Icon(
                    Icons.photo_album,
                    color: Colors.white,
                  ),
                  'Public Debt',
                  'Reports', () {
                Get.to(() => DataListScreen(
                      dataType: "Public Debt Reports",
                    ));
              }),
            ],
          )
        ],
      ),
    );
  }
}

CardField(
  Size size,
  Color color,
  Icon icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Card(
      color: Colors.white.withOpacity(0.7),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: size.height * .15,
          width: size.width * .39,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(backgroundColor: color, child: icon),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
