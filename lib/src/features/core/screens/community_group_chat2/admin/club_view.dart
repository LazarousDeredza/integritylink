import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/admin/club_list_to_approve.dart';

import 'package:integritylink/src/features/core/screens/community_group_chat2/service/database_service.dart';

class ClubViewScreen extends StatefulWidget {
  final String docID;

  //user id from firebase currently logged in user

  const ClubViewScreen({required this.docID});

  @override
  _ClubViewScreenState createState() => _ClubViewScreenState();
}

class _ClubViewScreenState extends State<ClubViewScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _caseFuture;
  bool _isLoading = false;
  late String? userId;

  @override
  void initState() {
    super.initState();
    _caseFuture = FirebaseFirestore.instance
        .collection('groupstoBeApproved')
        .doc(widget.docID)
        .get();

    //initiate the user id from firebase
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  final _commentController = TextEditingController();
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Club'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _caseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final clubData = snapshot.data!.data();

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the case properties
                  SizedBox(height: 16.0),
                  Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.black,
                              ),
                          children: [
                            TextSpan(
                              text: 'Club Name    :   ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${clubData!['groupName']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineSmall,
                        children: [
                          TextSpan(
                            text: 'Created By    :   ',
                          ),
                          TextSpan(
                              text: '${clubData['createdBy']}',
                              style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Center(
                      child: Text(
                        'Club Details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineSmall,
                        children: [
                          TextSpan(
                            text: 'Created At   :   ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '${clubData['dateCreated'].toString().substring(0, 16)}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Center(
                      child: Text(
                        'Group Purpose',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      '${clubData['groupPurpose']}',
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Center(
                      child: Text(
                        'Target Audience',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      '${clubData['targetAudience']}',
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print("id = " + widget.docID);
                          popUpDialog(context);
                        },
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                        child: Center(
                          widthFactor: 3,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Text(
                              "Approve",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //delete button
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print("id = " + widget.docID);
                          //confirm delete

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
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      child: Text(
                                        "CANCEL",
                                        style: Theme.of(context)
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
                                        FirebaseFirestore.instance
                                            .collection('groupstoBeApproved')
                                            .doc(widget.docID)
                                            .delete()
                                            .whenComplete(() {
                                          Get.snackbar(
                                            "Success",
                                            "Request Deleted",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                          Navigator.of(context).pop();
                                          //get to club list screen
                                          Get.to(
                                            () => ClubListScreenForApprove(),
                                          );
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      child: Text(
                                        "Yes",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                        child: Center(
                          widthFactor: 3,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Text(
                              "Delete",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
                        .approveClub(widget.docID, userId.toString());
                    Get.snackbar("Sucess", "Club Approved successfully",
                        snackPosition: SnackPosition.BOTTOM);
                    //delay 3 seconds
                    await Future.delayed(Duration(seconds: 2));
                    Get.offAll(
                      () => ClubListScreenForApprove(),
                    );
                    // Navigator.of(context).pop();
                    // setState(() {
                    //   _isLoading = false;
                    // });

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
