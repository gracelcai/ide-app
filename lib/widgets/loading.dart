import 'package:flutter/material.dart';

Widget _buildWait() {
  return Scaffold(
    appBar: AppBar(title: Text('Loading...')),
    body: Center(child: CircularProgressIndicator()),
  );
}
