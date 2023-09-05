
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/model/photo_add_model.dart';
import 'package:photo_snap/services/db_service.dart';
import 'home_event.dart';
import 'home_states.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int currentPage = 1;
  List<PhotoAddModel> photos = [];
/*  String searchQuery = '';*/

  HomeBloc() : super(LoadingState()) {
    on<FetchDataEvent>(_mapFetchDataEventToState);
  }
  Future<void> _mapFetchDataEventToState(
      FetchDataEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(LoadingState());
    try {
      final fetchedPhotos = await DbService.instance.getphotos(page: currentPage);
      final photofetch =await DbService.instance.getphoto();
      final photosWithMatchingLocation = await DbService.instance.getphotosByLocation(event.query);

      if (event.hasNewPhoto) {
        photos = photofetch;
      }else if( event.query.isNotEmpty){
        photos =photosWithMatchingLocation;
      }
      else {
        photos.addAll(fetchedPhotos);
      }
      currentPage++;
      emit(DataLoadedState(photos: photos));
    } catch (e) {
      emit(ErrorState("An error occurred while fetching data."));
    }

  }

}