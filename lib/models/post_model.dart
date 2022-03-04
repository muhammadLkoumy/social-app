class PostModel {
  String? name;
  String? uId;
  String? profileImage;
  String? dateTime;
  String? image;
  String? text;

  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    required this.profileImage,
    required this.dateTime,
    required this.text,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    text = json['text'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'dateTime': dateTime,
      'uId': uId,
      'text': text,
      'profileImage': profileImage,
    };
  }
}
