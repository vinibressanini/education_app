import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class TabNavigator extends ChangeNotifier {
  TabNavigator(this._initialPage) {
    _naviagationStack.add(_initialPage);
  }

  final TabItem _initialPage;

  final List<TabItem> _naviagationStack = [];

  int get navigationStackLength => _naviagationStack.length;

  TabItem get currentItem => _naviagationStack.last;

  void push(TabItem page) {
    _naviagationStack.add(page);
    notifyListeners();
  }

  void pop() {
    if (_naviagationStack.length > 1) _naviagationStack.removeLast();
    notifyListeners();
  }

  void popToRoot() {
    _naviagationStack
      ..clear()
      ..add(_initialPage);
    notifyListeners();
  }

  void popTo(TabItem page) {
    _naviagationStack.remove(page);
    notifyListeners();
  }

  void popUntil(TabItem? page) {
    if (page == null) popToRoot();
    if (_naviagationStack.length > 1) {
      _naviagationStack.removeRange(1, _naviagationStack.indexOf(page!) + 1);
    }
    notifyListeners();
  }

  void removeUntil(TabItem page) {
    _naviagationStack
      ..clear()
      ..add(page);
    notifyListeners();
  }
}

class TabItem extends Equatable {
  TabItem({required this.child}) : id = const Uuid().v1();

  final Widget child;
  final String id;

  @override
  List<String> get props => [id];
}
