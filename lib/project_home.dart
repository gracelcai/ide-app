// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectHome extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  ProjectHome({Key? key, required this.id, required this.data})
      : super(key: key);

  @override
  State<ProjectHome> createState() => _ProjectHomeState();
}

class _ProjectHomeState extends State<ProjectHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project Description:",
            style: TextStyle(fontSize: 24.0),
          ),
          Text(widget.data["description"], style: TextStyle(fontSize: 16.0)),
          Text("Project Goals:", style: TextStyle(fontSize: 24.0)),
          Text(widget.data["goals"], style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
