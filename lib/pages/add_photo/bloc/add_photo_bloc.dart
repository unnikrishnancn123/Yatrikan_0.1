import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/model/photo_add_model.dart';
import 'package:photo_snap/services/db_service.dart';
import 'add_photo_event.dart';
import 'add_photo_states.dart';

class AddPhotoBloc extends Bloc<AddPhotoEvent, AddPhotoState> {

  AddPhotoBloc() : super(LoadingState(photoData: '', location: '')) {
    on<AddPhotoEvent>(_mapAddPhotoEventToState);
  }

  void _mapAddPhotoEventToState(AddPhotoEvent event, Emitter<AddPhotoState> emit) async {
    try {
      final newState = AddPhotoState(photoData: event.photoData, location: event.location);
      await  DbService.instance.addPhoto(PhotoAddModel(photo_code:event.photoData, location:event.location,));
      emit(newState);
    } catch (e) {
          print('error');
    }
  }
}
