import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.groupIds = const [],
    this.enrolledCoursesId = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePic,
    this.bio,
  });

  factory LocalUser.empty() {
    return const LocalUser(
      uid: '',
      email: '',
      profilePic: '',
      bio: '',
      points: 0,
      fullName: '',
    );
  }

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCoursesId;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [
        uid,
        email,
        profilePic,
        bio,
        points,
        fullName,
        groupIds.length,
        enrolledCoursesId.length,
        followers.length,
        following.length,
      ];

  @override
  String toString() => 'LocalUser{id : $uid, email : $email, points : $points, '
      'full name: $fullName, bio : $bio}';
}
