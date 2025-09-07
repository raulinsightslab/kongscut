import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barber/model/booking/add_booking_model.dart';
import 'package:barber/services/api/endpoint/endpoint.dart';
import 'package:barber/services/local/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingAPI {
  // POST booking
  static Future<AddBooking> createBooking({
    required int userId,
    required int serviceId,
    required DateTime bookingTime,
  }) async {
    final token = await PreferenceHandler.getToken(); // ambil token user login
    final url = Uri.parse(Endpoint.booking);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "user_id": userId,
        "service_id": serviceId,
        "booking_time": bookingTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddBooking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create booking: ${response.body}");
    }
  }
}
