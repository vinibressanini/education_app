import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.numberOfExams,
    required this.numberOfMaterials,
    required this.numberOfVideos,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.image,
    this.imageIsFile = false,
  });

  factory Course.empty() {
    return Course(
      id: '',
      title: '',
      numberOfExams: 0,
      numberOfMaterials: 0,
      numberOfVideos: 0,
      groupId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<String> get props => [id];

  final String id;
  final String title;
  final String? description;
  final int numberOfExams;
  final int numberOfMaterials;
  final int numberOfVideos;
  final String groupId;
  final String? image;
  final bool imageIsFile;
  final DateTime createdAt;
  final DateTime updatedAt;
}
