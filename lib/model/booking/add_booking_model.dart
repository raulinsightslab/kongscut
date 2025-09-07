// To parse this JSON data, do
//
//     final addBooking = addBookingFromJson(jsonString);

import 'dart:convert';

AddBooking addBookingFromJson(String str) =>
    AddBooking.fromJson(json.decode(str));

String addBookingToJson(AddBooking data) => json.encode(data.toJson());

class AddBooking {
  String message;
  Data data;

  AddBooking({required this.message, required this.data});

  factory AddBooking.fromJson(Map<String, dynamic> json) =>
      AddBooking(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int userId;
  int serviceId;
  DateTime bookingTime;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.serviceId,
    required this.bookingTime,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    serviceId: json["service_id"],
    bookingTime: DateTime.parse(json["booking_time"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "service_id": serviceId,
    "booking_time": bookingTime.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
