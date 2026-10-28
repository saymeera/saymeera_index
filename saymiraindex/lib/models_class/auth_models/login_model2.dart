import 'dart:convert';

MessageModel2 messageModel2FromJson(String str) =>
    MessageModel2.fromJson(json.decode(str));

String messageModel2ToJson(MessageModel2 data) => json.encode(data.toJson());

class MessageModel2 {
  String id;
  String roleId;
  // bool status;
  // String message;
  //String error;
  String email;
  String username;
  String passwordHash;
  String lastLogin;
  String lastIp;
  String createdOn;
  String deleted;
  String banned;
  String banMessage;
  String displayName;
  String timezone;
  String language;
  String active;
  String activateHash;
  String forcePasswordReset;
  String profileImageName;
  String mobileNo;
  String empDesignation;
  String usrCreatedy;
  String roleName;
  String token;



  MessageModel2({
    required this.id,
    required this.email,
    required this.username,
    required this.activateHash,
    required this.active,
    required this.banMessage,
    required  this.banned,
    required  this.createdOn,
    required this.deleted,
    required  this.displayName,
    // required this.displayNameChanged,
    required this.empDesignation,
    required  this.forcePasswordReset,
    required  this.language,
    required  this.lastIp,
    required   this.lastLogin,
    required  this.mobileNo,
    required    this.passwordHash,
    required  this.profileImageName,
    //  required  this.resetHash,
    //  required  this.resetBy,
    required this.roleId,
    required  this.roleName,
    required this.timezone,
    required this.usrCreatedy,
    required this.token,
    // required this.status,
    // required this.message
  });

  factory MessageModel2.fromJson(Map<String, dynamic> json){
    return MessageModel2(
          id: json["id"] ?? '',
          roleId: json["role_id"] ?? '',
          email: json["email"] ?? '',
          username: json["username"] ?? '',
          passwordHash: json["password_hash"] ?? '',
          // resetHash: json["reset_hash"] ?? '',
          lastLogin: json["last_login"] ?? '',
          lastIp: json["last_ip"] ?? '',
          createdOn: json["created_on"] ?? '',
          deleted: json["deleted"] ?? '',
          // resetBy: json["reset_by"] ?? '',
          banned: json["banned"] ?? '',
          banMessage: json["ban_message"] ?? '',
          displayName: json["display_name"] ?? '',
          // displayNameChanged: json["display_name_changed"] ?? '',
          timezone: json["timezone"] ?? '',
          language: json["language"] ?? '',
          active: json["active"] ?? '',
          activateHash: json["activate_hash"] ?? '',
          forcePasswordReset: json["force_password_reset"] ?? '',
          profileImageName: json["profile_image_name"] ?? '',
          mobileNo: json["mobile_no"] ?? '',
          empDesignation: json["emp_designation"] ?? '',
          usrCreatedy: json["usr_created_by"] ?? '',
          roleName: json["role_name"] ?? '',
          token: json['api_token']??'',
          // message: json['message']??'',
        );
  }
  Map<String, dynamic> toJson() => {
    // "message":message,
    // "status":status,
    "id": id,
    "role_id": roleId,
    "email": email,
    "username": username,
    "password_hash": passwordHash,
    "reset_hash": id,
    "last_login": lastLogin,
    "last_ip": lastIp,
    "created_on": createdOn,
    "deleted": deleted,
    //  "reset_by": resetBy,
    "banned": banned,
    "ban_message": banMessage,
    "display_name": displayName,
    //   "display_name_changed": displayNameChanged,
    "timezone": timezone,
    "language": language,
    "active": active,
    "activate_hash": activateHash,
    "force_password_reset": forcePasswordReset,
    "profile_image_name": profileImageName,
    "mobile_no": mobileNo,
    "emp_designation": empDesignation,
    "usr_created_by": usrCreatedy,
    "role_name": roleName,
    "api_token":token
  };
}
//
// List<MessageModel2> messageModels2FromJson(String str) =>
//     List<MessageModel2>.from(
//         json.decode(str).map((x) => MessageModel2.fromJson(x)));

List<MessageModel2> messageModels2FromJson(String str) =>
    List<MessageModel2>.from(
        (json.decode(str) ).map((x) => MessageModel2.fromJson(x)));
