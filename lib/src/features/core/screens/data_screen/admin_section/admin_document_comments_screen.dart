import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integritylink/src/features/core/screens/data_screen/model_document.dart';

class AdminDocumentCommentsScreen extends StatefulWidget {
  final String id;

  //user id from firebase currently logged in user

  const AdminDocumentCommentsScreen({required this.id});

  @override
  _AdminDocumentCommentsScreenState createState() =>
      _AdminDocumentCommentsScreenState();
}

class _AdminDocumentCommentsScreenState
    extends State<AdminDocumentCommentsScreen> {
//  late Future<DocumentSnapshot<Map<String, dynamic>>> _caseFuture;

  late String? userId;

  @override
  void initState() {
    super.initState();
    // _caseFuture =
    //     FirebaseFirestore.instance.collection('cases').doc(widget.caseId).get();

    //initiate the user id from firebase
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final _commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Document Comments'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Center(
                  child: Text(
                    "Comments",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              //if case is open put a text field to add comments and a button to submit in a row

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Add a comment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
//return if the text field is empty
                      if (_commentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a comment'),
                          ),
                        );
                        return;
                      }

                      //submit comment to firebase

                      DocumentComment comment = DocumentComment(
                          comment: _commentController.text,
                          docID: widget.id,
                          userID: userId,
                          date: DateTime.now().toString(),
                          numberOfDislikes: 0,
                          numberOfLikes: 0,
                          approved: "Yes");

                      FirebaseFirestore.instance
                          .collection('document_comments')
                          .add(comment.toJson())
                          .then((value) => {
                                //clear the text field
                                _commentController.clear(),
                                //toast message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Comment added successfully'),
                                  ),
                                ),

                                //show a list of comments

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminDocumentCommentsScreen(
                                      id: widget.id,
                                    ),
                                  ),
                                )
                              });
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),

              //show a list of comments from firebase where case id is equal to the case id of the case being viewed and approved is equal to yes
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('document_comments')
                    .where('docID', isEqualTo: widget.id)
                    .where('approved', isEqualTo: 'No')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No Comments available'));
                  }

                  final comments = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Column(children: [
                          ListTile(
                            leading:
                                //user profile icon
                                CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 15.0, right: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(comments[index]['comment']),
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        //like icon
                                        GestureDetector(
                                          onTap: () {
                                            //update the likes field in firebase

                                            LikeAndDislike likeAndDilike =
                                                LikeAndDislike(
                                                    docID: widget.id,
                                                    userID: userId,
                                                    date: DateTime.now()
                                                        .toString());

                                            //check if the user has already liked the comment
                                            FirebaseFirestore.instance
                                                .collection('document_comments')
                                                .doc(comments[index].id)
                                                .collection('likes')
                                                .where('userID',
                                                    isEqualTo: userId)
                                                .get()
                                                .then((value) => {
                                                      if (value.docs.isEmpty)
                                                        {
                                                          //check if i had disliked the comment before and remove it ,and deduct the number of dislikes by 1
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'document_comments')
                                                              .doc(comments[
                                                                      index]
                                                                  .id)
                                                              .collection(
                                                                  'dislikes')
                                                              .where('userID',
                                                                  isEqualTo:
                                                                      userId)
                                                              .get()
                                                              .then((value) => {
                                                                    if (value
                                                                        .docs
                                                                        .isNotEmpty)
                                                                      {
                                                                        //remove the user from the dislikes collection
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'document_comments')
                                                                            .doc(comments[index]
                                                                                .id)
                                                                            .collection(
                                                                                'dislikes')
                                                                            .doc(value
                                                                                .docs.first.id)
                                                                            .delete()
                                                                            .then((value) =>
                                                                                {
                                                                                  //update the dislikes field in the comments collection
                                                                                  FirebaseFirestore.instance.collection('comments').doc(comments[index].id).update({
                                                                                    'numberOfDislikes': comments[index]['numberOfDislikes'] - 1
                                                                                  })
                                                                                })
                                                                      }
                                                                  }),

                                                          //add the user to the likes collection
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'document_comments')
                                                              .doc(comments[
                                                                      index]
                                                                  .id)
                                                              .collection(
                                                                  'likes')
                                                              .add(likeAndDilike
                                                                  .toJson())
                                                              .then((value) => {
                                                                    //update the likes field in the comments collection
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'document_comments')
                                                                        .doc(comments[index]
                                                                            .id)
                                                                        .update({
                                                                      'numberOfLikes':
                                                                          comments[index]['numberOfLikes'] +
                                                                              1
                                                                    }).then((value) =>
                                                                            {
                                                                              //toast message
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text('Comment liked successfully'),
                                                                                ),
                                                                              ),
                                                                            })
                                                                  })
                                                        }
                                                      else
                                                        {
                                                          //toast message
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'You have already liked this comment'),
                                                            ),
                                                          ),
                                                        }
                                                    });
                                          },
                                          child: Icon(
                                            Icons.thumb_up,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                                '${comments[index]['numberOfLikes']}')),
                                        SizedBox(width: 40.0),
                                        //dislike icon
                                        GestureDetector(
                                          onTap: () {
                                            //update the likes field in firebase

                                            LikeAndDislike likeAndDilike =
                                                LikeAndDislike(
                                                    docID: widget.id,
                                                    userID: userId,
                                                    date: DateTime.now()
                                                        .toString());

                                            //check if the user has already disliked the comment
                                            FirebaseFirestore.instance
                                                .collection('document_comments')
                                                .doc(comments[index].id)
                                                .collection('dislikes')
                                                .where('userID',
                                                    isEqualTo: userId)
                                                .get()
                                                .then((value) => {
                                                      if (value.docs.isEmpty)
                                                        {
                                                          //check if i had liked the comment before and remove it ,and deduct the number of likes by 1
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'document_comments')
                                                              .doc(comments[
                                                                      index]
                                                                  .id)
                                                              .collection(
                                                                  'likes')
                                                              .where('userID',
                                                                  isEqualTo:
                                                                      userId)
                                                              .get()
                                                              .then((value) => {
                                                                    if (value
                                                                        .docs
                                                                        .isNotEmpty)
                                                                      {
                                                                        //remove the user from the likes collection
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'document_comments')
                                                                            .doc(comments[index]
                                                                                .id)
                                                                            .collection(
                                                                                'likes')
                                                                            .doc(value
                                                                                .docs.first.id)
                                                                            .delete()
                                                                            .then((value) =>
                                                                                {
                                                                                  //update the likes field in the comments collection
                                                                                  FirebaseFirestore.instance.collection('comments').doc(comments[index].id).update({
                                                                                    'numberOfLikes': comments[index]['numberOfLikes'] - 1
                                                                                  })
                                                                                })
                                                                      }
                                                                  }),

                                                          //add the user to the dislikes collection
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'document_comments')
                                                              .doc(comments[
                                                                      index]
                                                                  .id)
                                                              .collection(
                                                                  'dislikes')
                                                              .add(likeAndDilike
                                                                  .toJson())
                                                              .then((value) => {
                                                                    //update the dislikes field in the comments collection
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'document_comments')
                                                                        .doc(comments[index]
                                                                            .id)
                                                                        .update({
                                                                      'numberOfDislikes':
                                                                          comments[index]['numberOfDislikes'] +
                                                                              1
                                                                    }).then((value) =>
                                                                            {
                                                                              //toast message
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text('Comment disliked successfully'),
                                                                                ),
                                                                              ),
                                                                            })
                                                                  })
                                                        }
                                                      else
                                                        {
                                                          //toast message
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'You have already disliked this comment'),
                                                            ),
                                                          ),
                                                        }
                                                    });
                                          },
                                          child: Icon(
                                            Icons.thumb_down,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Text(
                                            '${comments[index]['numberOfDislikes']}',
                                          ),
                                        ),
                                        SizedBox(width: 40.0),
                                        //delete comment icon
                                        GestureDetector(
                                          onTap: () {
                                            //delete the comment from firebase
//show a confirm dialog first
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete Comment'),
                                                  content: Text(
                                                      'Are you sure you want to delete this comment?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        //delete the comment from firebase
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'document_comments')
                                                            .doc(comments[index]
                                                                .id)
                                                            .delete()
                                                            .then((value) => {
                                                                  //toast message
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          'Comment deleted successfully'),
                                                                    ),
                                                                  ),
                                                                  //show a list of comments

                                                                  Navigator
                                                                      .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AdminDocumentCommentsScreen(
                                                                        id: widget
                                                                            .id,
                                                                      ),
                                                                    ),
                                                                  )
                                                                });
                                                      },
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //trailing approve comment icon
                            trailing: GestureDetector(
                              onTap: () {
                                //update the approved field in firebase
                                //show a confirm dialog first

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Approve Comment'),
                                      content: Text(
                                          'Are you sure you want to approve this comment?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            //update the approved field in firebase
                                            FirebaseFirestore.instance
                                                .collection('document_comments')
                                                .doc(comments[index].id)
                                                .update({
                                              'approved': 'Yes'
                                            }).then((value) => {
                                                      //toast message
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Comment approved successfully'),
                                                        ),
                                                      ),
                                                      //show a list of comments

                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AdminDocumentCommentsScreen(
                                                            id: widget.id,
                                                          ),
                                                        ),
                                                      )
                                                    });
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              thickness: 2.0,
                            ),
                          ),
                        ]),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
