import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.ref();
late final DataSnapshot snapshot;

// У момент натискання кнопки « CreateData » запитується процедура createData().

void createData() {
  databaseReference
      .child("flutterDevsTeam1")
      .set({'name': 'Deepak Nishad', 'description': 'Team Lead'});
  databaseReference.child("flutterDevsTeam2").set(
      {'name': 'Yashwant Kumar', 'description': 'Senior Software Engineer'});
  databaseReference
      .child("flutterDevsTeam3")
      .set({'name': 'Akshay', 'description': 'Software Engineer'});
  databaseReference
      .child("flutterDevsTeam4")
      .set({'name': 'Aditya', 'description': 'Software Engineer'});
  databaseReference
      .child("flutterDevsTeam5")
      .set({'name': 'Shaiq', 'description': 'Associate Software Engineer'});
  databaseReference
      .child("flutterDevsTeam6")
      .set({'name': 'Mohit', 'description': 'Associate Software Engineer'});
  databaseReference
      .child("flutterDevsTeam7")
      .set({'name': 'Naveen', 'description': 'Associate Software Engineer'});
}

// У момент натискання кнопки « Read Data » запитується процедура readData().
// Ми отримаємо всі дані з бази даних і покажемо їх на консолі.
void readData() {
  databaseReference.once().then((snapshot) {
    print('Data : ${snapshot.snapshot.value}');
  });
}

// У момент натискання кнопки « Оновити дані » запитується процедура updateData().
void updateData() {
  databaseReference.child('flutterDevsTeam1').update({'description': 'CEO'});
  databaseReference
      .child('flutterDevsTeam2')
      .update({'description': 'Team Lead'});
  databaseReference
      .child('flutterDevsTeam3')
      .update({'description': 'Senior Software Engineer'});
}

//  У момент натискання кнопки « Видалити дані » запитується процедура deleteData().
//  Щоб видалити дані, ви можете просто викликати метод remove() для посилання на базу даних.
void deleteData() {
  databaseReference.child('flutterDevsTeam1').remove();
  databaseReference.child('flutterDevsTeam2').remove();
  databaseReference.child('flutterDevsTeam3').remove();
}
