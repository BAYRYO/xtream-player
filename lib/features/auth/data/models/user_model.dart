import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    super.password,
    super.authToken,
    super.expireDate,
    super.isTrial,
    super.isActive,
    super.activeConnections,
    super.serverUrl,
    super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username'] ?? '',
      password: json['password'],
      authToken: json['auth_token'],
      expireDate: json['exp_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (int.tryParse(json['exp_date'].toString()) ?? 0) * 1000)
          : null,
      isTrial: json['is_trial'] == '1' || json['is_trial'] == 1 || json['is_trial'] == true,
      isActive: json['status'] == 'Active' || json['status'] == '1' || json['status'] == 1 || json['active'] == 1,
      activeConnections: int.tryParse(json['active_cons']?.toString() ?? '0') ?? 0,
      serverUrl: json['server_url'],
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'auth_token': authToken,
      'exp_date': expireDate?.millisecondsSinceEpoch,
      'is_trial': isTrial ? '1' : '0',
      'status': status,
      'active_cons': activeConnections,
      'server_url': serverUrl,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      password: user.password,
      authToken: user.authToken,
      expireDate: user.expireDate,
      isTrial: user.isTrial,
      isActive: user.isActive,
      activeConnections: user.activeConnections,
      serverUrl: user.serverUrl,
      status: user.status,
    );
  }
}
