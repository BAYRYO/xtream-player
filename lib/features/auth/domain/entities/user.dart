import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String? password;
  final String? authToken;
  final DateTime? expireDate;
  final bool isTrial;
  final bool isActive;
  final int activeConnections;
  final String? serverUrl;
  final String? status;

  const User({
    required this.id,
    required this.username,
    this.password,
    this.authToken,
    this.expireDate,
    this.isTrial = false,
    this.isActive = true,
    this.activeConnections = 0,
    this.serverUrl,
    this.status,
  });

  bool get isExpired {
    if (expireDate == null) return false;
    return DateTime.now().isAfter(expireDate!);
  }

  int? get daysUntilExpiry {
    if (expireDate == null) return null;
    return expireDate!.difference(DateTime.now()).inDays;
  }

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? authToken,
    DateTime? expireDate,
    bool? isTrial,
    bool? isActive,
    int? activeConnections,
    String? serverUrl,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      authToken: authToken ?? this.authToken,
      expireDate: expireDate ?? this.expireDate,
      isTrial: isTrial ?? this.isTrial,
      isActive: isActive ?? this.isActive,
      activeConnections: activeConnections ?? this.activeConnections,
      serverUrl: serverUrl ?? this.serverUrl,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        password,
        authToken,
        expireDate,
        isTrial,
        isActive,
        activeConnections,
        serverUrl,
        status,
      ];
}
