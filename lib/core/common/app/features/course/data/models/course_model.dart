import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/app/features/course/domain/entities/course.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.numberOfExams,
    required super.numberOfMaterials,
    required super.numberOfVideos,
    required super.groupId,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.image,
    super.imageIsFile = false,
  });

  factory CourseModel.fromMap(DataMap map) {
    return CourseModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      numberOfExams: (map['numberOfExams'] as num).toInt(),
      numberOfMaterials: (map['numberOfMaterials'] as num).toInt(),
      numberOfVideos: (map['numberOfVideos'] as num).toInt(),
      groupId: map['groupId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      image: map['image'] as String?,
    );
  }

  factory CourseModel.empty() => CourseModel(
        id: 'id',
        title: 'title',
        numberOfExams: 0,
        numberOfMaterials: 0,
        numberOfVideos: 0,
        groupId: 'groupId',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        image: 'image',
        description: 'description',
      );

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? groupId,
    int? numberOfExams,
    int? numberOfMaterials,
    int? numberOfVideos,
    String? image,
    bool? imageIsFile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      numberOfExams: numberOfExams ?? this.numberOfExams,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      numberOfVideos: numberOfVideos ?? this.numberOfVideos,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      image: image ?? this.image,
      imageIsFile: imageIsFile ?? this.imageIsFile,
      description: description ?? this.description,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'groupId': groupId,
      'image': image,
      'numberOfExams': numberOfExams,
      'numberOfMaterials': numberOfMaterials,
      'numberOfVideos': numberOfVideos,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
