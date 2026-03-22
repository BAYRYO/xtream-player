import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String avatarId;
  final bool isMain;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const Profile({
    required this.id,
    required this.name,
    required this.avatarId,
    this.isMain = false,
    required this.createdAt,
    this.lastActiveAt,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? avatarId,
    bool? isMain,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
      isMain: isMain ?? this.isMain,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [id, name, avatarId, isMain, createdAt, lastActiveAt];
}
