class PhotoAddModel {
  int? id;
  String? photo_code;
  String? location;

  PhotoAddModel({this.id, this.photo_code, this.location,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo_code': photo_code,
      'location': location,
    };
  }

  static PhotoAddModel fromMap(Map<dynamic, dynamic> map) {
    return PhotoAddModel(
      id: map['id'] as int?,
      photo_code: map['photo_code'] as String?,
      location: map['location'] as String?,
    );
  }
}
