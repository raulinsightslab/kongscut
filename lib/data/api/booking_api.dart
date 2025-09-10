import 'dart:convert';

import 'package:barber/data/api/endpoint/endpoint.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/model/booking/add_booking_model.dart';
import 'package:barber/model/booking/get_booking.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingApiService {
  /// ✅ Tambah booking baru
  static Future<AddBooking> addBooking({
    required int serviceId,
    required DateTime bookingTime,
  }) async {
    final url = Uri.parse(Endpoint.booking);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "service_id": serviceId,
        "booking_time": bookingTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // 👇 ini cukup decode sekali aja
      return AddBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception("❌ Gagal booking: ${response.body}");
    }
  }

  /// ✅ Ambil riwayat booking user
  static Future<List<Datum>> getBookingHistory() async {
    final url = Uri.parse(Endpoint.booking); // sesuaikan endpoint riwayat
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final booking = GetBooking.fromJson(decoded);
      return booking.data; // ini List<Datum>
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil riwayat booking");
    }
  }
    /// ✅ Update status booking (Pending -> Confirmed/Cancelled)
  static Future<bool> updateBookingStatus({
    required int id,
    required String status,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      // Endpoint untuk update status - SESUAIKAN DENGAN API ANDA
      final url = Uri.parse("${Endpoint.booking}/$id");
      debugPrint("🌐 URL Update: $url");
      debugPrint("📤 Request Body: {status: $status}");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({"status": status}),
      );

      debugPrint("📊 Status Code: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData["success"] == true ||
            responseData["message"] != null) {
          debugPrint("✅ Status berhasil diupdate");
          return true;
        } else {
          debugPrint("❌ Response tidak menunjukkan success");
          return false;
        }
      } else {
        final error = json.decode(response.body);
        debugPrint("❌ Gagal update status: ${error["message"]}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception saat update status: $e");
      return false;
    }
  }
}


