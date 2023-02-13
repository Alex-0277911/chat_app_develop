// import 'package:chat_app_develop/service/database_service.dart';
// import 'package:chat_app_develop/widgets/message_tile.dart';
// import 'package:chat_app_develop/widgets/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   final String groupId;
//   final String userName;

//   const ChatPage({super.key, required this.groupId, required this.userName});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   // поток чатов
//   Stream<QuerySnapshot>? chats;
//   TextEditingController messageController = TextEditingController();
//   String admin = '';

// // викликається коли сторінка завантажується
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           elevation: 0,
//           title: const Text('groupName'),
//           backgroundColor: Theme.of(context).primaryColor,
//           actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
//         ),
//         body: Stack(
//           children: <Widget>[
//             // сообщения в чате
//             chatMessages(),
//             // контейнер з строкою ввода текста і відправки повідомлення
//             Container(
//               alignment: Alignment.bottomCenter,
//               width: MediaQuery.of(context).size.width,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.grey[700],
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: messageController,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: 'Send a message...',
//                           hintStyle:
//                               TextStyle(color: Colors.white, fontSize: 16),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     GestureDetector(
//                       onTap: () {
//                         sendMessage();
//                       },
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.send,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ));
//   }

//   chatMessages() {
//     return StreamBuilder(
//         stream: chats,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   itemCount: snapshot.data.docs.length,
//                   itemBuilder: (context, index) {
//                     return MessageTile(
//                       message: snapshot.data.docs[index]['message'],
//                       senderName: snapshot.data.docs[index]['sender'],
//                       time: snapshot.data.docs[index]['time'],
//                       sentByMe: widget.userName ==
//                           snapshot.data.docs[index]['sender'],
//                     );
//                   },
//                 )
//               // повертаємо пустий контейнер, коли не має повідомлень
//               : Container();
//         });
//   }

//   sendMessage() {
//     if (messageController.text.isNotEmpty) {
//       Map<String, dynamic> chatMessageMap = {
//         'message': messageController.text,
//         'sender': widget.userName,
//         'time': DateTime.now().millisecondsSinceEpoch,
//       };

//       DatabaseService().sendMessage(widget.groupId, chatMessageMap);
//       setState(() {
//         messageController.clear();
//       });
//     }
//   }
// }
