
import 'dart:convert';

class MessageEntity{

  MessageEntity({
    this.message,
  });

  String message;

  factory MessageEntity.fromJson(Map<String, dynamic> json) => MessageEntity(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
  };
}

List<MessageEntity> messageEntityFromJson(String str) =>
    List<MessageEntity>.from(
        json.decode(str).map((x) => MessageEntity.fromJson(x)));

String messageEntityToJson(List<MessageEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));