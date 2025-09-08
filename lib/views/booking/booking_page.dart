import 'package:barber/views/booking/active_booking.dart';
import 'package:barber/views/booking/history_bookings_page.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Aktif"),
            Tab(text: "Riwayat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [BookingActivePage(), BookingHistoryPage()],
      ),
    );
  }
}
