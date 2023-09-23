import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/api/apis.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/constants/text_strings.dart';
import 'package:integritylink/src/features/authentication/models/user_model.dart';
import 'package:integritylink/src/features/core/controllers/profile_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String? _image;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    //form key
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(tEditProfile, style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;

                  final firstName =
                      TextEditingController(text: userData.firstName);
                  final lastName =
                      TextEditingController(text: userData.lastName);
                  final email = TextEditingController(text: userData.email);
                  final phoneNo = TextEditingController(text: userData.phoneNo);
                  String? image = userData.image;

                  String? joinedAt = userData.createdAt;
                  final about = TextEditingController(text: userData.about);

                  return Column(
                    children: [
                      Stack(
                        children: [
                          //profile picture
                          image != null
                              ?
                              //image from server
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: CachedNetworkImage(
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover,
                                    imageUrl: image,
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                            child: Icon(CupertinoIcons.person)),
                                  ),
                                )
                              :
                              //local image
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: Image(
                                      image: AssetImage(tProfileImage),
                                      width: mq.height * .2,
                                      height: mq.height * .2,
                                      fit: BoxFit.cover),
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
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                      const SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              //enabled: false,
                              //initialValue: userData.firstName,
                              controller: firstName,
                              decoration: const InputDecoration(
                                labelText: "First Name",
                                hintText: "Enter your first name",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter first name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: tFormHeight - 20,
                            ),
                            TextFormField(
                              // enabled: false,
                              //initialValue: userData.lastName,
                              controller: lastName,
                              decoration: const InputDecoration(
                                labelText: "Last Name",
                                hintText: "Enter your last name",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter last name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: tFormHeight - 20,
                            ),

                            TextFormField(
                              //initialValue: userData.phoneNo,
                              controller: phoneNo,
                              //enabled: false,
                              decoration: const InputDecoration(
                                labelText: tPhoneNumber,
                                hintText: "Enter your phone number",
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Phone Number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: tFormHeight - 20,
                            ),

                            TextFormField(
                              // enabled: false,
                              //initialValue: userData.lastName,
                              maxLines: null,
                              controller: about,
                              decoration: const InputDecoration(
                                labelText: "About",
                                hintText: "About",
                                prefixIcon: Icon(Icons.book),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'About';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: tFormHeight - 20,
                            ),
                            TextFormField(
                              enabled: false,
                              //initialValue: userData.email,
                              controller: email,
                              decoration: const InputDecoration(
                                labelText: tEmail,
                                hintText: "Enter your email",
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter email';
                                } else if (!GetUtils.isEmail(value)) {
                                  return 'Please Enter Valid Email';
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: tFormHeight - 20,
                            ),

                            //password
                            TextFormField(
                              initialValue: tPassword,
                              enabled: false,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: tPassword,
                                hintText: "Enter your password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),

                            SizedBox(
                              height: tFormHeight,
                            ),
                            //rounded corner submit button
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final time = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                    UserModel user = UserModel(
                                      id: userData.id,
                                      level: userData.level,
                                      firstName: firstName.text.trim(),
                                      lastName: lastName.text.trim(),
                                      email: userData.email,
                                      phoneNo: phoneNo.text.trim(),
                                      password: userData.password,
                                      groups: userData.groups,
                                      instGroups: userData.instGroups,
                                      image: userData.image,
                                      createdAt: userData.createdAt,
                                      name: firstName.text.trim() +
                                          " " +
                                          lastName.text.trim(),
                                      about: about.text.trim(),
                                      isOnline: true,
                                      lastActive: time,
                                      pushToken: '',
                                    );

                                    await controller.updateRecord(user);
                                  }
                                },
                                child: const Text(
                                  tUpdate,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: tFormHeight,
                            ),
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: tJoined,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " ",
                                      ),
                                      TextSpan(
                                        text: formatTime(joinedAt!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //delete button
                                const Spacer(),

                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      tDelete,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Center(child: Text("No data found"));
                } else {
                  return Center(child: Text("Something went wrong"));
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  String formatTime(String millisecondsString) {
    int? milliseconds = int.tryParse(millisecondsString);
    if (milliseconds == null) {
      return 'Invalid time value';
    }

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
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
              const Text('Pick Profile Picture',
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

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
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

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
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
