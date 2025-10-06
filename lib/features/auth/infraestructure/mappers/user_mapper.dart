import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static UserEntity fromJsonToEntity(Map<String, dynamic> json) => UserEntity(
        id: json['id'],
        email: json['email'],
        token: json['token'] ?? '',
        fullName: json['fullName'],
        isActive: json['isActive'],
        roles: List<String>.from(json['roles'] ?? []),
      );
}
