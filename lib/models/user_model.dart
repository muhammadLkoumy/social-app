class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? bio;
  String? profileImage;
  String? coverImage;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.bio,
    required this.profileImage,
    required this.coverImage,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    bio = json['bio'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'bio': bio,
      'profileImage': profileImage,
      'coverImage': coverImage,
    };
  }
}
