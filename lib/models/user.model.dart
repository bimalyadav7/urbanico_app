import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'user.model.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  String userID;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? password;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? userType;
  @HiveField(5)
  String contact;
  @HiveField(6)
  String? userStatus;
  User({
    required this.userID,
    required this.name,
    this.password,
    this.email,
    this.userType,
    required this.contact,
    this.userStatus,
  });

  User copyWith({
    String? userID,
    String? name,
    String? password,
    String? email,
    String? userType,
    String? contact,
    String? userStatus,
  }) {
    return User(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      contact: contact ?? this.contact,
      userStatus: userStatus ?? this.userStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'password': password,
      'email': email,
      'userType': userType,
      'contact': contact,
      'userStatus': userStatus,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      password: map['password'],
      email: map['email'],
      userType: map['userType'],
      contact: map['contact'] ?? '',
      userStatus: map['userStatus'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userID: $userID, name: $name, password: $password, email: $email, userType: $userType, contact: $contact, userStatus: $userStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userID == userID &&
        other.name == name &&
        other.password == password &&
        other.email == email &&
        other.userType == userType &&
        other.contact == contact &&
        other.userStatus == userStatus;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        name.hashCode ^
        password.hashCode ^
        email.hashCode ^
        userType.hashCode ^
        contact.hashCode ^
        userStatus.hashCode;
  }
}
