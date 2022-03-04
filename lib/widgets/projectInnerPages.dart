import 'package:flutter/material.dart';

void main() {
  runApp(const ProjectTabs());
}

class ProjectTabs extends StatelessWidget {
  const ProjectTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Overview',
                ),
                Tab(
                  text: 'Files',
                ),
                Tab(
                  text: 'Schedule',
                ),
                Tab(
                  text: 'Discussions',
                ),
                Tab(
                  text: 'People',
                ),
              ],
            ),
            title: const Text('Project Title'),
          ),
          body: const TabBarView(
            children: [
              Text(
                  'will contain your description and goals'), //replace with pagewidgets
              Text('will display your shared files and links'),
              Text('will display the project schedule'),
              Text('will allow you to communicate with your group'),
              Text('will show your groupmembers'),
            ],
          ),
        ),
      ),
    );
  }
}
