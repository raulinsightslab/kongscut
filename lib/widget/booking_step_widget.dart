import 'package:flutter/material.dart';

class BookingStepWidget extends StatelessWidget {
  final int currentStep; // 0 = Booked, 1 = Pending, 2 = Confirmed

  const BookingStepWidget({super.key, required this.currentStep});

  Widget _buildStep({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? Colors.orange : Colors.grey.shade300,
          child: Icon(icon, color: isActive ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.orange : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool active) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20), // biar sejajar sama icon
        height: 3,
        color: active ? Colors.orange : Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildStep(
          icon: Icons.calendar_today,
          label: "Booked",
          isActive: currentStep >= 0,
        ),
        _buildDivider(currentStep >= 1),
        _buildStep(
          icon: Icons.access_time,
          label: "Pending",
          isActive: currentStep >= 1,
        ),
        _buildDivider(currentStep >= 2),
        _buildStep(
          icon: Icons.check_circle,
          label: "Confirmed",
          isActive: currentStep >= 2,
        ),
      ],
    );
  }
}
