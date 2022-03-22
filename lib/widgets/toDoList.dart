import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/database_service.dart';
import 'package:provider/provider.dart';
import 'package:ide_app/authentication_service.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoList = <String>[];
  final TextEditingController newTask = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<List> taskRefs = getTasks();
    return FutureBuilder<List>(
      future: taskRefs,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildWait();
        }

        var app = Theme(
          data: ThemeData(
            primarySwatch: Colors.blue,
          ),
          child: buildPage(snapshot.data!),
        );
        return app;
      },
    );
  }

  Widget buildPage(List taskRefs) {
    return Scaffold(
      body: Center(
          child: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: taskRefs.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          Map<String, dynamic> data = taskRefs[index];

          // print(data.length);
          return ListTile(
            title: Text(data["complete"]),
            subtitle: Text(data["task"]),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() {
      _todoList.add(title);
    });
  }

  // Generate list of item widgets
  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }

  //Generate a single item widget
  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: newTask,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ADD'),
                onPressed: () {
                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  context.read<DatabaseService>().addTask(
                        newTask.text,
                      );
                  //supposed to add task to db
                  print("added task to database");
                  Navigator.pop(context);
                  _addTodoItem(newTask.text);
                },
              ),
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // Future<List> _getItems() {
  //   final Future<List> _todoWidgets = getTasks();
  //   for (String title in _todoList) {
  //     _todoWidgets.add(_buildTodoItem(title));
  //   }
  //   return _todoWidgets;
  // }

  Widget buildWait() {
    return Scaffold(
      appBar: AppBar(title: Text('Wait...')),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<List> getTasks() async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    final databaseService = DatabaseService(_firebaseFirestore);
    String docId = await databaseService.getUserDocId(); // ERROr
    CollectionReference tasks = FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .collection('tasks');
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(docId);
    DocumentSnapshot snapshot = await userDoc.get();
    final data = snapshot.data() as Map<String, dynamic>;
    // print(data["projects"]);

    List taskList = data["tasks"];
    List<Map<String, dynamic>> taskData = [];
    for (DocumentReference ref in taskList) {
      DocumentSnapshot task = await tasks.doc(ref.id).get();
      final data = task.data() as Map<String, dynamic>;

      taskData.add(data);
    }
    if (taskData == null) {
      print("task data is null, list did not initialize properly");
    }
    return taskData;
  }
}
