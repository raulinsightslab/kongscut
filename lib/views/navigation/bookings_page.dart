import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barber/services/api/booking_api.dart';
import 'package:barber/model/booking/add_booking_model.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final TextEditingController _serviceIdController = TextEditingController();
  DateTime? _selectedDateTime;

  bool _isLoading = false;
  String? _message;

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _createBooking() async {
    if (_serviceIdController.text.isEmpty || _selectedDateTime == null) {
      setState(() {
        _message = "Isi semua field terlebih dahulu!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      // contoh: userId ambil dari login (sementara kita set manual 1)
      final booking = await BookingAPI.createBooking(
        userId: 1,
        serviceId: int.parse(_serviceIdController.text),
        bookingTime: _selectedDateTime!,
      );

      setState(() {
        _message = booking.message; // "Layanan berhasil ditambahkan"
      });
    } catch (e) {
      setState(() {
        _message = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _serviceIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Service ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDateTime == null
                        ? "Pilih tanggal & jam booking"
                        : DateFormat(
                            "yyyy-MM-dd HH:mm",
                          ).format(_selectedDateTime!),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text("Pilih"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _createBooking,
                    child: const Text("Booking Sekarang"),
                  ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.toLowerCase().contains("error")
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
