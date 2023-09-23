import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  String url = '';

  uploadDataToFirebase() async {
    //pick pdf file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

//show snackbar if no file is selected
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No File Selected"),
      ));
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Uploading File"),
      ));
    }

    File pick = File(result.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String fileName = pick.path.split('/').last;

    //uploading file to firebase storage
    var pdfFile =
        await FirebaseStorage.instance.ref().child("articles").child(fileName);
    UploadTask task = pdfFile.putData(file);

    TaskSnapshot snapshotTask = await task;
    url = await snapshotTask.ref.getDownloadURL();

    //uploading url to firebase firestore
    await FirebaseFirestore.instance
        .collection('articles')
        .add({'url': url, 'name': fileName}).whenComplete(() => () {
              //snackbar
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("File Uploaded"),
              ));
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadDataToFirebase,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot x = snapshot.data!.docs[i];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfViewer(
                                    url: x['url'],
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          //pdf image
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/pdf.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                x['name'],
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     FirebaseFirestore.instance
                          //         .collection('articles')
                          //         .doc(x.id)
                          //         .delete();
                          //   },
                          //   icon: Icon(Icons.delete),
                          // ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text("No Data found"),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String url;
  static PdfViewerController? _pdfViewerController;

  const PdfViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF View")),
      body: SfPdfViewer.network(url, controller: _pdfViewerController),
    );
  }
}
