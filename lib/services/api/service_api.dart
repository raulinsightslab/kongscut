import 'dart:convert';
import 'dart:io';

import 'package:barber/model/service/get_service.dart';
import 'package:barber/services/api/endpoint/endpoint.dart';
import 'package:barber/services/local/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPIServices {
  // static Future<AddServices> addServices({
  //   required String email,
  //   required String password,
  //   required String name,
  // }) async {
  //   final url = Uri.parse(Endpoint.services);
  //   final response = await http.post(
  //     url,
  //     body: {"name": name, "email": email, "password": password},
  //     headers: {"Accept": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     return AddServices.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }

  static Future<GetServices> getService() async {
    final url = Uri.parse(Endpoint.services);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetServices.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to get service");
    }
  }

  static Future<void> addService({
    required String name,
    required String description,
    required int price,
    required String employeeName,
    required File employeePhoto,
    required File servicePhoto,
  }) async {
    final uri = Uri.parse(Endpoint.services);
    final token = await PreferenceHandler.getToken();

    var request = http.MultipartRequest('POST', uri);

    // Header (tambahkan token kalau ada login)
    request.headers['Accept'] = 'application/json';
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Field text
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['employee_name'] = employeeName;

    // File upload (pastikan nama field sama persis dengan API backend)
    request.files.add(
      await http.MultipartFile.fromPath('employee_photo', employeePhoto.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath('service_photo', servicePhoto.path),
    );

    // Kirim request
    final response = await request.send();

    // Baca response body
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Service berhasil ditambahkan");
      print("Response: $responseData");
    } else {
      print("❌ Gagal menambahkan service");
      print("Status: ${response.statusCode}");
      print("Response: $responseData");
      throw Exception("Gagal menambahkan service (${response.statusCode})");
    }
  }
}

  // static Future<GetServices> deleteService({required String name}) async {
  //   final url = Uri.parse(Endpoint.services);
  //   final response = await http.delete(
  //     url,
  //     body: {"name": name},
  //     headers: {"Accept": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     return GetServices.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "gagal");
  //   }
  // }

  // static Future<GetUserModel> updateUser({required String name}) async {
  //   final url = Uri.parse(Endpoint.profile);
  //   final response = await http.post(
  //     url,
  //     body: {"name": name},
  //     headers: {"Accept": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     return GetUserModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }

