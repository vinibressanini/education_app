import 'package:education_app/core/common/app/providers/course_of_the_day_provider.dart';
import 'package:education_app/core/common/views/loading_screen.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void getCourses() {
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          CoreUtils.showSnackbar(context, state.message);
        } else if (state is CoursesLoaded && state.courses.isNotEmpty) {
          state.courses.shuffle();
          final courseOfTheDay = state.courses.first;
          context
              .read<CourseOfTheDayProvider>()
              .changeCourseOfTheDay(courseOfTheDay);
        }
      },
      builder: (_, state) {
        if (state is LoadingCourses) {
          return const LoadingScreen();
        } else if (state is CoursesLoaded && state.courses.isEmpty ||
            state is CourseError) {
          return const NotFoundText(
            text: 'No courses found\n'
                " Please contact an admin or if you're"
                ' an admin, add courses',
          );
        } else {
          state as CoursesLoaded;

          final courses = state.courses
            ..sort(
              (a, b) => a.updatedAt.compareTo(b.updatedAt),
            );

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          );
        }
      },
    );
  }
}
