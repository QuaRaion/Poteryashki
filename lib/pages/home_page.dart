import 'package:flutter/material.dart';
import '../design/colors.dart';
import 'database.dart';
import 'things_card.dart';
import 'package:postgres/postgres.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PostgreSQLConnection conn;
  late Database db;
  List<Map<String, dynamic>> things = [];
  List<Map<String, dynamic>> filteredThing = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Инициализация базы данных и получение последних 20 записей
  Future<void> _initializeDatabase() async {
    // Настройка подключения
    conn = PostgreSQLConnection(
      '212.67.14.125',
      5432,
      'Poteryashki',
      username: 'postgres',
      password: 'mWy8*G*y',
    );

    db = Database(conn);
    await db.open();
    await _fetchDataFromDatabase();
  }

  Future<void> _fetchDataFromDatabase() async {
    try {
      List<Map<String, dynamic>> fetchedEvents = await db.getRows();

      // Обновляем состояние
      setState(() {
        things = fetchedEvents;
        filteredThing = fetchedEvents;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Фильтрация событий по названию
  void _filterEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredThing = things;
      } else {
        filteredThing = things.where((event) {
          return event['title']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _search() {
    _filterEvents(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          children: <Widget>[
            // Поле поиска
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
                  int crossAxisCount = 2;

                  if (constraints.maxWidth > 600) {
                    crossAxisCount = 3;
                  }
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredThing.length,
                    itemBuilder: (context, index) {
                      var thing = filteredThing[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(thing: thing),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  thing['image'] ?? 'assets/img/default.png',
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/img/default.png',
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  thing['title'] ?? 'Без названия',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  thing['address'] ?? 'Без адреса',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
