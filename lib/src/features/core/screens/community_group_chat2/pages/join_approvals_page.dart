import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/pages/chat_page.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/service/database_service.dart';

class CommunityClubJoinApprovalScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String username;
  const CommunityClubJoinApprovalScreen(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.username,
      required this.groupId})
      : super(key: key);

  @override
  State<CommunityClubJoinApprovalScreen> createState() =>
      _CommunityClubJoinApprovalScreenState();
}

class _CommunityClubJoinApprovalScreenState
    extends State<CommunityClubJoinApprovalScreen> {
  Stream? members;
  late String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    getMembers();
    super.initState();
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
    return r.split("_")[1];
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getIntroduction(String res) {
    return res.split("_")[2];
  }

  String getReason(String res) {
    return res.split("_")[3];
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
          title: Text('Join Requests'),
        ),
        body: Column(
          children: [
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
        if (snapshot.hasData) {
          if (snapshot.data['unapprovedmembers'] != null) {
            if (snapshot.data['unapprovedmembers'].length != 0) {
              return Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data['unapprovedmembers'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                          ),
                          title: Text(getName(
                              snapshot.data['unapprovedmembers'][index])),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Divider(),
                              Center(
                                child: Text(
                                  "Introduction",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                getIntroduction(
                                    snapshot.data['unapprovedmembers'][index]),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Divider(),
                              Center(
                                child: Text(
                                  "Reason",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                getReason(
                                    snapshot.data['unapprovedmembers'][index]),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  print("Data : " +
                                      snapshot.data['unapprovedmembers']
                                          [index]);

                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: Text("Confirm Approval"),
                                              content: Text(
                                                  "Are you sure you want to approve this member?"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                ),
                                                TextButton(
                                                    child: Text("Confirm"),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                      DatabaseServicetest(
                                                              uid:
                                                                  currentUserId)
                                                          .addGroupMemberFromUnApprovedList(
                                                              widget.groupId,
                                                              snapshot.data[
                                                                      'unapprovedmembers']
                                                                  [index],
                                                              widget.groupName);
                                                    })
                                              ]));
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    print("Data : " +
                                        snapshot.data['unapprovedmembers']
                                            [index]);

                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                                title: Text("Confirm Delete"),
                                                content: Text(
                                                    "Are you sure you want to remove this member?"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                  ),
                                                  TextButton(
                                                      child: Text("Confirm"),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                        DatabaseServicetest(
                                                                uid:
                                                                    currentUserId)
                                                            .removeUnApprovedMember(
                                                                widget.groupId,
                                                                snapshot.data[
                                                                        'unapprovedmembers']
                                                                    [index],
                                                                widget
                                                                    .groupName);
                                                      })
                                                ]));
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red))
                            ],
                          ),
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
}
