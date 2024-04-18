import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/extensions/string_extension.dart';
import 'package:education_app/src/profile/presentation/widgets/update_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateForm extends StatelessWidget {
  const UpdateForm({
    required this.nameController,
    required this.emailController,
    required this.bioController,
    required this.passwordController,
    required this.oldPasswordController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>();
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UpdateFormField(
              fieldTitle: 'FULL NAME',
              controller: nameController,
              hintText: 'lorem ipsum',
            ),
            UpdateFormField(
              fieldTitle: 'E-MAIL',
              controller: emailController,
              hintText: currentUser.user!.email.obscureInfo(),
            ),
            UpdateFormField(
              fieldTitle: 'CURRENT PASSWORD',
              controller: oldPasswordController,
              hintText: '******',
            ),
            StatefulBuilder(
              builder: (_, setState) {
                oldPasswordController.addListener(
                  () => setState(() {}),
                );
                return UpdateFormField(
                  fieldTitle: 'NEW PASSWORD',
                  controller: passwordController,
                  readOnly: oldPasswordController.text.isEmpty,
                  hintText: '******',
                );
              },
            ),
            UpdateFormField(
              fieldTitle: 'BIO',
              controller: bioController,
              hintText: 'I love learning :)',
            ),
          ],
        ),
      ),
    );
  }
}
