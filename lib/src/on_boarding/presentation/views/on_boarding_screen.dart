import 'package:education_app/src/on_boarding/presentation/cubits/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          debugPrint(state.toString());
        },
      ),
    );
  }
}
