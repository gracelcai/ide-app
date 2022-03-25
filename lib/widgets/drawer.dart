import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/services/authentication_service.dart';
import 'package:ide_app/new_project.dart';
import 'package:ide_app/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ide_app/calendar_page.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/home.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Navigate'),
          ),
          ListTile(
            title: const Text('My Projects'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ListTile(
            title: const Text('My Tasks'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TaskPage()),
              );
            },
          ),
          ListTile(
            title: const Text('My Calendar'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class sideMenu extends StatelessWidget {
//   const sideMenu({
//     Key? key,
//     required this.context,
//   }) : super(key: key);

//   final BuildContext context;

//   @override
//   // Widget build(BuildContext context) async {
//   //   return widget(
//   //     child: Drawer(
//   //       child: ListView(
//   //         // Important: Remove any padding from the ListView.
//   //         padding: EdgeInsets.zero,
//   //         children: [
//   //           const DrawerHeader(
//   //             decoration: BoxDecoration(
//   //               color: Colors.blue,
//   //             ),
//   //             child: Text('Navigate'),
//   //           ),
//   //           ListTile(
//   //             title: const Text('My Projects'),
//   //             onTap: () {
//   //               Navigator.pushReplacement(
//   //                 context,
//   //                 MaterialPageRoute(builder: (context) => const MyHomePage()),
//   //               );
//   //             },
//   //           ),
//   //           ListTile(
//   //             title: const Text('My Tasks'),
//   //             onTap: () {
//   //               // Update the state of the app
//   //               // ...
//   //               // Then close the drawer
//   //               Navigator.pushReplacement(
//   //                 context,
//   //                 MaterialPageRoute(builder: (context) => const TaskPage()),
//   //               );
//   //             },
//   //           ),
//   //           ListTile(
//   //             title: const Text('My Calendar'),
//   //             onTap: () {
//   //               Navigator.pushReplacement(
//   //                 context,
//   //                 MaterialPageRoute(builder: (context) => const CalendarPage()),
//   //               );
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
