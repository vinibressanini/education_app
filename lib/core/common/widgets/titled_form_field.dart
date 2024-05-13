import 'package:education_app/core/common/widgets/i_field.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class TitledFormField extends StatelessWidget {
  const TitledFormField({
    required this.required,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.hintStyle,
    this.hint,
    super.key,
  });

  final bool required;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colours.neutralTextColour,
                ),
                children: [
                  if (required)
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colours.redColour,
                      ),
                    )
                  else
                    const TextSpan(),
                ],
              ),
            ),
            if (suffixIcon != null) suffixIcon! else const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 5),
        IField(
          controller: controller,
          overrideValidator: true,
          validator: (value) {
            if (!required) return null;
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          hintText: hint ?? 'Enter $label',
          hintStyle: hintStyle,
        ),
      ],
    );
  }
}
