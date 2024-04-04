import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.bio,
    super.followers,
    super.following,
    super.enrolledCoursesId,
    super.groupIds,
    super.profilePic,
  });

  factory LocalUserModel.fromMap(DataMap map) {
    return switch (map) {
      {
        'uid': final String uid,
        'email': final String email,
        'fullName': final String fullName,
        'points': final int points,
        'bio': final String? bio,
        'profilePic': final String? profilePic,
        'followers': final List<dynamic> followers,
        'following': final List<dynamic> following,
        'groupIds': final List<dynamic> groupIds,
        'enrolledCoursesId': final List<dynamic> enrolledCoursesId,
      } =>
        LocalUserModel(
          uid: uid,
          email: email,
          points: points,
          fullName: fullName,
          bio: bio,
          profilePic: profilePic,
          followers: List<String>.from(followers),
          following: List<String>.from(following),
          groupIds: List<String>.from(groupIds),
          enrolledCoursesId: List<String>.from(enrolledCoursesId),
        ),
      _ => throw ArgumentError('[ERROR] Invalid json $map')
    };
  }

  const LocalUserModel.empty()
      : super(
          uid: '',
          email: '',
          fullName: '',
          points: 0,
        );

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupIds,
    List<String>? enrolledCoursesId,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupIds: groupIds ?? this.groupIds,
      enrolledCoursesId: enrolledCoursesId ?? this.enrolledCoursesId,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  DataMap toMap() => {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'points': points,
        'bio': bio,
        'profilePic': profilePic,
        'followers': followers,
        'following': following,
        'enrolledCoursesId': enrolledCoursesId,
        'groupIds': groupIds,
      };
}
