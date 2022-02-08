import 'package:flutter/material.dart';
import 'package:ide_app/screens/authenticate/authenticate.dart';
import 'package:ide_app/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:ide_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
