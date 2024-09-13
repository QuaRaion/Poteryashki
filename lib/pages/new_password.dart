import 'package:flutter/material.dart';
import '../design/colors.dart';

class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Восстановление пароля"),
        backgroundColor: accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 40)),
            const Text(
              "Введите ваш email для восстановления пароля:",
              style: TextStyle(
                fontSize: 18,
                color: greyColor,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              height: 60,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: greyColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Введите ваш email',
                    hintStyle: TextStyle(
                      color: greyColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            MaterialButton(
              minWidth: 300,
              height: 65,
              onPressed: () {
                // Логика восстановления пароля
              },
              color: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                "Отправить",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Назад к настройкам",
                style: TextStyle(
                  color: greyColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
