// To parse this JSON data, do
//
//     final addServices = addServicesFromJson(jsonString);

import 'dart:convert';

AddServices addServicesFromJson(String str) =>
    AddServices.fromJson(json.decode(str));

String addServicesToJson(AddServices data) => json.encode(data.toJson());

class AddServices {
  String message;
  Data data;

  AddServices({required this.message, required this.data});

  factory AddServices.fromJson(Map<String, dynamic> json) =>
      AddServices(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  String name;
  String description;
  int price;
  String employeeName;
  String employeePhoto;
  String servicePhoto;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String employeePhotoUrl;
  String servicePhotoUrl;

  Data({
    required this.name,
    required this.description,
    required this.price,
    required this.employeeName,
    required this.employeePhoto,
    required this.servicePhoto,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.employeePhotoUrl,
    required this.servicePhotoUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    description: json["description"],
    price: json["price"],
    employeeName: json["employee_name"],
    employeePhoto: json["employee_photo"],
    servicePhoto: json["service_photo"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    employeePhotoUrl: json["employee_photo_url"],
    servicePhotoUrl: json["service_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "employee_name": employeeName,
    "employee_photo": employeePhoto,
    "service_photo": servicePhoto,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "employee_photo_url": employeePhotoUrl,
    "service_photo_url": servicePhotoUrl,
  };
}
