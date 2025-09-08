// To parse this JSON data, do
//
//     final getBooking = getBookingFromJson(jsonString);

import 'dart:convert';

GetBooking getBookingFromJson(String str) =>
    GetBooking.fromJson(json.decode(str));

String getBookingToJson(GetBooking data) => json.encode(data.toJson());

class GetBooking {
  String message;
  List<Datum> data;

  GetBooking({required this.message, required this.data});

  factory GetBooking.fromJson(Map<String, dynamic> json) => GetBooking(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String userId;
  String serviceId;
  DateTime bookingTime;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Service service;

  Datum({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.bookingTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    bookingTime: DateTime.parse(json["booking_time"]),
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    service: Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_id": serviceId,
    "booking_time": bookingTime.toIso8601String(),
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "service": service.toJson(),
  };
}

class Service {
  int id;
  String name;
  String description;
  String price;
  DateTime createdAt;
  DateTime updatedAt;
  String employeeName;
  String? employeePhoto;
  String servicePhoto;
  String? employeePhotoUrl;
  String servicePhotoUrl;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.employeeName,
    required this.employeePhoto,
    required this.servicePhoto,
    required this.employeePhotoUrl,
    required this.servicePhotoUrl,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    employeeName: json["employee_name"],
    employeePhoto: json["employee_photo"],
    servicePhoto: json["service_photo"],
    employeePhotoUrl: json["employee_photo_url"],
    servicePhotoUrl: json["service_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "employee_name": employeeName,
    "employee_photo": employeePhoto,
    "service_photo": servicePhoto,
    "employee_photo_url": employeePhotoUrl,
    "service_photo_url": servicePhotoUrl,
  };
}
