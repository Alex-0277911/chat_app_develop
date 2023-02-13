import 'package:chat_app_develop/message_screen_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // підпискf на стан автентифікації користувачів,
    // який надається як snapshot конструктор Stream
    // знімок міститиме екземпляр User або null
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // Якщо користувач вже зареєстрований, використати його дані як початкові
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // Користувач не ввійшов в систему
        if (!snapshot.hasData) {
          // виводимо екран реєстрації
          return SignInScreen(
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to FlutterFire UI! Please sign in to continue.'
                        : 'Welcome to FlutterFire UI! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              sideBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                        'https://firebase.flutter.dev/img/flutterfire_300x.png'),
                  ),
                );
              },
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                        'https://firebase.flutter.dev/img/flutterfire_300x.png'),
                  ),
                );
              },
              providerConfigs: const [
                // провайдер входу з поштою та паролем
                EmailProviderConfiguration()
              ]);
        }

        // Користувач ввійшов в систему
        // return MessageList();
        return const ProfileScreen(
          providerConfigs: [
            // EmailProviderConfiguration(),
          ],
          avatarSize: 24,
        );
      },
    );
  }
}
