import 'package:hive/hive.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String avatarId;

  @HiveField(3)
  final bool isMain;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? lastActiveAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.avatarId,
    this.isMain = false,
    required this.createdAt,
    this.lastActiveAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarId: json['avatarId'] ?? 'avatar_1',
      isMain: json['isMain'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      lastActiveAt: json['lastActiveAt'] != null 
          ? DateTime.parse(json['lastActiveAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarId': avatarId,
      'isMain': isMain,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      avatarId: profile.avatarId,
      isMain: profile.isMain,
      createdAt: profile.createdAt,
      lastActiveAt: profile.lastActiveAt,
    );
  }

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      avatarId: avatarId,
      isMain: isMain,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? avatarId,
    bool? isMain,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
      isMain: isMain ?? this.isMain,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
