import 'package:chat_app_develop/helper/helper_function.dart';
import 'package:chat_app_develop/pages/auth/login_page.dart';
import 'package:chat_app_develop/pages/message_screen.dart';
import 'package:chat_app_develop/service/auth_service.dart';
import 'package:chat_app_develop/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // посилання на нашу колекцію USERS
  // яккщо колекція вже існує ми переходимо до неї, але якщо ні то
  // Firebase створить нову колекцію
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  // String groupName = '';
  String email = '';
  String userName = '';
  String userID = '';

  // ключ формы
  final formKey = GlobalKey<FormState>();
  var controllerChatId = TextEditingController();
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  bool isLoading = false;
  String lastSignInTime = '12:00';

// змінна де зберігаємо номер чату для приєднання
  String chatID = '';

  AuthService authService = AuthService();
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // статус входа пользователя
    gettingUserData();
  }

  // // отримання данних користувача по userID
  // Future gettingUserDataUserID(String userID) async {
  //   QuerySnapshot snapshot =
  //       await userCollection.where('userID', isEqualTo: userID).get();

  //   return snapshot.getString(lastSignInTime);
  // }

  // Future<String?> getUserlastOnlineFromSF() async {
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return sf.getString(lastSignInTime);
  // }

  // gettingUserDataUserID(chatID) async {
  //   await HelperFunctions.getUserlastOnlineFromSF().then((value) {
  //     setState(() {
  //       lastSignInTime = value!;
  //     });
  //   });
  // }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await HelperFunctions.getUserIDFromSF().then((value) {
      setState(() {
        userID = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15),
            Text(
              userID,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
                // authService.signOut().whenComplete(() {
                //   nextScreen(context, const LoginPage());
                // });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Chat App', style: TextStyle(fontSize: 37)),
                  const SizedBox(height: 70),
                  const Icon(
                    Icons.account_box_rounded,
                    size: 200,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'ID: $userID',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                  const SizedBox(height: 50),
                  // им`я користувача
                  Text(userName,
                      style: const TextStyle(
                        fontSize: 25,
                        decoration: TextDecoration.underline,
                      )),
                  const SizedBox(height: 35),
                  // текстова форма ID (цифрового), можливо вводити
                  // тільки цифри в кількості 4 шт.
                  TextFormField(
                      controller: controllerChatId,
                      maxLength: 4,
                      // вмикаємо цифрову клавіатуру
                      keyboardType: TextInputType.number,
                      // фільтруємо ввод тільки цифри
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      decoration: textInputDecoration.copyWith(
                        labelText: 'Enter chat id',
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        // кнопка створення або підключення до існуючого чату
                        suffixIcon: IconButton(
                          onPressed: () {
                            debugPrint('On press button Enter chat id');
                            //groupName = '${widget.userID}-$chatID';
                            // groupScreen();
                            chatID = controllerChatId.value.text;
                            // gettingUserDataUserID(chatID);
                            messageScreen();
                            controllerChatId.clear;
                          },
                          icon: const Icon(Icons.double_arrow),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      // проверка вводимого текста
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Invalid user ID!";
                        }
                        if (value.length > 6 || value.length < 4) {
                          return "Please enter ONLY 4 digits!";
                        }
                        return null;
                      }),
                  Text(auth.currentUser!.metadata.creationTime!
                      .toIso8601String()),
                  Text(auth.currentUser!.metadata.lastSignInTime!
                      .toIso8601String()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // groupScreen() async {
  //   debugPrint('On press button groupScreen');
  //   if (formKey.currentState!.validate()) {
  //     //print('widget.userID ${widget.userID}');
  //     //print('chatID $chatID');
  //     //print('groupName $groupName');
  //     //ищем группу
  //     // пошук зберігаємо в searchSnapshot
  //     await DatabaseService().searchByName(chatID).then((snapshot) {
  //       setState(() {
  //         searchSnapshot = snapshot;
  //       });
  //     });

  //     // перевіряємо результат пошуку
  //     // якщо в пошуку size = 0, то таких груп не має, створюємо нову групу
  //     // і переходимо в цю групу
  //     if (searchSnapshot!.size == 0) {
  //       // створюємо нову групу

  //       DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
  //           .createGroup(
  //               widget.userName, FirebaseAuth.instance.currentUser!.uid, chatID)
  //           .whenComplete(() {
  //         // повідомлення що групу створено
  //         showSnackBar(context, Colors.green, 'Створюємо нову групу');
  //         groupScreen();
  //       });
  //     } else {
  //       // підключаємося до першої групи
  //       DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).groupJoin(
  //         searchSnapshot!.docs[0]['groupId'],
  //         widget.userName,
  //         chatID,
  //       );
  //       showSnackBar(
  //           context, Colors.green, 'Група існує, спробуємо підключитися');
  //       //  переходимо на єкран створеної групи-чату
  //       Future.delayed(const Duration(seconds: 2), () {
  //         nextScreen(
  //             context,
  //             ChatPage(
  //               groupId: searchSnapshot!.docs[0]['groupId'],
  //               groupName: chatID,
  //               userName: widget.userName,
  //             ));
  //       });
  //     }
  //   }
  // }

  messageScreen() {
    if (formKey.currentState!.validate()) {
      //  переходимо на екран чату
      nextScreen(
        context,
        // MessageScreenList(),
        MessageScreen(
          recepientID: chatID,
          senderName: userName,
          senderID: userID,
          lastSignInTime: lastSignInTime,
        ),
      );
    } else {
      showSnackBar(context, Colors.red, 'Невірно введений ID чату');
    }
  }
}
