import 'package:chat_app_develop/helper/helper_function.dart';
import 'package:chat_app_develop/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login function
  Future loginWithUserEmailandPassword(String email, String password) async {
    try {
      //
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      // проверка
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // debugPrint(e.toString());
      return e.message;
    }
  }

  // функція реєстрації користувача в БД
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password, String userID) async {
    try {
      //
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      // проверка
      if (user != null) {
        // виклик фукції запиту до нашої служби бази даних,
        // щоб оновити дані користувача
        // call our database service to update the user data
        await DatabaseService(uid: user.uid)
            .savingUserData(fullName, email, userID);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // debugPrint(e.toString());
      return e.message;
    }
  }

  // вихід з застосунку
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF('');
      await HelperFunctions.saveUserNameSF('');
      await HelperFunctions.saveUserIDSF('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
