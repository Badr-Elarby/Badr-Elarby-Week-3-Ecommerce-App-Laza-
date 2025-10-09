import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  log('main: WidgetsFlutterBinding initialized');
  await setupGetIt();
  log('main: GetIt setup completed');
  runApp(const MyApp());
  log('main: runApp called');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log('MyApp: build method called');
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        log('MyApp: ScreenUtilInit builder called');
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: GetIt.instance<AppRouter>().router,
        );
      },
    );
  }
}
