import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/pages/splashscreen/bloc/splash_event.dart';




class SplashBloc extends Bloc<SplashScreenEvent, bool> {
  SplashBloc() : super(false) {
    on<SplashScreenEvent>(_onStartSplashEvent);
  }
  void _onStartSplashEvent(SplashScreenEvent event, Emitter<bool> emit) async {
    await Future.delayed(const Duration(seconds: 3));
    emit(true);
  }
}





