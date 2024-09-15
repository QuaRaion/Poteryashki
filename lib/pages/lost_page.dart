import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import '../design/colors.dart';
import 'database.dart';
import 'login_page.dart';

class LostPage extends StatefulWidget {
  const LostPage({super.key});

  @override
  State<LostPage> createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController1 = TextEditingController();
  final TextEditingController _timeController2 = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime1;
  TimeOfDay? _selectedTime2;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int timeIndex) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (timeIndex == 1) {
          _selectedTime1 = picked;
          _timeController1.text = picked.format(context); // Используйте TimeOfDay.format()
        } else {
          _selectedTime2 = picked;
          _timeController2.text = picked.format(context); // Используйте TimeOfDay.format()
        }
      });
    }
  }

  Future<void> _saveData() async {
    final title = _titleController.text;
    final address = _addressController.text;
    final description = _descriptionController.text;
    final date = _selectedDate;
    final time1 = _selectedTime1;
    final time2 = _selectedTime2;

    if (title.isNotEmpty &&
        address.isNotEmpty &&
        description.isNotEmpty &&
        date != null &&
        time1 != null &&
        time2 != null) {
      final time1Interval = '${time1.hour}:${time1.minute}:00';
      final time2Interval = '${time2.hour}:${time2.minute}:00';

      final conn = PostgreSQLConnection(
        '212.67.14.125',
        5432,
        'Poteryashki',
        username: 'postgres',
        password: 'mWy8*G*y',
      );
      final db = Database(conn);
      await db.open();
      await db.lostThingAdd(
        userID as int,
        title,
        date,
        time1Interval,
        time2Interval,
        description,
        '',
        address,
        number as String,
      );
      await db.close();

      // Оповещаем пользователя об успешном сохранении
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Объявление сохранено')),
      );

      // Возвращаемся на предыдущую страницу
      Navigator.pop(context);
    } else {
      // Оповещаем пользователя о том, что нужно заполнить все поля
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
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
                "Потерял вещь",
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
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Что потеряли?',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Поле для ввода адреса
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Адрес места потери',
                hintStyle: TextStyle(color: greyColor),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(
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
              decoration: const InputDecoration(
                hintText: 'Дата потери',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                _selectDate(context); // Открытие календаря
              },
            ),
            const SizedBox(height: 10),

            // Поле для ввода времени начала
            TextField(
              controller: _timeController1,
              readOnly: true, // Чтобы поле не вызывало клавиатуру
              decoration: const InputDecoration(
                hintText: 'Время потери от',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                _selectTime(context, 1); // Открытие выбора времени для начала
              },
            ),
            const SizedBox(height: 10),

            // Поле для ввода времени окончания
            TextField(
              controller: _timeController2,
              readOnly: true, // Чтобы поле не вызывало клавиатуру
              decoration: const InputDecoration(
                hintText: 'Время потери до',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                _selectTime(context, 2); // Открытие выбора времени для окончания
              },
            ),
            const SizedBox(height: 10),

            // Поле для описания
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Описание',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Кнопка "Готово"
            Center(
              child: ElevatedButton(
                onPressed: _saveData,
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
