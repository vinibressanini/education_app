import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter/foundation.dart';

class CourseOfTheDayProvider extends ChangeNotifier {
  Course? _courseOfTheDay;

  Course? get courseOfTheDay => _courseOfTheDay;

  void changeCourseOfTheDay(Course course) {
    _courseOfTheDay ??= course;
    notifyListeners();
  }
}
