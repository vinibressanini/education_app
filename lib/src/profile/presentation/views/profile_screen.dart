import 'package:education_app/core/common/views/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/profile/presentation/refactor/profile_body.dart';
import 'package:education_app/src/profile/presentation/refactor/profile_header.dart';
import 'package:education_app/src/profile/presentation/widgets/profile_appbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ProfileAppbar(),
      body: GradientBackground(
        image: MediaRes.profileGradientBackground,
        child: Column(
          children: [
            ProfileHeader(),
            ProfileBody(),
          ],
        ),
      ),
    );
  }
}
