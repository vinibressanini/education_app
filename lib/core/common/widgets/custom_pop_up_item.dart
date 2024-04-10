import 'package:flutter/material.dart';

class CustomPopUpItem extends StatelessWidget {
  const CustomPopUpItem({required this.icon, required this.label, super.key});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Icon(icon),
      ],
    );
  }
}
