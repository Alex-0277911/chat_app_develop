import 'package:chat_app_develop/helper/helper_function.dart';
import 'package:chat_app_develop/pages/auth/login_page.dart';
import 'package:chat_app_develop/pages/profile_pages.dart';
import 'package:chat_app_develop/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // проверяем платформу
  if (kIsWeb) {
    // запускаем initializeApp для web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId,
            authDomain: Constants.authDomain,
            databaseURL: Constants.databaseURL,
            storageBucket: Constants.storageBucket));
  } else {
    // запускаем initializeApp для android
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userName = '';
  String email = '';
  String userID = '';
  // пользователь вошел в приложение или нет
  bool _isSignedIn = false;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // статус входа пользователя
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    // вызываем функцию с класса HelperFunctions
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      // если значение не равно ноль
      if (value != null) {
        // изменяем значеине переменной где храним статус входа

        setState(() {
          _isSignedIn = value;
//               Text(auth.currentUser!.uid),
//               Text(auth.currentUser!.metadata.creationTime!.toIso8601String()),
//               Text(
//                   auth.currentUser!.metadata.lastSignInTime!.toIso8601String()),
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      // если пользователь вошел в аппку то показываем домашнюю иначе регистрацию
      home: _isSignedIn ? const ProfilePage() : const LoginPage(),
    );
  }
}





// import 'package:chat_app_develop/auth_gate.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/auth.dart';
// import 'message_list.dart';
// // Import the firebase_core plugin
// import 'package:firebase_core/firebase_core.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Додаток Firebase має бути ініціалізовано перед викликом configureProviders
//   await Firebase.initializeApp();

//   FlutterFireUIAuth.configureProviders([
//     const EmailProviderConfiguration(),
//   ]);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   final double? avatarSize = 300;
//   @override
//   Widget build(BuildContext context) {
//     final auth = FirebaseAuth.instance;

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Chat App',
//       theme: ThemeData(primaryColor: const Color(0xFF3D814A)),
// // кореневий маршрут, який перевіряє стан автентифікації та відображає SignInScreenабо ProfileScreen
// // return MaterialApp(
//       //   initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
//       //   routes: {
//       //     '/sign-in': (context) => SignInScreen(providerConfigs: providerConfigs),
//       //     '/profile': (context) => ProfileScreen(providerConfigs: providerConfigs),
//       //   },
//       // );
//       initialRoute: auth.currentUser == null ? '/' : '/profile',
//       routes: {
//         '/': (context) {
//           return SignInScreen(
//             // немає властивості providerConfigs - замість неї буде
//             // використано глобальну конфігурацію
//             actions: [
//               AuthStateChangeAction<SignedIn>((context, state) {
//                 // вручну змусити навігатор перейти на новий екран (маршрут /profile)
//                 Navigator.pushReplacementNamed(context, '/profile');
//               }),
//             ],
//           );
//         },
//         '/profile': (context) {
//           return ProfileScreen(
//             avatarPlaceholderColor: Colors.blue,
//             avatarShape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(5))),
//             avatarSize: avatarSize,
//             // тут також немає властивості providerConfigs
//             actions: [
//               SignedOutAction((context) {
//                 // вручну змусити навігатор перейти на новий екран (маршрут /)
//                 Navigator.pushReplacementNamed(context, '/');
//               }),
//             ],
//             children: [
//               Text(auth.currentUser!.displayName!),
//               Text(auth.currentUser!.uid),
//               Text(auth.currentUser!.metadata.creationTime!.toIso8601String()),
//               Text(
//                   auth.currentUser!.metadata.lastSignInTime!.toIso8601String()),
//               // TextField(controller: emailCtrl),
//               Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // вручну змусити навігатор перейти на новий екран повідомлень
//                       Navigator.pushReplacementNamed(context, '/message');
//                     },
//                     child: const Text('Messages'),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//         '/message': (context) => MessageScreen(),
//       },
//     );
//   }
// }

// // @override
// // Widget build(BuildContext context) {
// //   return MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     title: 'Chat App',
// //     theme: ThemeData(primaryColor: const Color(0xFF3D814A)),
// //     home: const AuthGate(),
// //     //home: MessageList(),
// //   );
// // }
