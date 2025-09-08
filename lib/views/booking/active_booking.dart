import 'package:barber/data/api/booking_api.dart';
import 'package:barber/model/booking/get_booking.dart';
import 'package:barber/widget/booking_step_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingActivePage extends StatefulWidget {
  const BookingActivePage({super.key});

  @override
  State<BookingActivePage> createState() => _BookingActivePageState();
}

class _BookingActivePageState extends State<BookingActivePage> {
  late Future<List<Datum>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = BookingApiService.getBookingHistory();
  }

  int _mapStatusToStep(String status) {
    switch (status.toLowerCase()) {
      case "booked":
        return 0;
      case "pending":
        return 1;
      case "confirmed":
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Datum>>(
      future: _futureBookings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("❌ Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada booking aktif"));
        }

        // filter status = pending / confirmed
        final bookings = snapshot.data!
            .where(
              (b) =>
                  b.status.toLowerCase() == "pending" ||
                  b.status.toLowerCase() == "confirmed",
            )
            .toList();

        if (bookings.isEmpty) {
          return const Center(child: Text("Belum ada booking aktif"));
        }

        // ambil booking pertama untuk stepper (atau bisa ambil yg terbaru)
        final currentBooking = bookings.first;

        return Column(
          children: [
            // --- Stepper di atas
            Padding(
              padding: const EdgeInsets.all(16),
              child: BookingStepWidget(
                currentStep: _mapStatusToStep(currentBooking.status),
              ),
            ),
            const Divider(),

            // --- List Booking
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final service = booking.service;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Header Service
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  service.servicePhotoUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Rp ${service.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // --- Info Booking
                          Text(
                            "Dipesan: ${DateFormat('dd MMM yyyy, HH:mm').format(booking.bookingTime)}",
                          ),
                          Text("Status: ${booking.status}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
