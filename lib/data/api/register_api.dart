import 'dart:convert';

import 'package:barber/data/api/endpoint/endpoint.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/model/user/get_user.dart';
import 'package:barber/model/user/regis_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI {
  static Future<RegisUserModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      body: {"name": name, "email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return RegisUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<RegisUserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final data = RegisUserModel.fromJson(json.decode(response.body));
      await PreferenceHandler.saveToken(data.data.token);
      await PreferenceHandler.saveLogin();
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  // Ambil profile user
  static Future<GetUserModel> getProfile() async {
    final url = Uri.parse(Endpoint.profile);

    // Ambil token dari SharedPreferences
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to load profile");
    }
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

  // static Future<GetUserModel> getProfile() async {
  //   final url = Uri.parse(Endpoint.profile);
  //   final token = await PreferenceHandler.getToken();
  //   final response = await http.get(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": token},
  //   );
  //   if (response.statusCode == 200) {
  //     return GetUserModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }

