import 'package:integritylink/src/features/core/screens/community_group_chat%20copy/pages/chat_page.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat/pages/chat_page.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTiletest extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTiletest(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTiletest> createState() => _GroupTiletestState();
}

class _GroupTiletestState extends State<GroupTiletest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPagetest(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
