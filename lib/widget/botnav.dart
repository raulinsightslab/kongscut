import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';

class BotNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BotNav({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: AppColors.darkRed,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Bookings",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: "Voucher",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
