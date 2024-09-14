import 'package:flutter/material.dart';
import '../design/colors.dart';
import 'database.dart';
import 'package:postgres/postgres.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> events = [
    {'id': '1', 'title': 'Woman hand bag black', 'address': 'Москва, ул. Ленина', 'image': 'assets/img/img1.png'},
    {'id': '2', 'title': 'AirPods 2', 'address': 'Санкт-Петербург, Невский пр.', 'image': 'assets/img/img2.png'},
    {'id': '3', 'title': 'Большой текст на две строчки, который никуда не помещается', 'address': 'Новосибирск, ул. Красный пр.', 'image': 'assets/img/img3.png'},
  ];

  List<Map<String, dynamic>> filteredEvents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredEvents = events;
  }

  void _filterEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEvents = events;
      } else {
        filteredEvents = events.where((event) {
          return event['title']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _search() {
    _filterEvents(_searchController.text);
  }

  void _deleteEvent(String eventId) {
    setState(() {
      events.removeWhere((event) => event['id'] == eventId);
      filteredEvents.removeWhere((event) => event['id'] == eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: greyColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Найти вещь...',
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      color: greyColor,
                      fontSize: 18,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search_sharp,
                        color: accentColor,
                      ),
                      onPressed: _search,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2; // По умолчанию 2 столбца

                  if (constraints.maxWidth > 600) {
                    crossAxisCount = 3; // На экранах шире 600px три столбца
                  }
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4; // На экранах шире 900px четыре столбца
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      var event = filteredEvents[index];
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.asset(
                                event['image'],
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                event['title'] ?? 'Без названия',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  color: blackColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                event['address'] ?? 'Без адреса',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 0,
                                  color: greyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
