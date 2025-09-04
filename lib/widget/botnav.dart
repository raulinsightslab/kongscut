import 'package:barber/utils/utils.dart';
import 'package:barber/views/bookings_page.dart';
import 'package:barber/views/dashboard.dart';
import 'package:barber/views/profile_page.dart';
import 'package:barber/views/services_page.dart';
import 'package:flutter/material.dart';

class Botbar extends StatefulWidget {
  const Botbar({super.key});
  static const id = "/botbar";

  @override
  State<Botbar> createState() => _BotbarState();
}

class _BotbarState extends State<Botbar> {
  int selectedindex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    AddServicesPage(),
    BookingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.offWhite,
        selectedItemColor: AppColors.darkRed,
        unselectedItemColor: AppColors.grey,
        currentIndex: selectedindex,
        onTap: (value) {
          setState(() {
            selectedindex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_cut),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Bookings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// class BotNav extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const BotNav({super.key, required this.currentIndex, required this.onTap});

//   @override
//   State<BotNav> createState() => _BotNavState();
// }

// class _BotNavState extends State<BotNav> {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: widget.currentIndex,
//       onTap: widget.onTap,
//       selectedItemColor: AppColors.darkRed,
//       unselectedItemColor: AppColors.grey,
//       showUnselectedLabels: true,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.content_cut),
//           label: "Services",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_today),
//           label: "Bookings",
//         ),

//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       ],
//     );
//   }
// }
