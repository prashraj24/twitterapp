class UserModel {
  String email;
  DateTime joinDate;
  String userId;

  UserModel({
    this.email,
    this.joinDate,
    this.userId,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        email: json["email"] == null ? null : json["email"],
        joinDate: json["joinDate"] == null ? null : json["joinDate"],
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "email": email == null ? null : email,
        "joinDate": joinDate == null ? null : joinDate,
        "userId": userId == null ? null : userId,
      };
}
