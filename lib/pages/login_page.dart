import 'package:flutter/material.dart';
import 'package:vers2/design/colors.dart';
import '../function/navigation.dart';
import 'signup.dart';
import '../function/new_password.dart';
import 'database.dart';
import 'package:postgres/postgres.dart';

int? userID;
String? number;
String? userName;
int? avatar;
String? userEmail;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
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
                        FocusScope.of(context).unfocus();

                        final conn = PostgreSQLConnection(
                          '123.45.67.890',
                          5432,
                          'Poteryashki',
                          username: '***',
                          password: '***',
                        );
                        final db = Database(conn);
                        await db.open();

                        String email = _emailController.text;
                        String password = _passwordController.text;

                        int isValidUser = await db.checkUserLogin(email, password);

                        if (isValidUser == 0) {

                          userID = await db.getUserIdByEmail(email);
                          number = await db.getUserNumberByEmail(email);
                          userName = await db.getUserNameByEmail(email);
                          avatar = await db.getUserAvatarByEmail(email);
                          userEmail = _emailController.text;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Navigation(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ошибка ввода почты или пароля!\n'
                                    'Попробуйте еще раз',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              backgroundColor: redColor,
                            ),
                          );
                        }
                        await db.close();
                      },

                      color: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Войти",
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
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
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     const Text(
                    //       "Забыли пароль? ",
                    //       style: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 18,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => const NewPasswordPage()),
                    //         );
                    //       },
                    //       child: const Text(
                    //         "Восстановить",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 18,
                    //           color: blackColor,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 50),
                    ),
                  ],
                ),
              ),
            )
          ],
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