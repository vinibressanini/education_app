import 'dart:convert';
import 'dart:io';

import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/views/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/profile/presentation/widgets/update_form.dart';
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

    setState(() {
      image = File(galleryImage!.path);
    });
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
      nameChanged ||
      emailChanged ||
      bioChanged ||
      passwordChanged ||
      imageChanged;

  bool get imageChanged => image != null;

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
          context.pop();
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
                onPressed: () {
                  if (!somethingChanged) context.pop();
                  final bloc = context.read<AuthBloc>();
                  if (passwordChanged) {
                    if (oldPasswordController.text.trim().isEmpty) {
                      CoreUtils.showSnackbar(
                        context,
                        'Please enter your old password',
                      );

                      return;
                    }

                    bloc.add(
                      UpdateUserEvent(
                        updateUserAction: UpdateUserAction.password,
                        userData: jsonEncode({
                          'oldPassword': oldPasswordController.text.trim(),
                          'newPassword': passwordController.text.trim(),
                        }),
                      ),
                    );
                  }
                  if (bioChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        updateUserAction: UpdateUserAction.bio,
                        userData: bioController.text.trim(),
                      ),
                    );
                  }
                  if (nameChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        updateUserAction: UpdateUserAction.displsyName,
                        userData: nameController.text.trim(),
                      ),
                    );
                  }
                  if (emailChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        updateUserAction: UpdateUserAction.email,
                        userData: emailController.text.trim(),
                      ),
                    );
                  }

                  if (imageChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        updateUserAction: UpdateUserAction.profilePic,
                        userData: image,
                      ),
                    );
                  }
                },
                child: state is AuthLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          nameController.addListener(() => refresh(() {}));
                          emailController.addListener(() => refresh(() {}));
                          bioController.addListener(() => refresh(() {}));
                          passwordController.addListener(() => refresh(() {}));
                          return Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  somethingChanged ? Colors.blue : Colors.grey,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          body: GradientBackground(
            image: MediaRes.authGradientBackground,
            child: ListView(
              children: [
                Builder(
                  builder: (context) {
                    final currentUser = context.read<UserProvider>().user;
                    final userImage = currentUser!.profilePic == null ||
                            currentUser.profilePic!.isEmpty
                        ? null
                        : currentUser.profilePic!;
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: image != null
                          ? FileImage(image!)
                          : userImage != null
                              ? NetworkImage(userImage)
                              : const AssetImage(MediaRes.user)
                                  as ImageProvider,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(.1),
                            ),
                          ),
                          Align(
                            child: IconButton(
                              onPressed: pickImage,
                              icon: Icon(
                                userImage != null || image != null
                                    ? Icons.edit
                                    : Icons.add_a_photo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    'We recommend an image of at least 400x400',
                    style: TextStyle(
                      color: Color(0xff777e90),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                UpdateForm(
                  bioController: bioController,
                  nameController: nameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  oldPasswordController: oldPasswordController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
