import 'dart:io';

import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  File? image;

  Future<void> pickImage() async {
    final galleryImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (galleryImage != null) {
      image = File(galleryImage.path);
    }
  }

  bool get nameChanged =>
      context.read<UserProvider>().user?.fullName.trim() !=
      nameController.text.trim();

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get bioChanged =>
      context.read<UserProvider>().user?.bio?.trim() !=
      bioController.text.trim();

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get somethingChanged =>
      nameChanged || emailChanged || bioChanged || passwordChanged;

  @override
  void initState() {
    final user = context.currentUser;
    nameController.text = user!.fullName.trim();
    bioController.text = user.bio?.trim() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackbar(context, 'User Successfully Updated');
        } else if (state is AuthError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (_, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const NestedBackButton(),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: state is AuthLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: somethingChanged ? Colors.blue : Colors.grey,
                        ),
                      ),
              ),
            ],
          ),
          body: Container(),
        );
      },
    );
  }
}
