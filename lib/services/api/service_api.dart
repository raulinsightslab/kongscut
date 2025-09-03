import 'dart:convert';

import 'package:barber/model/get_service.dart';
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
}
