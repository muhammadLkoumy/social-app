class CommentModel {
  String? name;
  String? uId;
  String? profileImage;
  String? dateTime;
  String? text;

  CommentModel({
    required this.name,
    required this.uId,
    required this.profileImage,
    required this.dateTime,
    required this.text,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    text = json['text'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateTime': dateTime,
      'uId': uId,
      'text': text,
      'profileImage': profileImage,
    };
  }
}
