import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../design/colors.dart';

class FoundPage extends StatefulWidget {
  const FoundPage({super.key});

  @override
  State<FoundPage> createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      setState(() {
        _timeController.text = DateFormat('HH:mm').format(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Нашел вещь",
                style: TextStyle(
                  fontSize: 38,
                  color: blackColor,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Поле для ввода заголовка
            TextField(
              decoration: InputDecoration(
                hintText: 'Что нашли?',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Поле для ввода адреса
            TextField(
              decoration: InputDecoration(
                hintText: 'Адрес места находки',
                hintStyle: const TextStyle(color: greyColor),
                filled: true,
                fillColor: whiteColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Поле для ввода даты с календарем
            TextField(
              controller: _dateController,
              readOnly: true, // Чтобы поле не вызывало клавиатуру
              decoration: InputDecoration(
                hintText: 'Дата находки',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                _selectDate(context); // Открытие календаря
              },
            ),
            const SizedBox(height: 10),

            // Поле для ввода времени
            TextField(
              controller: _timeController,
              readOnly: true, // Чтобы поле не вызывало клавиатуру
              decoration: InputDecoration(
                hintText: 'Время находки',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                _selectTime(context); // Открытие выбора времени
              },
            ),
            const SizedBox(height: 10),

            // Поле для описания
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Описание',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Кнопка "Готово"
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Логика сохранения объявления
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Готово",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
