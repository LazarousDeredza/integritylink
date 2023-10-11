import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/api/apis.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/features/authentication/models/user_model.dart';
import 'package:integritylink/src/features/core/controllers/profile_controller.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/models/chat_user.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/screens/chat_screen.dart';

class ChatUsersScreen extends StatefulWidget {
  @override
  _ChatUsersScreenState createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  final controller = Get.put(ProfileController());
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    List<UserModel> users = await controller.getAllUsers();
    setState(() {
      allUsers = users;
      filteredUsers = users;
    });
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUsers =
            List.from(allUsers); // If search query is empty, show all users
      });
    } else {
      final lowerCaseQuery = query.toLowerCase();
      setState(() {
        filteredUsers = allUsers.where((user) {
          return user.firstName.toLowerCase().contains(lowerCaseQuery) ||
              user.lastName.toLowerCase().contains(lowerCaseQuery) ||
              user.email.toLowerCase().contains(lowerCaseQuery) ||
              user.name.toLowerCase().contains(lowerCaseQuery) ||
              user.phoneNo.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBar(
              onChanged: (query) => filterUsers(query),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  UserModel userData = filteredUsers[index];
                  return Column(
                    children: [
                      ListTile(
                        shape: ShapeBorder.lerp(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            10),
                        leading: userData.image != null &&
                                userData.image.toString().length >= 1
                            ?
                            //image from server
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ProfileImagePopup(
                                      imageUrl: userData.image.toString(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .1),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userData.image.toString(),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                              child:
                                                  Icon(CupertinoIcons.person)),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: Image(
                                      image: AssetImage(tProfileImage),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        title: GestureDetector(
                          onTap: (() async {
                            await APIs.addChatUser(userData.email)
                                .then((value) {
                              print("Opening Conver");
                              ChatUser user = ChatUser(
                                email: userData.email,
                                firstName: userData.firstName,
                                lastName: userData.lastName,
                                phoneNo: userData.phoneNo,
                                image: userData.image ?? '',
                                about: userData.about,
                                createdAt: userData.createdAt ?? '',
                                groups: userData.groups ?? [],
                                id: userData.id ?? '',
                                isOnline: userData.isOnline,
                                lastActive: userData.lastActive,
                                level: userData.level ?? '',
                                name: userData.name,
                                pushToken: userData.pushToken,
                              );

                              Get.to(
                                () => ChatScreen(
                                  user: user,
                                ),
                              );
                            });
                            print(
                              userData.email,
                            );
                          }),
                          child: Text.rich(
                            TextSpan(
                              text:
                                  userData.firstName + " " + userData.lastName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        subtitle: GestureDetector(
                          onTap: (() async {
                            await APIs.addChatUser(userData.email)
                                .then((value) {
                              print("Opening Conver");
                              ChatUser user = ChatUser(
                                email: userData.email,
                                firstName: userData.firstName,
                                lastName: userData.lastName,
                                phoneNo: userData.phoneNo,
                                image: userData.image ?? '',
                                about: userData.about,
                                createdAt: userData.createdAt ?? '',
                                groups: userData.groups ?? [],
                                id: userData.id ?? '',
                                isOnline: userData.isOnline,
                                lastActive: userData.lastActive,
                                level: userData.level ?? '',
                                name: userData.name,
                                pushToken: userData.pushToken,
                              );

                              Get.to(
                                () => ChatScreen(
                                  user: user,
                                ),
                              );
                            });
                            print(
                              userData.email,
                            );
                          }),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData.email,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData.phoneNo != "null"
                                    ? userData.phoneNo
                                    : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.message_rounded,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            await APIs.addChatUser(userData.email)
                                .then((value) {
                              print("Opening Conver");
                              ChatUser user = ChatUser(
                                email: userData.email,
                                firstName: userData.firstName,
                                lastName: userData.lastName,
                                phoneNo: userData.phoneNo,
                                image: userData.image ?? '',
                                about: userData.about,
                                createdAt: userData.createdAt ?? '',
                                groups: userData.groups ?? [],
                                id: userData.id ?? '',
                                isOnline: userData.isOnline,
                                lastActive: userData.lastActive,
                                level: userData.level ?? '',
                                name: userData.name,
                                pushToken: userData.pushToken,
                              );

                              Get.to(
                                () => ChatScreen(
                                  user: user,
                                ),
                              );
                            });
                            print(
                              userData.email,
                            );
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onChanged;

  SearchBar({required this.onChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: widget.onChanged,
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
          ),
      decoration: InputDecoration(
        labelText: 'Search User',
        prefixIcon: Icon(Icons.search),
        //rounded border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),

        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    widget.onChanged('');
                  });
                },
              )
            : null,
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
