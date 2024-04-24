import 'package:education_app/core/common/views/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/home/presentation/widgets/home_appbar.dart';
import 'package:education_app/src/home/presentation/widgets/home_body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppbar(),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: HomeBody(),
      ),
    );
  }
}
