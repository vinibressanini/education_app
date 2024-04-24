import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/views/persistent_view.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/home/presentation/views/home_screen.dart';
import 'package:education_app/src/profile/presentation/views/profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider<CourseCubit>(
            create: (_) => sl<CourseCubit>(),
            child: const HomeScreen(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const Placeholder(
            child: Center(
              child: Text('DOCUMENTS TAB'),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const Placeholder(
            child: Center(
              child: Text('CHAT TAB'),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const ProfileScreen(),
        ),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 3;

  int get currentIndex => _currentIndex;
  void changeIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }
}
