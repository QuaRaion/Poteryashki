import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:postgres/postgres.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));

  // final conn = PostgreSQLConnection(
  //   '10.0.2.2',
  //   5432,
  //   'vuzhub_db',
  //   username: 'postgres',
  //   password: 'mahkamov03',
  // );
  //
  // try {
  //   await conn.open();
  //   print('Connected to database');
  // } catch (e) {
  //   print('Error executing query: $e');
  // } finally {
  //   await conn.close();
  // }
}
