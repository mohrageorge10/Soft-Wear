class UserModel {
  final String uId;
  final String name;
  final String email;
  final String city;
  final String? profilePic; 

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.city,
    this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'city': city,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      city: map['city'] ?? '',
      profilePic: map['profilePic'],
    );
  }
}