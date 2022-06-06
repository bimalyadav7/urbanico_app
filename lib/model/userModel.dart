class User {
  late String userID;
  late String name;
  late String password;
  late String email;
  late String userType;
  late String contact;
  late String userStatus;
  late String lastModified;
  User() {
    userID = '';
    name = '';
    password = '';
    email = '';
    userType = '';
    contact = '';
    userStatus = '';
    lastModified = '';
  }

  User.fromVariable(this.userID, this.name, this.password, this.email, this.userType, this.contact, this.userStatus, this.lastModified);

  User.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    name = json['name'];
    password = json['password'] ?? "";
    email = json['email'];
    userType = json['userType'];
    contact = json['contact'];
    userStatus = json['user_status'] ?? "";
    lastModified = json['last_modified'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "userID": userID,
      "name": name,
      "password": password,
      "email": email,
      "userType": userType,
      "contact": contact,
      "user_status": userStatus,
      "last_modified": lastModified
    };
  }
}
