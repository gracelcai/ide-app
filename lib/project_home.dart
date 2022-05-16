// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/edit_project.dart';

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
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 64) / 2;
    final double itemWidth = (size.width - 64) / 2;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.all(8.0),
              color: Colors.white,
              shadowColor: Colors.white70,
              elevation: 10.0,
              child: InkWell(
                hoverColor: Colors.white70,
                child: Container(
                  width: itemWidth,
                  height: itemHeight,
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Project Description:",
                            style: TextStyle(fontSize: 24.0),
                            textAlign: TextAlign.center),
                        Text(widget.data["description"],
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              color: Colors.white,
              shadowColor: Colors.white70,
              elevation: 10.0,
              child: InkWell(
                hoverColor: Colors.white70,
                child: Container(
                  width: itemWidth,
                  height: itemHeight,
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Goals:",
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(widget.data["goals"],
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProject(
                        id: widget.id,
                      ))).then((_) => setState(() {}));
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
