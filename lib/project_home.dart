import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectHome extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  ProjectHome(
      {Key? key, required this.id, required Map<String, dynamic> this.data})
      : super(key: key);

  @override
  State<ProjectHome> createState() => _ProjectHomeState();
}

class _ProjectHomeState extends State<ProjectHome> {
  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> project =
        FirebaseFirestore.instance.collection('projects').doc(widget.id).get();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Project Description:"),
        Text(widget.data["description"]),
        Text("Project Goals:"),
        Text(widget.data["goals"]),
      ],
    );
  }
}
