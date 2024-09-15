import 'package:flutter/material.dart';
import 'package:vers2/design/colors.dart';
import 'package:vers2/pages/login_page.dart';
import 'database.dart';
import 'package:postgres/postgres.dart';

class AvatarSelectionPage extends StatelessWidget {
  final void Function(String) onAvatarSelected;

  const AvatarSelectionPage({Key? key, required this.onAvatarSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> avatarPaths = [
      'assets/avatars/ava1.png',
      'assets/avatars/ava2.png',
      'assets/avatars/ava3.png',
      'assets/avatars/ava4.png',
      'assets/avatars/ava5.png',
      'assets/avatars/ava6.png',
      'assets/avatars/ava7.png',
      'assets/avatars/ava8.png',
      'assets/avatars/ava9.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите аватар'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: avatarPaths.length,
        itemBuilder: (context, index) {
          final path = avatarPaths[index];

          return GestureDetector(
            onTap: () async {
              await _updateAvatar(index);

              onAvatarSelected(path);
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(path),
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greyColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateAvatar(int avatarIndex) async {
    final conn = PostgreSQLConnection(
      '212.67.14.125',
      5432,
      'Poteryashki',
      username: 'postgres',
      password: 'mWy8*G*y',
    );

    final db = Database(conn);

    await db.open();
    await db.changeAvatar(userEmail!, avatarIndex);
    await db.close();
  }
}
