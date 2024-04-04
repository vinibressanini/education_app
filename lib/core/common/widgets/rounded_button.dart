import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.onPressed,
    required this.label,
    this.buttonColor,
    this.labelColor,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final Color? buttonColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colours.primaryColour,
        foregroundColor: labelColor ?? Colors.white,
        minimumSize: const Size(
          double.maxFinite,
          50,
        ),
      ),
      child: Text(label),
    );
  }
}
