import 'dart:io';

import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoreUtils {
  CoreUtils._();

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 8,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colours.primaryColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static void showModalLoader(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  static Future<File?> pickImage() async {
    final galleryImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      return File(galleryImage.path);
    }
    return null;
  }
}
