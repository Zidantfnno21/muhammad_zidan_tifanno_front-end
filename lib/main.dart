import 'package:flutter/material.dart';
import 'package:mobile_test_siscom/config/app_binding.dart';
import 'package:mobile_test_siscom/config/theme.dart';
import 'package:mobile_test_siscom/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router(),
    );
  }
}