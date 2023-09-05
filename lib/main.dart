import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_snap/services/firebase_api.dart';

import 'common/routes/pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 final navigatorKey =GlobalKey<NavigatorState>();
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState()  => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AppPages.allBlocProviders(context)],
      child: ScreenUtilInit(builder: (context, child) =>
       const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppPages.GenerateRouteSettings,
      ),
      ),
    );

  }

}



