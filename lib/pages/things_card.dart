import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> thing;

  const ProductDetailsPage({Key? key, required this.thing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              thing['image'] ?? 'assets/img/default.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/img/default.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              thing['title'] ?? 'Без названия',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              thing['address'] ?? 'Без адреса',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              thing['description'] ?? 'Нет описания',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Дата потери: ${thing['lost_date'] ?? 'Неизвестно'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Время потери: ${thing['time_1'] ?? 'Не указано'} - ${thing['time_2'] ?? 'Не указано'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Телефон: ${thing['number'] ?? 'Не указано'}',
              style: const TextStyle(fontSize: 16),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     final Uri phoneUri = Uri(
            //       scheme: 'tel',
            //       path: ' ${thing['number'] ?? 'Неизвестно'}',
            //     );
            //
            //     if (await canLaunchUrl(phoneUri)) {
            //       await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
            //     } else {
            //       throw 'Could not launch $phoneUri';
            //     }
            //   },
            //   child: const Text('Позвонить'),
            // )


          ],
        ),
      ),
    );
  }
}
