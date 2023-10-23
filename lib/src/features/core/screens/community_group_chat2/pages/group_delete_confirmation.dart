import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/pages/group_info.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat2/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/api/apis.dart';

class GroupDeleteConfirmationPage extends StatelessWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String username;

  GroupDeleteConfirmationPage(
      {required this.groupId,
      required this.groupName,
      required this.adminName,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete Club : $groupName ?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => GroupInfotest(
                        adminName: adminName,
                        groupName: groupName,
                        groupId: groupId,
                        username: username));
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Implement delete functionality
                    await APIs.deleteGroup(groupId, groupName);
                    Get.off(() => CommunityGroupHomePagetest());
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
