class UserModel {
  final String uid;
  final String name;
  final String email;
  final String fcmToken; // APNs

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.fcmToken,
  });

  /// [FromMap] - Convert a firestore document into a model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
    );
  }
}