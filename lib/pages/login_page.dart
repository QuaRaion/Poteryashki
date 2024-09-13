import 'package:flutter/material.dart';
import 'package:vers2/design/colors.dart';
import 'package:vers2/pages/home_page.dart';
import 'navigation.dart';
import 'signup.dart';
import 'database.dart';
import 'package:postgres/postgres.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: accentColor),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 120),
                          ),
                          Image.asset(
                            'assets/img/logo.png',
                            width: 100,
                            height: 100,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          const Text("Вход",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: blackColor,
                                  fontWeight: FontWeight.bold)),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 30),
                          )
                        ],
                      ),
                      // Поле ввода для email
                      buildLoginTextField('Логин', _emailController),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      // Поле ввода для пароля
                      buildTextField('Пароль', _passwordController),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      MaterialButton(
                        minWidth: 150,
                        height: 60,
                        onPressed: () async {
                          final conn = PostgreSQLConnection(
                              '212.67.14.125',
                              5432,
                              'Poteryashki',
                              username: 'postgres',
                              password: 'mWy8*G*y'
                          );
                          final db = Database(conn);
                          await db.open();

                          String email = _emailController.text;
                          String password = _passwordController.text;

                          int isValidUser = await db.checkUserLogin(email, password);

                          if (isValidUser == 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Navigation(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Неверный логин или пароль'))
                            );
                          }
                        },
                        color: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: const Text(
                          "Войти",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Нет аккаунта? ",
                            style: TextStyle(
                              color: greyColor,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpPage()),
                                );
                              },
                              child: const Text(
                                "Зарегистрироваться",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginTextField(String hintText, TextEditingController controller) {
    return Container(
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
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: greyColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Container(
      height: 60,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
        child: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(color: greyColor, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
