import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // OPTIMIZATION: Reduced logging for better startup performance
  await setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: GetIt.instance<AppRouter>().router,
        );
      },
    );
  }
}
