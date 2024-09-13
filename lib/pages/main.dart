import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:postgres/postgres.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}
