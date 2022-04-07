import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/new_link.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';

// firebase_storage.FirebaseStorage storage =
//     firebase_storage.FirebaseStorage.instance;

// Future<void> uploadExample() async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String filePath = '${appDocDir.absolute}/file-to-upload.png';
//   // ...
//   await uploadFile(filePath);
// }

// Future<void> uploadFile(String filePath) async {
//   File file = File(filePath);

//   try {
//     await firebase_storage.FirebaseStorage.instance
//         .ref('uploads/file-to-upload.png')
//         .putFile(file);
//   } on FirebaseException catch (e) {
//     // e.g, e.code == 'canceled'
//   }
// }

class ProjectFiles extends StatefulWidget {
  final String id;
  const ProjectFiles({Key? key, required this.id}) : super(key: key);

  @override
  State<ProjectFiles> createState() => _ProjectFilesState();
}

class _ProjectFilesState extends State<ProjectFiles> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewLink(
                      projectId: widget.id,
                      notifyParent: refresh(), //not working
                    )),
          );
        },
      ),
    );
  }
}
