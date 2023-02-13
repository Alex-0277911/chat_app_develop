import 'package:chat_app_develop/helper/helper_function.dart';
import 'package:chat_app_develop/pages/auth/login_page.dart';
import 'package:chat_app_develop/pages/profile_pages.dart';
import 'package:chat_app_develop/service/auth_service.dart';
import 'package:chat_app_develop/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // индикатор загрузки, т.е пока данные грузятся то переменная false, а
  // коли загрузилися то true, використовуємо для відображення чи загрузки
  // чи вже основного віджета программи
  bool _isLoading = false;
  // ключ формы
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  String userID = '';
  // реєструємо службу ідентифікації
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // индикатор загрузки, т.е пока данные грузятся то переменная false, а
      // коли загрузилися то true, використовуємо для відображення чи загрузки
      // чи вже основного віджета программи
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'ChatAPP',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Create your account now to chat and explore',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Image.asset(
                          'assets/register.png',
                          width: 200,
                          height: 200,
                        ),
                        // текстова форма імені повного
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Full Name',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          // проверка вводимого текста
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Name cannot be empty';
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        // текстова форма ID (цифрового), можливо вводити
                        // тільки цифри в кількості 4 шт.
                        TextFormField(
                            maxLength: 4,
                            // вмикаємо цифрову клавіатуру
                            keyboardType: TextInputType.number,
                            // фыльтруэмо ввод тільки цифри
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            decoration: textInputDecoration.copyWith(
                                labelText: 'User ID: 4 digits',
                                prefixIcon: Icon(
                                  Icons.numbers,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) {
                              setState(() {
                                userID = value;
                                //debugPrint(userID);
                              });
                            },
                            // проверка вводимого текста
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Invalid user ID!";
                              }
                              if (value.length > 6 || value.length < 4) {
                                return "Please enter ONLY 4 digits!";
                              }
                            }),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              //debugPrint(email);
                            });
                          },
                          // проверка вводимого текста
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : 'Please enter a valid email';
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                              debugPrint(password);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              register();
                            },
                            child: const Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Login now',
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  debugPrint('Press Login now text');
                                  nextScreen(context, const LoginPage());
                                },
                            )
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    //debugPrint('On press button Register');
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password, userID)
          .then((value) async {
        if (value == true) {
          // збереження стану спільних налаштувань
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserIDSF(userID);
          nextScreenReplace(context, ProfilePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
