import 'package:flutter/material.dart';
import 'package:ide_app/authentication_service.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
              Navigator.pop(context);
            }));
  }
}
