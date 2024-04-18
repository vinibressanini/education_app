import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  TabNavigator get tabNavigator => read<TabNavigator>();

  void push(TabItem page) => tabNavigator.push(page);

  void pop() => tabNavigator.pop();
}
