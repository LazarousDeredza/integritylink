import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/features/authentication/models/user_model.dart';
import 'package:integritylink/src/features/core/controllers/profile_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/image_strings.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Users", style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: tDefaultSize, bottom: tDefaultSize, left: 10, right: 10),
          child: FutureBuilder<List<UserModel>>(
            future: controller.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          shape: ShapeBorder.lerp(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              10),
                          leading: snapshot.data![index].image != null &&
                                  snapshot.data![index].image
                                          .toString()
                                          .length >=
                                      1
                              ?
                              //image from server
                              SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .1),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: snapshot.data![index].image
                                          .toString(),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                              child:
                                                  Icon(CupertinoIcons.person)),
                                    ),
                                  ),
                                )
                              :
                              //local image
                              SizedBox(
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
                          title: Text.rich(
                            TextSpan(
                              text: snapshot.data![index].firstName +
                                  " " +
                                  snapshot.data![index].lastName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].email,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                snapshot.data![index].phoneNo != "null"
                                    ? snapshot.data![index].phoneNo
                                    : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              LineAwesomeIcons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => UpdateProfileScreen(
                              //       user: snapshot.data![index],
                              //     ),
                              //   ),
                              // );

                              print(
                                snapshot.data![index].email,
                              );
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
