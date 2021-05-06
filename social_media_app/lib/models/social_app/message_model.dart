class MessageModel {
  String senderId;
  String receiverId;
  String dateTime;
  String text;

  MessageModel({this.dateTime, this.text, this.receiverId, this.senderId});

  MessageModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    text = json['text'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'text': text,
      'receiverId': receiverId,
      'senderId': senderId,
    };
  }
}
