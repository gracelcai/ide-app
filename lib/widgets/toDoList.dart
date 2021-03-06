import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:ide_app/services/authentication_service.dart';
import 'package:ide_app/calendar_page.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoList = <String>[];
  final TextEditingController newTask = TextEditingController();
  final TextEditingController day = TextEditingController();
  final TextEditingController month = TextEditingController();
  late List<bool> _isSelected;

  @override
  Widget build(BuildContext context) {
    Future<Scaffold> taskList = getTaskList();
    return FutureBuilder(
        future: taskList,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("none");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return buildPage(snapshot.data as Scaffold);
            default:
              return Text("default");
          }
        }));
  }

  Widget buildPage(Scaffold taskList) {
    return Scaffold(
      body: taskList,
      drawer: SideMenu(),
      // body: Center(
      //   //   child: ListView.builder(
      //   // // Let the ListView know how many items it needs to build.
      //   // itemCount: taskRefs.length,
      //   // // Provide a builder function. This is where the magic happens.
      //   // // Convert each item into a widget based on the type of item it is.
      //   // itemBuilder: (context, index) {
      //   //   Map<String, dynamic> data = taskRefs[index];

      //   //   // print(data.length);
      //   //   return ListTile(
      //   //     title: Text(data["complete"]),
      //   //     subtitle: Text(data["task"]),
      //   //   );
      //   // },
      // )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    context
        .read<DatabaseService>()
        .addTask(newTask.text, false, day.text, month.text);
    //supposed to add task to db
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
            content: Container(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  TextField(
                    controller: newTask,
                    decoration:
                        const InputDecoration(hintText: 'Enter task here'),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: month,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'MM'),
                        ),
                      ),
                      Flexible(
                        child: Text("  /  "),
                      ),
                      Flexible(
                        child: TextField(
                          controller: day,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'DD'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // TextField(
            //   controller: newTask,
            //   decoration: const InputDecoration(hintText: 'Enter task here'),
            // ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ADD'),
                onPressed: () {
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

  Future<Scaffold> getTaskList() async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    //print("called get tasks");
    final databaseService = DatabaseService(_firebaseFirestore);
    String docId = await databaseService.getUserDocId(); // ERROr
    CollectionReference tasks = FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .collection('tasks');
    resetMeetingList();
    return Scaffold(
        // ignore: unnecessary_new
        body: StreamBuilder(
      stream: tasks.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("Error with snapshot");
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((document) {
            DateTime start = DateTime(2022, document['month'], document['day']);
            addMeeting(Meeting(document['task'], start, start,
                const Color.fromARGB(255, 33, 150, 243), true));
            return Center(
              child: CheckboxListTile(
                  title: Text(document['task']),
                  subtitle: Text(document['month'].toString() +
                      "/" +
                      document['day'].toString()),
                  value: document['complete'],
                  secondary: Container(
                    height: 50,
                    width: 50,
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                      databaseService.toggleTask(document.id, value!);
                    });
                  }),
            );
          }).toList(),
        );
      },
    ));
  }
}
