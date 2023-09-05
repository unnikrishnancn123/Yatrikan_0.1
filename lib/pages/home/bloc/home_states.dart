import 'package:photo_snap/model/photo_add_model.dart';
import 'package:equatable/equatable.dart';


abstract class HomeState extends Equatable{
  const HomeState();
}

class LoadingState extends HomeState {
  @override
  List<Object> get props => [];
}

class DataLoadedState extends HomeState {
  final List<PhotoAddModel> photos;

  const DataLoadedState({required this.photos});
  @override
  List<Object> get props => [photos];
}

class ErrorState extends HomeState {
  final String errorMessage;
  const ErrorState(this.errorMessage);
  @override
  List<Object> get props => [];
}


