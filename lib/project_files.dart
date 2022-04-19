import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/new_link.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectFiles extends StatefulWidget {
  final String id;
  const ProjectFiles({Key? key, required this.id}) : super(key: key);

  @override
  State<ProjectFiles> createState() => _ProjectFilesState();
}

class _ProjectFilesState extends State<ProjectFiles> {
  @override
  Widget build(BuildContext context) {
    Future<List> links = getLinks(widget.id);

    return FutureBuilder<List>(
        future: links,
        builder: (context, snapshot) {
          // print(links.toString());
          if (snapshot.hasError)
            return Center(child: Text(snapshot.error.toString()));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildWait();
          }

          var app = Theme(
            data: ThemeData(
              primarySwatch: Colors.blue,
            ),
            child: buildPage(context, snapshot.data!, widget.id),
          );
          return app;
        });
  }

  Widget buildWait() {
    return Scaffold(
      appBar: AppBar(title: Text('Loading...')),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildPage(context, links, id) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewLink(
                      projectId: id,
                      // notifyParent: refresh(), //not working
                    )),
          );
          setState(() {});
        },
      ),
      body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: links.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            var data = links[index];

            return ListTile(
              title: Text(data["name"]),
              subtitle: Text(data["description"]),
              onTap: () async {
                launch(data['link']);
              },
              trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    ];
                  },
                  onSelected: (String value) => () {
                        // not working with MacOS?????
                        print(value);
                        if (value == "delete") {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection("projects")
                                .doc(widget.id)
                                .collection("links")
                                .doc(data["id"])
                                .delete();
                          });
                        }
                        // actionPopUpItemSelected(value, data["id"]);
                      }),
            );
          }),
    );
  }

  Future<List> getLinks(String projectId) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference links = _firebaseFirestore
        .collection('projects')
        .doc(projectId)
        .collection('links');
    List linksData = [];
    QuerySnapshot querySnapshot = await links.get();
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      data.addAll({"id": doc.id});
      print(data);
      linksData.add(data);
    }

    return linksData;
  }

  void actionPopUpItemSelected(String value, String id) {
    String message;
    if (value == 'edit') {
      //edit id
    } else if (value == 'delete') {
      //delete id
      print("deleting $id");
      setState(() {
        FirebaseFirestore.instance
            .collection("projects")
            .doc(widget.id)
            .collection("links")
            .doc(id)
            .delete();
      });
    } else {
      message = 'Not implemented';
    }
  }
}
