import 'package:barber/model/service/get_service.dart';
import 'package:barber/views/booking/form_booking.dart';
import 'package:flutter/material.dart';

class DetailServicePage extends StatefulWidget {
  final DetailServices service;

  const DetailServicePage({super.key, required this.service});

  @override
  State<DetailServicePage> createState() => _DetailServicePageState();
}

class _DetailServicePageState extends State<DetailServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto service
                widget.service.servicePhotoUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.service.servicePhotoUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.image_not_supported, size: 120),

                const SizedBox(height: 20),

                Text(
                  widget.service.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.service.description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Harga:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   rupiahFormatter.format(
                    //     service.price,
                    //   ), // Format harga di sini
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.green,
                    //     fontSize: 16,
                    //   ),
                    // ),
                    Text(widget.service.price),
                  ],
                ),

                Divider(height: 30),

                Row(
                  children: [
                    widget.service.employeePhotoUrl != null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              widget.service.employeePhotoUrl!,
                            ),
                          )
                        : CircleAvatar(radius: 30, child: Icon(Icons.person)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.service.employeeName,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Dibuat: ${widget.service.createdAt.toLocal()}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // buka dialog booking (isi tanggal & jam)
                    final result = await showDialog(
                      context: context,
                      builder: (ctx) =>
                          BookingFormPage(serviceId: widget.service.id),
                    );
                    // kalau user sudah pilih dan submit booking
                    if (result != null && result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Booking untuk ${widget.service.name} berhasil ditambahkan!",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.calendar_today, size: 22),
                  label: const Text(
                    "Booking Sekarang",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
