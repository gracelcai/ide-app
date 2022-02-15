class ProjectMenu extends StatelessWidget {
  const ProjectMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: Text("Home"),
              ),
              Tab(
                text: Text("Files"),
              ),
              Tab(
                text: Text("Chat"),
              ),
              Tab(
                text: Text("Schedule"),
              ),
              Tab (
                text: Text("People"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("This is where your project summary and goals will be listed."),
            ),
            Center(
              child: Text("This is where you can store links and files for easy access"),
            ),
            Center(
              child: Text("This is where you can talk to the other people in the group"),
            ),
            Center(
              child: Text("This is where you can see a calendar/list view of the group tasks and deadlines."),
            ),
            Center(
              child: Text("This is where you can see all the people in the project and their roles."),
            ),
          ],
        ),
      ),
    );
  }
}
