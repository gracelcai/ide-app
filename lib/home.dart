import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/edit_project.dart';
import 'package:ide_app/services/database_service.dart';
// import 'package:ide_app/authentication_service.dart';
import 'package:ide_app/new_project.dart';
import 'package:ide_app/projects.dart';
// import 'package:provider/provider.dart';
// import 'package:ide_app/calendar_page.dart';
// import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:ide_app/widgets/projectInnerPages.dart';

List<Project> myProjects = [];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> projectRefs;
  bool listView = true;
  // refresh() {
  //   print("refresh");
  // }

  @override
  Widget build(BuildContext context) {
    Future<List> projectRefs = getProjects();
    return FutureBuilder<List>(
      future: projectRefs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
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

  Widget buildPage(List projectRefs) {
    List<bool> isSelected = <bool>[true, false];
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      //need to use projects list from user doc!!
      appBar: AppBar(
        title: const Text("Projects Home"),
        // actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ToggleButtons(
              isSelected: isSelected,
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.black,
              selectedColor: Colors.black,
              children: const <Widget>[
                Icon(
                  Icons.list,
                ),
                Icon(
                  Icons.window,
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                  listView = isSelected[0];
                });
              },
            ),
            Flexible(
              child: Center(
                child: listView
                    ? ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                          );
                        },
                        // Let the ListView know how many items it needs to build.
                        itemCount: projectRefs.length,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = projectRefs[index];

                          return ListTile(
                            // leading: Text("lead"),
                            // shape: RoundedRectangleBorder(
                            //     side: BorderSide(color: Colors.grey, width: 1),
                            //     borderRadius: BorderRadius.circular(5)),
                            title: Text(data["title"]),
                            subtitle: Text(data["description"]),
                            onTap: () async {
                              String id = await getId(index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProjectTabs(
                                          id: id,
                                        )), // pass in id or data - data easier, but should get id
                              );
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
                                onSelected: (String value) async {
                                  // not working with MacOS?????
                                  String id = await getId(index);
                                  if (value == "delete") {
                                    setState(() {
                                      DocumentReference project =
                                          FirebaseFirestore.instance
                                              .collection("projects")
                                              .doc(id);

                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(data["owner"].id)
                                          .update({
                                        "projects":
                                            FieldValue.arrayRemove([project])
                                      });
                                      project.delete();
                                    });
                                  } else if (value == "edit") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProject(
                                                  id: id,
                                                ))).then(
                                        (_) => setState(() {}));
                                  }
                                  // actionPopUpItemSelected(value, data["id"]);
                                }),
                          );
                        })
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (itemWidth / itemHeight),
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisExtent: 150,
                        ),
                        itemCount: projectRefs.length,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = projectRefs[index];

                          return Card(
                            margin: EdgeInsets.all(8.0),
                            color: Colors.white,
                            shadowColor: Colors.white70,
                            elevation: 10.0,
                            child: InkWell(
                              child: Container(
                                width: itemWidth,
                                height: itemHeight,
                                alignment: AlignmentDirectional.topStart,
                                padding: EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data["title"],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            data["description"],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      PopupMenuButton(
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
                                          onSelected: (String value) async {
                                            // not working with MacOS?????
                                            String id = await getId(index);
                                            if (value == "delete") {
                                              setState(() {
                                                DocumentReference project =
                                                    FirebaseFirestore.instance
                                                        .collection("projects")
                                                        .doc(id);

                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(data["owner"].id)
                                                    .update({
                                                  "projects":
                                                      FieldValue.arrayRemove(
                                                          [project])
                                                });
                                                project.delete();
                                              });
                                            } else if (value == "edit") {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditProject(
                                                                id: id,
                                                              )))
                                                  .then((_) => setState(() {}));
                                            }
                                            // actionPopUpItemSelected(value, data["id"]);
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                String id = await getId(index);
                                // print(id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectTabs(
                                            id: id,
                                          )), // pass in id or data - data easier, but should get id
                                );
                              },
                            ),
                          );
                        }),
              ),
            )
          ],
        ),
      ),

      drawer: SideMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewProject(
                    // notifyParent: refresh(), //not working
                    )),
          ).then((_) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget buildWait() {
  return Scaffold(
    appBar: AppBar(title: Text('Loading...')),
    body: Center(child: CircularProgressIndicator()),
  );
}

Future<List> getProjects() async {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference projects = _firebaseFirestore.collection('projects');
  final databaseService = DatabaseService(_firebaseFirestore);
  String docId = await databaseService.getUserId();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(docId);
  DocumentSnapshot snapshot = await userDoc.get();
  final data = snapshot.data() as Map<String, dynamic>;
  // print(data["projects"]);

  List projectRefs = data["projects"];
  List<Map<String, dynamic>> projectData = [];
  for (DocumentReference ref in projectRefs) {
    DocumentSnapshot project = await projects.doc(ref.id).get();
    try {
      final data = project.data() as Map<String, dynamic>;

      projectData.add(data);
    } catch (error) {
      continue;
    }
  }
  // print(projectData);
  return projectData;
}

Future<String> getId(int index) async {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference projects = _firebaseFirestore.collection('projects');
  final databaseService = DatabaseService(_firebaseFirestore);
  String docId = await databaseService.getUserId(); // ERROr
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(docId);
  DocumentSnapshot snapshot = await userDoc.get();
  final data = snapshot.data() as Map<String, dynamic>;
  // print(data["projects"]);

  List projectRefs = data["projects"];
  List<Map<String, dynamic>> projectData = [];
  DocumentReference ref = projectRefs[index];
  return ref.id;
}
