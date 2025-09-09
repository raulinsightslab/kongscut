import 'dart:convert';
import 'dart:io';

import 'package:barber/data/api/endpoint/endpoint.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/model/service/add_services_model.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPIServices {
  static Future<GetServices> getService() async {
    final url = Uri.parse(Endpoint.services);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return GetServices.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to get service");
    }
  }

  /// ✅ POST Service baru (pakai Base64 string untuk foto)
  static Future<AddServices?> postService({
    required String name,
    required String description,
    required int price,
    required String employeeName,
    required File servicePhoto,
    required File employeePhoto,
  }) async {
    try {
      final uri = Uri.parse(Endpoint.services);
      final token = await PreferenceHandler.getToken();
      // 🔹 convert file ke base64 string
      String serviceBase64 = base64Encode(await servicePhoto.readAsBytes());
      String employeeBase64 = base64Encode(await employeePhoto.readAsBytes());

      final response = await http.post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: json.encode({
          "name": name,
          "description": description,
          "price": price,
          "employee_name": employeeName,
          "service_photo": serviceBase64, // ✅ string base64
          "employee_photo": employeeBase64, // ✅ string base64
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return addServicesFromJson(response.body);
      } else {
        throw Exception("Gagal upload service: ${response.body}");
      }
    } catch (e) {
      throw Exception("❌ Error postService: $e");
    }
  }

  //Update
  static Future updateService({
    required int id,
    required String name,
    required String description,
    required double price,
    required String employeeName,
    File? servicePhoto,
    File? employeePhoto,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${Endpoint.services}/$id"),
      );

      // Tambahkan header authorization
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Gunakan field names yang sesuai dengan backend (biasanya snake_case)
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['employee_name'] =
          employeeName; // Perhatikan: employee_name bukan employeeName
      request.fields['_method'] =
          'PUT'; // Jika backend memerlukan ini untuk override method

      if (servicePhoto != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'service_photo',
            servicePhoto.path,
          ), // service_photo bukan servicePhoto
        );
      }

      if (employeePhoto != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'employee_photo',
            employeePhoto.path,
          ), // employee_photo bukan employeePhoto
        );
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception(
          "Error updateService: ${response.statusCode}, $resBody",
        );
      }
    } catch (e) {
      throw Exception("❌ Error updateService: $e");
    }
  }

  /// ✅ DELETE Service
  static Future<bool> deleteService(int id) async {
    try {
      final uri = Uri.parse("${Endpoint.services}/$id");
      final token = await PreferenceHandler.getToken();

      final response = await http.delete(
        uri,
        headers: {
          "Accept": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("❌ Error deleteService: $e");
    }
  }
}
