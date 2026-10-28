import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  final bool success;
  final String message;
  final String accessToken;
  final UserModel user;

  LoginResponseModel({
    required this.message,
    required this.success,
    required this.accessToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message:json['message']??'',
      success:json['success']??false,
      accessToken: json['accessToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "success":success,
    "message":message,
    "user": user.toJson(),
  };
}

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String role;
  final String status;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "displayName": displayName,
    "email": email,
    "role": role,
    "status": status,
  };
}
