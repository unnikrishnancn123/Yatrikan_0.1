
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/pages/home/widget/home.dart';

import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashScreenBloc = BlocProvider.of<SplashBloc>(context);

    splashScreenBloc.add(SplashScreenEvent.start);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SplashBloc, bool>(
        listener: (context, state) {
          if (state) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Home()),
            );
          }
        },
          child: Center(
            child: SizedBox(
              height: 300,
              width: 1000,
              child: Image.asset('assets/images/logo.jpg'),
            ),
          ),
      ),
    );
  }
}
