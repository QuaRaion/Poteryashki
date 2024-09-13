import 'package:postgres/postgres.dart';
import 'dart:async';

class Database {
  final PostgreSQLConnection conn;

  Database(this.conn);

  Future<void> open() async {
    await conn.open();
  }

  Future<void> close() async {
    await conn.close();
  }

  Future<int> checkEmail(String email) async {
    final result = await conn.query(
      '''
    SELECT COUNT(*) FROM "User_reg"
    WHERE email = @email
    ''',
      substitutionValues: {
        'email': email,
      },
    );

    if (result.isNotEmpty && result.first[0] > 0) {
      return 0;
    }

    return 1; // все хорошо
  }

  Future<void> registration(String email, String password, String username) async {
    await conn.query(
        'INSERT INTO "User_reg" (email, password, username) VALUES (@email, @password, @username)',
        substitutionValues: {
          'email': email,
          'password': password,
          'username': username,
        } as Map<String, dynamic>
    );
  }

  Future<int> checkUserLogin(String email, String password) async {
    final result = await conn.query(
      'SELECT COUNT(*) FROM "User_reg" WHERE email = @email AND password = @password', // Используем @email и @password как параметры
      substitutionValues: {
        'email': email,
        'password': password,
      },
    );
    if (result.isNotEmpty && result.first[0] > 0) {
      return 0;
    }

    return 1;
  }

  Future<List<Map<String, dynamic>>> getLast20Rows() async {
    final results = await conn.query(
        'SELECT * FROM Lost_things WHERE status = 0 ORDER BY id DESC LIMIT 20'
    );

    return results.map((row) {
      return {
        'title': row[0],
        'lost_date': row[1],
        'time_1': row[2],
        'time_2': row[3],
        'description' : row[4],
        'image' : row[5],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getRowsContainingTitle(String word) async {
    final results = await conn.query(
      'SELECT * FROM Lost_things WHERE title ILIKE @word',
      substitutionValues: {
        'word': '%$word%',
      },
    );
    return results.map((row) {
      return {
        'title': row[0],
        'lost_date': row[1],
        'time_1': row[2],
        'time_2': row[3],
        'description' : row[4],
        'image' : row[5],
      };
    }).toList();
  }
}
