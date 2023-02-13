class Message {
  final String text;
  final String senderName;
  final DateTime date;
  final int senderID;
  final int recepientID;

  Message(
      this.text, this.date, this.senderID, this.recepientID, this.senderName);

  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String,
        senderName = json['senderName'] as String,
        senderID = json['senderID'] as int,
        recepientID = json['recipientID'] as int;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'text': text,
        'senderID': senderID,
        'recipientID': recepientID,
        'senderName': senderName,
      };
}
