import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final String? uid;

  // посилання на нашу колекцію USERS
  // яккщо колекція вже існує ми переходимо до неї, але якщо ні то
  // Firebase створить нову колекцію
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final DatabaseReference presenceRef =
      FirebaseDatabase.instance.ref("disconnectmessage");

// Оскільки я можу підключатись з декількох пристроїв, ми зберігаємо кожен екземпляр з'єднання
// екземпляр з'єднання окремо кожного разу, коли значення connectionsRef дорівнює нулю (тобто
// не має дочірніх елементів) Я не в мережі.
  final DatabaseReference myConnectionsRef =
      FirebaseDatabase.instance.ref("users/joe/connections");

// Зберігає мітку часу мого останнього відключення (останній раз, коли мене бачили онлайн)
  final DatabaseReference lastOnlineRef =
      FirebaseDatabase.instance.ref("/users/joe/lastOnline");

  final DatabaseReference connectedRef =
      FirebaseDatabase.instance.ref(".info/connected");

// connectedRef.onValue.listen((event) {
//   final connected = event.snapshot.value as bool? ?? false;
//   if (connected) {
//     debugPrint("Connected.");
//   } else {
//     debugPrint("Not connected.");
//   }
// });
  DatabaseService({this.uid});

// connectedRef.onValue.listen((event) {
//   final connected = event.snapshot.value as bool? ?? false;
//   if (connected) {
//     debugPrint("Connected.");
//   } else {
//     debugPrint("Not connected.");
//   }
// });

  // збереження данних користувача
  Future savingUserData(String fullName, String email, String userID) async {
    //
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'userID': userID,
      'groups': [],
      'profilePic': '',
      'uid': uid,
    });
  }

  // отримання данних користувача
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  // отримання данних користувача по userID
  Future gettingUserDataUserID(String userID) async {
    QuerySnapshot snapshot =
        await userCollection.where('userID', isEqualTo: userID).get();
    return snapshot;
  }
}
