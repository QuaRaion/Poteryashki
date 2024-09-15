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
  bool _isLostSelected = true; // Флаг для переключателя

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Инициализация базы данных и получение записей
  Future<void> _initializeDatabase() async {
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
      List<Map<String, dynamic>> fetchedEvents;

      if (_isLostSelected) {
        fetchedEvents = await db.getRowsLost();
      } else {
        fetchedEvents = await db.getRowsFind();
      }

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
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
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
            // Переключатель "потерянные" и "найденные"
            ToggleButtons(
              isSelected: [_isLostSelected, !_isLostSelected],
              onPressed: (int index) {
                setState(() {
                  _isLostSelected = index == 0;
                  _fetchDataFromDatabase();
                });
              },
              borderRadius: BorderRadius.circular(12),
              borderColor: greyColor,
              fillColor: accentColor,
              selectedColor: whiteColor,
              color: greyColor,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text('Потерянные', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,),
                    ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text('Найденные', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxCrossAxisExtent = 200;

                  if (constraints.maxWidth > 600) {
                    maxCrossAxisExtent = 300;
                  }
                  if (constraints.maxWidth > 900) {
                    maxCrossAxisExtent = 400;
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: maxCrossAxisExtent, // Максимальная ширина карточки
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
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
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: Card(
                            color: whiteColor,
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: Image.network(
                                    thing['image'] ?? 'assets/img/default.png',
                                    height: 120, // Ограничиваем высоту изображения
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/img/default.png',
                                        height: 120, // Ограничиваем высоту изображения по умолчанию
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
                                    maxLines: 1,
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
                        ),
                      );

                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
