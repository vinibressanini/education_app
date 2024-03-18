import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.profilePic,
    required this.bio,
    required this.points,
    required this.fullName,
    required this.groupId,
    required this.enrroledCoursesId,
    required this.following,
    required this.followers,
  });

  factory LocalUser.empty() {
    return LocalUser(
      uid: '',
      email: '',
      profilePic: '',
      bio: '',
      points: 0,
      fullName: '',
      groupId: List.empty(),
      enrroledCoursesId: List.empty(),
      following: List.empty(),
      followers: List.empty(),
    );
  }

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupId;
  final List<String> enrroledCoursesId;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [uid, email];

  @override
  String toString() => 'LocalUser{id : $uid, email : $email, points : $points, '
      'full name: $fullName, bio : $bio}';
}
