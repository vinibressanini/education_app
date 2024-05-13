import 'package:equatable/equatable.dart';

class Group extends Equatable {
  const Group({
    required this.id,
    required this.name,
    required this.courseId,
    required this.members,
    this.lastMessage,
    this.groupImageUrl,
    this.lastMessageSenderName,
    this.lastMessageTimestamp,
  });

  factory Group.empty() {
    return const Group(
      id: 'id',
      name: 'name',
      courseId: 'courseId',
      members: [],
    );
  }

  @override
  List<String> get props => [id, name, courseId];

  final String id;
  final String name;
  final List<String> members;
  final String courseId;
  final String? lastMessage;
  final String? groupImageUrl;
  final DateTime? lastMessageTimestamp;
  final String? lastMessageSenderName;
}
