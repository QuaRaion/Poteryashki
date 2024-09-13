import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Подключаемся к базе данных
  await initializeDatabase();

  // Запускаем приложение
  runApp(const MyApp());
}

Future<void> initializeDatabase() async {
  final conn = PostgreSQLConnection(
    '10.0.2.2', // Локальный хост для эмулятора Android
    5432,
    'vuzhub_db',
    username: 'postgres',
    password: 'mahkamov03',
  );

  try {
    await conn.open();
    print('Connected to database');
  } catch (e) {
    print('Error connecting to the database: $e');
  } finally {
    await conn.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
