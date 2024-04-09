import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersistentView extends StatefulWidget {
  const PersistentView({super.key, this.body});

  final Widget? body;

  @override
  State<PersistentView> createState() => _PersistentViewState();
}

class _PersistentViewState extends State<PersistentView>
    with AutomaticKeepAliveClientMixin<PersistentView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentItem.child;
  }

  @override
  bool get wantKeepAlive => true;
}
