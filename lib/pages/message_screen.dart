import 'package:chat_app_develop/data/message.dart';
import 'package:chat_app_develop/widgets/message_tile.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final String recepientID;
  final String senderID;
  final String senderName;
  final String lastSignInTime;

  const MessageScreen(
      {Key? key,
      required this.recepientID,
      required this.senderID,
      required this.senderName,
      required this.lastSignInTime})
      : super(key: key);

  //final messageDao = MessageDao();

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            'Chat App ID${widget.senderID} - ID${widget.recepientID} - lastSignInTime ${widget.lastSignInTime}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // отримуємо меседжи з бази
            _getMessageList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                      onChanged: (text) => setState(() {}),
                      onSubmitted: (input) {
                        /// Sending a message to the database.
                        // _sendMessage();
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter new message'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendMessage()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      _sendMessage();
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_canSendMessage()) {
      final message = Message(
          _messageController.text,
          DateTime.now(),
          // senderID
          int.parse(widget.senderID),
          // recipientID
          int.parse(widget.recepientID),
          // senderName
          widget.senderName);
      // widget.messageDao.saveMessage(message);
      saveMessage(message);
      _messageController.clear();
      setState(() {
        // test read data
        //readData();
      });
    }
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          //return MessageWidget(message.text, message.date);

          if ((int.parse(widget.senderID) == message.senderID) &
                  (int.parse(widget.recepientID) == message.recepientID) ||
              (int.parse(widget.senderID) == message.recepientID) &
                  (int.parse(widget.recepientID) == message.senderID)) {
            return MessageTile(
              message: message.text,
              senderName: message.senderName,
              time: message.date,
              sentByMe:
                  message.senderID == int.parse(widget.senderID) ? true : false,
              senderID: message.senderID,
              recepientID: message.recepientID,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  bool _canSendMessage() => _messageController.text.isNotEmpty;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  //Цей код шукає документ JSON у базі даних реального часу під назвою
  // messages. Якщо його не існує, Firebase створить його.

  void saveMessage(Message message) {
    FirebaseDatabase.instance
        .ref()
        .child('messages')
        .push()
        .set(message.toJson());

    // test
    // FirebaseDatabase.instance.ref().child('messages').push().set("hello world");
  }

  Query getMessageQuery() {
    return FirebaseDatabase.instance.ref().child('messages');
  }
}
