import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/database_service.dart';
import 'package:provider/provider.dart';
import 'package:ide_app/widgets/projectInnerPages.dart';

class Project extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ProjectTabs(
        id: '',
        data: Map<String, dynamic>(),
      ),
    );
  }
}
