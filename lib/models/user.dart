class UserModel {
  final String id; // Document ID
  final String fullname;
  final String phone;
  final String dateOfBirth;
  final String avatar;
  final String email;
  final int accountType;

  UserModel({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.dateOfBirth,
    required this.avatar,
    required this.email,
    required this.accountType,
  });

  /// من Firestore document لـ Object
  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      id: docId,
      fullname: json['fullname'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      accountType: json['accountType'] ?? 0,
    );
  }

  /// من Object لـ Map علشان يتخزن في Firestore
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "phone": phone,
      "dateOfBirth": dateOfBirth,
      "avatar": avatar,
      "email": email,
      "accountType": accountType,
    };
  }
}
