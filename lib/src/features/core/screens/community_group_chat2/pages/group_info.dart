import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/constants/colors.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/pages/chat_page.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/pages/group_delete_confirmation.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/api/apis.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class GroupInfotest extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String username;
  const GroupInfotest(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.username,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupInfotest> createState() => _GroupInfotestState();
}

class _GroupInfotestState extends State<GroupInfotest> {
  Stream? members;

  String? _image;

  late String groupPurpose = '';
  late String newgroupName = '';
  late String groupIcon = '';
  late String groupAdminID = '';
  late String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String myMemberString = "";

  late bool isAdmin = false;

  TextEditingController groupPurposeController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    myMemberString = currentUserId + "_" + widget.username;
    getMembers();
    fetchGroupDetails();
    super.initState();
  }

  Future<void> fetchGroupDetails() async {
    print("Group Id : " + widget.groupId);
    // Assuming you have the group ID stored in widget.groupId
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .get();

    print("Club exists : " + snapshot.exists.toString());

    if (snapshot.exists) {
      final groupData = snapshot.data();
      setState(() {
        groupPurpose = groupData![
            'groupPurpose']; // Replace 'subtitle' with the actual field name in your Firebase document
        groupIcon = groupData['groupIcon'];
        groupAdminID = groupData['admin'].toString().split("_")[0];
        print("Admin ID " +
            groupAdminID +
            " and current user id " +
            currentUserId);

        if (groupAdminID == currentUserId) {
          isAdmin = true;
        }

        print("Is admin " + isAdmin.toString());
      });
    }
  }

  getMembers() async {
    DatabaseServicetest(uid: currentUserId)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getEmail(String res) {
    return res.substring(res.lastIndexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.off(
          () => ChatPagetest(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.username,
          ),
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Club Info"),
          actions: [
            isAdmin
                ? IconButton(
                    onPressed: () {
                      //confirm delete group
                      Get.offAll(
                        () => GroupDeleteConfirmationPage(
                          groupId: widget.groupId,
                          groupName: widget.groupName,
                          adminName: widget.adminName,
                          username: widget.username,
                        ),
                        // CommunityGroupHomePage(),
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
                : Container(width: 0),
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Exit"),
                          content:
                              const Text("Are you sure you exit the club? "),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                DatabaseServicetest(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroupExit(
                                        widget.groupId,
                                        getName(widget.adminName),
                                        widget.groupName)
                                    .whenComplete(() {
                                  Get.snackbar("Club left sucessful", "",
                                      snackPosition: SnackPosition.BOTTOM);
                                  Get.offAll(
                                    () => CommunityGroupHomePagetest(),
                                  );
                                }).onError((error, stackTrace) => () {
                                          Get.snackbar("Error",
                                              "Something went wrong !!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        });
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 7.0,
            ),
            Stack(
              children: [
                groupIcon.length <= 1 || groupIcon.trim() == ""
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(tProfileImage),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ProfileImagePopup(
                              imageUrl: groupIcon,
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: CachedNetworkImageProvider(
                            groupIcon,
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet();
                      },
                      child: Icon(
                        LineAwesomeIcons.camera,
                        color: tDarkColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.groupName}",
                    textAlign: TextAlign.center,
                    maxLines: null,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  //icon edit club name
                  if (isAdmin)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Update Club Name"),
                                content: TextField(
                                  maxLines: 1,
                                  maxLength: 35,
                                  controller: groupNameController,
                                  onChanged: (value) {
                                    setState(() {
                                      newgroupName = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter Club Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (groupNameController.text
                                            .trim()
                                            .isEmpty) {
                                          Get.snackbar("Error",
                                              "Club Name cannot be empty",
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        } else {
                                          Navigator.pop(context);
                                          await APIs.updateGroupName(
                                              newgroupName,
                                              widget.groupId,
                                              widget.groupName);

                                          groupNameController.clear();
                                          Get.off(
                                            () => GroupInfotest(
                                              groupId: widget.groupId,
                                              groupName: newgroupName,
                                              adminName: widget.adminName,
                                              username: widget.username,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Update")),
                                ],
                              );
                            });
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("Created By   : ${getName(widget.adminName)}"),
            const SizedBox(
              height: 10,
            ),
            //group purpose
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Club Purpose",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      //pen icon for editing
                      if (isAdmin)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Update Club Purpose"),
                                    content: TextField(
                                      maxLines: 3,
                                      maxLength: 200,
                                      controller: groupPurposeController,
                                      onChanged: (value) {
                                        setState(() {
                                          groupPurpose = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Club Purpose",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (groupPurposeController.text
                                                .trim()
                                                .isEmpty) {
                                              Get.snackbar("Error",
                                                  "Club Purpose cannot be empty",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);
                                            } else {
                                              await APIs.updateGroupPurpose(
                                                  groupPurpose, widget.groupId);
                                              Navigator.pop(context);
                                              groupPurposeController.clear();
                                              Get.off(
                                                () => GroupInfotest(
                                                  groupId: widget.groupId,
                                                  groupName: widget.groupName,
                                                  adminName: widget.adminName,
                                                  username: widget.username,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text("Update")),
                                    ],
                                  );
                                });
                          },
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    groupPurpose,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            //update button
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
            ),
            Center(
              child: const Text(
                "Members",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Group deleted');
        }
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              getName(snapshot.data['members'][index])
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(getName(snapshot.data['members'][index])),
                          subtitle:
                              Text(getId(snapshot.data['members'][index])),
                          trailing: isAdmin
                              ? GestureDetector(
                                  onTap: () {
                                    print("1" +
                                        snapshot.data['members'][index]
                                            .toString());
                                    print("2" + myMemberString);
                                    if (snapshot.data['members'][index] !=
                                        myMemberString) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Remove Member"),
                                            content: const Text(
                                                "Are you sure you want to remove this member?"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel")),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    await APIs.removeMember(
                                                        widget.groupId,
                                                        snapshot.data['members']
                                                            [index],
                                                        widget.groupName);
                                                    Navigator.pop(context);
                                                    Get.off(
                                                      () => GroupInfotest(
                                                        groupId: widget.groupId,
                                                        groupName:
                                                            widget.groupName,
                                                        adminName:
                                                            widget.adminName,
                                                        username:
                                                            widget.username,
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("Remove")),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }

// bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Group Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Navigator.pop(context);

                          await APIs.updateGroupProfilePicture(
                              File(_image!), "${widget.groupId}");
                          // for hiding bottom sheet

                          Get.off(
                            () => GroupInfotest(
                              groupId: widget.groupId,
                              groupName: widget.groupName,
                              adminName: widget.adminName,
                              username: widget.username,
                            ),
                          );
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Navigator.pop(context);
                          await APIs.updateGroupProfilePicture(
                              File(_image!), "${widget.groupId}");

                          Get.off(
                            () => GroupInfotest(
                              groupId: widget.groupId,
                              groupName: widget.groupName,
                              adminName: widget.adminName,
                              username: widget.username,
                            ),
                          );
                          // for hiding bottom sheet
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}

class ProfileImagePopup extends StatelessWidget {
  final String imageUrl;

  const ProfileImagePopup({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: CachedNetworkImage(
      imageUrl: imageUrl,
    ));
  }
}
