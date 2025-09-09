import 'package:barber/data/api/booking_api.dart';
import 'package:flutter/material.dart';
import 'package:barber/model/booking/get_booking.dart';

class AdminBookingPage extends StatefulWidget {
  const AdminBookingPage({super.key});

  @override
  State<AdminBookingPage> createState() => _AdminBookingPageState();
}

class _AdminBookingPageState extends State<AdminBookingPage> {
  late Future<List<Datum>> futureBookings;
  bool _isLoading = false;
  Map<int, bool> _updatingStatus = {};
  String _filterStatus = 'all'; // Filter status

  @override
  void initState() {
    super.initState();
    _loadAllBookings();
  }

  void _loadAllBookings() {
    setState(() {
      // GUNAKAN METHOD BARU UNTUK ADMIN
      futureBookings = BookingApiService.getBookingHistory();
    });
  }

  Future<void> _updateStatus(int bookingId, String newStatus) async {
    setState(() {
      _updatingStatus[bookingId] = true;
    });

    debugPrint("🎯 Update status booking: $bookingId -> $newStatus");

    bool success = await BookingApiService.updateBookingStatus(
      id: bookingId,
      status: newStatus,
    );

    setState(() {
      _updatingStatus[bookingId] = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Status berhasil diupdate ke $newStatus"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      _loadAllBookings(); // Reload data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Gagal update status"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String statusText;

    switch (status.toLowerCase()) {
      case "confirmed":
        color = Colors.green;
        statusText = "Dikonfirmasi";
        break;
      case "cancelled":
        color = Colors.red;
        statusText = "Dibatalkan";
        break;
      case "pending":
        color = Colors.orange;
        statusText = "Menunggu";
        break;
      case "completed":
        color = Colors.blue;
        statusText = "Selesai";
        break;
      default:
        color = Colors.grey;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required bool isCurrentStatus,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: isCurrentStatus || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(80, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  // Filter bookings berdasarkan status
  List<Datum> _filterBookings(List<Datum> bookings) {
    if (_filterStatus == 'all') return bookings;
    return bookings
        .where((booking) => booking.status == _filterStatus)
        .toList();
  }

  Widget _buildFilterChip(String status, String label) {
    return FilterChip(
      label: Text(label),
      selected: _filterStatus == status,
      onSelected: (selected) {
        setState(() {
          _filterStatus = selected ? status : 'all';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Booking"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadAllBookings,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'Semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip('pending', 'Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('confirmed', 'Confirmed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('cancelled', 'Cancelled'),
                  const SizedBox(width: 8),
                  _buildFilterChip('completed', 'Completed'),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Bookings List
          Expanded(
            child: FutureBuilder<List<Datum>>(
              future: futureBookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 50),
                        const SizedBox(height: 16),
                        Text(
                          "Error: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAllBookings,
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada booking",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final allBookings = snapshot.data!;
                final filteredBookings = _filterBookings(allBookings);

                if (filteredBookings.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ada booking dengan status '$_filterStatus'",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _loadAllBookings();
                    await futureBookings;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      final isUpdating = _updatingStatus[booking.id] ?? false;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header dengan ID dan Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ID: ${booking.id}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  _buildStatusBadge(booking.status),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Informasi User
                              const Text(
                                "User Info:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text("User ID: ${booking.userId}"),
                              const SizedBox(height: 8),

                              // Informasi Service
                              const Text(
                                "Service:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(booking.service.name),
                              Text("Rp ${booking.service.price}"),
                              const SizedBox(height: 8),

                              // Waktu Booking
                              const Text(
                                "Waktu Booking:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(_formatDateTime(booking.bookingTime)),
                              const SizedBox(height: 12),

                              const Divider(),

                              // Tombol Aksi
                              const Text(
                                "Ubah Status:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildActionButton(
                                    text: "Confirm",
                                    color: Colors.green,
                                    isCurrentStatus:
                                        booking.status == "confirmed",
                                    isLoading: isUpdating,
                                    onPressed: () =>
                                        _updateStatus(booking.id, "confirmed"),
                                  ),
                                  _buildActionButton(
                                    text: "Cancel",
                                    color: Colors.red,
                                    isCurrentStatus:
                                        booking.status == "cancelled",
                                    isLoading: isUpdating,
                                    onPressed: () =>
                                        _updateStatus(booking.id, "cancelled"),
                                  ),
                                  _buildActionButton(
                                    text: "Pending",
                                    color: Colors.orange,
                                    isCurrentStatus:
                                        booking.status == "pending",
                                    isLoading: isUpdating,
                                    onPressed: () =>
                                        _updateStatus(booking.id, "pending"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
