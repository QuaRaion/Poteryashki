import 'package:flutter/material.dart';
import 'package:vers2/design/colors.dart';
import 'lost_page.dart';
import 'found_page.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 80), // Отступ сверху 40 пикселей
              child: Text(
                "Создать\nобъявление",
                style: TextStyle(
                  fontSize: 38,
                  color: blackColor,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 120),
            ElevatedButton(
              onPressed: () {
                // Открытие страницы для "Потерял"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LostPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Потерял",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Открытие страницы для "Нашел"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FoundPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Нашел",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
