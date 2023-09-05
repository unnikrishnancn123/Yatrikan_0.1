

class AddPhotoState{
  final String  photoData;
  final  String  location;


  AddPhotoState({required this.photoData, required this.location});

  AddPhotoState copyWith({
    String? photoData,
    String? location,
  }) {
    return AddPhotoState(
      photoData: photoData ?? this.photoData,
      location:location ?? this.location,
    );
  }
}
class LoadingState extends AddPhotoState{
  LoadingState({required super.photoData, required super.location});
}