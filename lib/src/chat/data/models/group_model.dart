import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.groupImageUrl,
    super.lastMessage,
    super.lastMessageSenderName,
    super.lastMessageTimestamp,
  });

  GroupModel.empty()
      : this(
          id: 'id',
          courseId: 'courseId',
          name: 'name',
          members: [],
          groupImageUrl: '',
          lastMessage: '',
          lastMessageSenderName: '',
          lastMessageTimestamp: DateTime.now(),
        );

  GroupModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['courseId'] as String,
          members: List<String>.from(map['members'] as List),
          name: map['name'] as String,
          groupImageUrl: map['groupImageUrl'] as String?,
          lastMessage: map['lastMessage'] as String?,
          lastMessageSenderName: map['lastMessageSenderName'] as String?,
          lastMessageTimestamp:
              (map['lastMessageSenderName'] as Timestamp?)?.toDate(),
        );

  DataMap toMap() => {
        'id': id,
        'name': name,
        'courseId': courseId,
        'members': members,
        'lastMessage': lastMessage,
        'groupImageUrl': groupImageUrl,
        'lastMessageSenderName': lastMessageSenderName,
        'lastMessageTimestamp': lastMessageTimestamp,
      };

  GroupModel copyWith(
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    String? lastMessage,
    String? lastMessageSenderName,
    DateTime? lastMessageTimestamp,
    String? groupImageUrl,
  ) =>
      GroupModel(
        id: id ?? this.id,
        name: name ?? this.name,
        courseId: courseId ?? this.courseId,
        members: members ?? this.members,
        groupImageUrl: groupImageUrl ?? this.groupImageUrl,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageSenderName:
            lastMessageSenderName ?? this.lastMessageSenderName,
        lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      );
}
