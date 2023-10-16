import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat%20copy/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat%20copy/pages/join_approvals_page.dart';
import '../service/database_service.dart';
import '../widgets/message_tile.dart';
import '../widgets/widgets.dart';
import 'group_info.dart';

class ChatPagetest extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPagetest(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPagetest> createState() => _ChatPagetestState();
}

class _ChatPagetestState extends State<ChatPagetest> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _showFloatingArrow;
  bool _isTyping = false;

  late String groupPurpose = '';
  late String groupIcon = '';

  late String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late bool isAdmin = false;
  late int numberofApproval = 0;

  //get group snapshot

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
    fetchGroupDetails();

    _showFloatingArrow = ValueNotifier<bool>(false);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchGroupDetails() async {
    // Assuming you have the group ID stored in widget.groupId
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('groups1')
            .doc(widget.groupId)
            .get();

    if (snapshot.exists) {
      final groupData = snapshot.data();
      setState(() {
        groupPurpose = groupData![
            'groupPurpose']; // Replace 'subtitle' with the actual field name in your Firebase document
        groupIcon = groupData['groupIcon'];
        numberofApproval = groupData['unapprovedmembers'].length;
        print("Number of unapproved members: $numberofApproval");
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent - 300) {
      _showFloatingArrow.value = false;
      print("bottom of page");
    } else if (_scrollController.offset <=
        _scrollController.position.minScrollExtent) {
      _showFloatingArrow.value = true;
      print("top of page");
    } else {
      _showFloatingArrow.value = true;
      print("show arrow: else");
    }
  }

  void _handleTextChange(String value) {
    setState(() {
      _isTyping = value.isNotEmpty;
    });
  }

  getChatandAdmin() {
    DatabaseServicetest().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseServicetest().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
        String adminID = admin.substring(0, admin.indexOf("_"));
        if (adminID == currentUserId) {
          isAdmin = true;
        }
      });
    });
  }

  bool _showEmoji = false;
  final int number = 8; // Replace with your desired number

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              Get.off(() => CommunityGroupHomePagetest());
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    groupIcon.length <= 1 || groupIcon.trim() == ""
                        ? CircleAvatar(
                            radius: 20,
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
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .03),
                              child: CachedNetworkImage(
                                width: mq.height * .05,
                                height: mq.height * .05,
                                imageUrl: groupIcon,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                          ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            widget.groupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            groupPurpose,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                isAdmin
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            //TODO : navigate to approvals page
                            if (isAdmin) {
                              print("Go to join approvals page");
                              nextScreen(
                                context,
                                CommunityClubJoinApprovalScreen(
                                  groupId: widget.groupId,
                                  groupName: widget.groupName,
                                  adminName: admin,
                                  username: widget.userName,
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: isAdmin
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        numberofApproval > 9
                                            ? '${10}+'
                                            : '$numberofApproval',
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      )
                    : Container(
                        width: 0,
                      ),
                SizedBox(
                  width: 7.0,
                ),
                IconButton(
                    onPressed: () {
                      nextScreen(
                          context,
                          GroupInfotest(
                            groupId: widget.groupId,
                            groupName: widget.groupName,
                            adminName: admin,
                            username: widget.userName,
                          ));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
            body: Column(
              children: [
                // chat messages here

                chatMessages(),

                _chatInput(),

                if (_showEmoji)
                  SizedBox(
                      height: mq.height * .35,
                      //........
                      child: Container(
                        color: Colors.white,
                        child: EmojiPicker(
                          textEditingController: messageController,
                          config: Config(
                            bgColor: const Color.fromARGB(255, 234, 248, 255),
                            columns: 8,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chatMessages() {
    return Expanded(
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            time: snapshot.data.docs[index]['time'],
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: widget.userName ==
                                snapshot.data.docs[index]['sender'],
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _showFloatingArrow,
                      builder: (context, value, child) {
                        return value && !_isTyping
                            ? Positioned(
                                //bottom: 100,
                                right: 20,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                    _showFloatingArrow.value = false;
                                  },
                                  child: Icon(Icons.arrow_downward),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseServicetest().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent, size: 25),
                  ),

                  Expanded(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                sendMessage();
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
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
