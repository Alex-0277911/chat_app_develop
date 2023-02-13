// import 'message_widget.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'data/message.dart';
// import 'data/message_dao.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class MessageScreenList extends StatefulWidget {
//   MessageScreenList({Key? key}) : super(key: key);

//   final messageDao = MessageDao();

//   @override
//   MessageScreenListState createState() => MessageScreenListState();
// }

// class MessageScreenListState extends State<MessageScreenList> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             // вручну змусити навігатор перейти на новий екран (маршрут /profile)
//             Navigator.pushReplacementNamed(context, '/profile');
//           },
//         ),
//         title: const Text('Chat App'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _getMessageList(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: TextField(
//                       keyboardType: TextInputType.text,
//                       controller: _messageController,
//                       onChanged: (text) => setState(() {}),
//                       onSubmitted: (input) {
//                         _sendMessage();
//                       },
//                       decoration:
//                           const InputDecoration(hintText: 'Enter new message'),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                     icon: Icon(_canSendMessage()
//                         ? CupertinoIcons.arrow_right_circle_fill
//                         : CupertinoIcons.arrow_right_circle),
//                     onPressed: () {
//                       _sendMessage();
//                     })
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendMessage() {
//     if (_canSendMessage()) {
//       final message = Message(
//         _messageController.text,
//         DateTime.now(),
//         // senderID
//         2144,
//         // recipientID
//         1111,
//         //
//       );
//       widget.messageDao.saveMessage(message);
//       _messageController.clear();
//       setState(() {
//         // test read data
//         //readData();
//       });
//     }
//   }

//   Widget _getMessageList() {
//     return Expanded(
//       child: FirebaseAnimatedList(
//         controller: _scrollController,
//         query: widget.messageDao.getMessageQuery(),
//         itemBuilder: (context, snapshot, animation, index) {
//           final json = snapshot.value as Map<dynamic, dynamic>;
//           final message = Message.fromJson(json);
//           return MessageWidget(message.text, message.date);
//         },
//       ),
//     );
//   }

//   bool _canSendMessage() => _messageController.text.isNotEmpty;

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   }
// }
