

import 'package:equatable/equatable.dart';


abstract class PhotoEvent extends Equatable {}

class AddPhotoEvent extends PhotoEvent {
  final String photoData;
  final String location;

  AddPhotoEvent({required this.photoData, required this.location});

  @override
  List<Object?> get props =>
      [ photoData, location];
}
