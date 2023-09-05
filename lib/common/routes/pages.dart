import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/common/routes/routes.dart';
import 'package:photo_snap/pages/Notification/notificationScreen.dart';
import 'package:photo_snap/pages/add_photo/bloc/add_photo_bloc.dart';
import 'package:photo_snap/pages/add_photo/widgets/add_photo.dart';
import 'package:photo_snap/pages/home/bloc/home_bloc.dart';
import 'package:photo_snap/pages/home/widget/home.dart';
import 'package:photo_snap/pages/splashscreen/bloc/splash_bloc.dart';
import 'package:photo_snap/pages/splashscreen/splash.dart';


class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
          route: AppRoutes.INITIAL,
          page: SplashScreen(),
          bloc: BlocProvider(create: (_) =>SplashBloc())
      ),
      PageEntity(
          route: AppRoutes.HOME,
          page: Home(),
          bloc: BlocProvider(create: (_) => HomeBloc())
      ),
      PageEntity(
          route: AppRoutes.ADDPHOTO,
          page: AddPhoto(),
          bloc: BlocProvider(create: (_) => AddPhotoBloc())
      ),

    ];
  }

  static List<BlocProvider<dynamic>> allBlocProviders(BuildContext context) {
    List<BlocProvider<dynamic>> blocProviders = [];
    for (var bloc in routes()) {
      if (bloc.bloc != null) {
        blocProviders.add(bloc.bloc);
      }
    }
    return blocProviders;
  }

  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      var result = routes().firstWhere((element) => element.route == settings.name);
      if (result != null) {
        return MaterialPageRoute(builder: (_) => result.page, settings: settings);
      } else {
        print("Invalid route name: ${settings.name}");
        // Handle the invalid route name appropriately, like navigating to a default page.
        return MaterialPageRoute(builder: (_) => Home(), settings: settings);
      }
    }
    // Handle the case when settings.name is null.
    return MaterialPageRoute(builder: (_) => Home(), settings: settings);
  }
}

class PageEntity {
  String route;
  Widget page;
  dynamic bloc;
  PageEntity( {this.bloc, required this.page, required this.route});
}
