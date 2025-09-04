// To parse this JSON data, do
//
//     final getServices = getServicesFromJson(jsonString);

import 'dart:convert';

GetServices getServicesFromJson(String str) =>
    GetServices.fromJson(json.decode(str));

String getServicesToJson(GetServices data) => json.encode(data.toJson());

class GetServices {
  String message;
  List<DetailServices> data;

  GetServices({required this.message, required this.data});

  factory GetServices.fromJson(Map<String, dynamic> json) => GetServices(
    message: json["message"],
    data: List<DetailServices>.from(
      json["data"].map((x) => DetailServices.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DetailServices {
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

  DetailServices({
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

  factory DetailServices.fromJson(Map<String, dynamic> json) => DetailServices(
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
