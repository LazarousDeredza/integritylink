import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/admin/club_view.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/service/database_service.dart';
import 'package:integritylink/src/features/core/screens/profile/settings_screen.dart';

class ClubListScreenForApprove extends StatefulWidget {
  const ClubListScreenForApprove({Key? key}) : super(key: key);

  @override
  State<ClubListScreenForApprove> createState() =>
      _ClubListScreenForApproveState();
}

class _ClubListScreenForApproveState extends State<ClubListScreenForApprove> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  String id = "";
  String docId = "";
  late String? userId;

  @override
  void initState() {
    super.initState();
    //initiate the user id from firebase
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search here...',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            //clear icon
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              id = value;
            });
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(
            () => SettingsScreen(),
          );
          return true;
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('groupstoBeApproved')
              .where('approvalStatus', isEqualTo: "pending")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final filteredCases = snapshot.data!.docs.where((x) {
                final caseId = x['groupId'].toLowerCase() +
                    x['groupName'].toLowerCase() +
                    x['groupId'].toLowerCase() +
                    x['groupPurpose'].toLowerCase() +
                    x['createdBy'].toLowerCase() +
                    x['targetAudience'].toLowerCase();

                final searchQuery = _searchController.text.toLowerCase();
                return caseId.contains(searchQuery);
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCases.length,
                      itemBuilder: (context, i) {
                        QueryDocumentSnapshot x = filteredCases[i];

                        return InkWell(
                          onTap: () {
                            print("Document ID = " + x['groupId']);
                            // Go to view case screen
                            Get.offAll(
                                () => ClubViewScreen(docID: x['groupId']));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                title: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    x['groupName'],
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20.0,
                                        ),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            x['groupPurpose'],
                                            textAlign: TextAlign.justify,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                final textSpan = TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child:
                                                          SizedBox(width: 3.0),
                                                    ),
                                                    TextSpan(
                                                      text: x['createdBy'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            letterSpacing: .4,
                                                          ),
                                                    ),
                                                  ],
                                                );

                                                return RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: textSpan,
                                                );
                                              },
                                            ),
                                          ),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              final textSpan = TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.blueAccent,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: SizedBox(width: 3.0),
                                                  ),
                                                  TextSpan(
                                                    text: x['dateCreated']
                                                        .toString()
                                                        .substring(0, 16),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ],
                                              );

                                              return RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                text: textSpan,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      //delete iconbutton
                                      IconButton(
                                          onPressed: () {
                                            //confirm delete
                                            docId = x['groupId'];
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Confirmation",
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    content: Text(
                                                        "Are you sure you want to delete this club creation request?"),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .primaryColor),
                                                        child: Text(
                                                          "CANCEL",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                      ),
                                                      //space
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'groupstoBeApproved')
                                                              .doc(docId)
                                                              .delete()
                                                              .whenComplete(() {
                                                            Get.snackbar(
                                                              "Success",
                                                              "Request Deleted",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .primaryColor),
                                                        child: Text(
                                                          "Yes",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 35.0,
                                          )),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    docId = x['groupId'];
                                    popUpDialog(context);
                                  },
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No Data found"),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Confirmation",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : Text(
                          "Are you sure you want to Approve this club creation ?",
                          textAlign: TextAlign.left,
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    "CANCEL",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                //space
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    await DatabaseServicetest()
                        .approveClub(docId, userId.toString());

                    setState(() {
                      _isLoading = false;
                    });

                    Navigator.of(context).pop();
                    // showSnackbar(
                    //     context, Colors.green, "Club Approved successfully.");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    "Yes",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              ],
            );
          }));
        });
  }
}
