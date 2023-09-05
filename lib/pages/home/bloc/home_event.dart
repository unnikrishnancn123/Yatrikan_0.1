

import 'package:equatable/equatable.dart';

abstract class  HomeEvent extends Equatable{
  const HomeEvent();
}
class FetchDataEvent extends HomeEvent {
  final bool hasNewPhoto;
  final String query;

  const FetchDataEvent({
    this.hasNewPhoto = false,
    required this.query,
  });

  @override
  List<Object?> get props => [hasNewPhoto, query];
}


