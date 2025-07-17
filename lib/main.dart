import 'package:flutter/material.dart';
import 'package:recycling_app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/AppColors.dart';

void main() {
  runApp(const MyApp());
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? initialRoute;

  @override
  void initState() {
    super.initState();
    _loadInitialRoute();
  }

  Future<void> _loadInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      initialRoute =
          (token != null && token.isNotEmpty)
              ? AppRoutes.home
              : AppRoutes.welcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initialRoute == null) {
      // Still loading token, show splash or loading screen
      return const Material(child: Center(child: CircularProgressIndicator()));
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.darkGreen,
          primary: AppColors.darkGreen,
          secondary: AppColors.lightGreenAccent,
          surface: AppColors.white,
          onPrimary: AppColors.white,
          onSecondary: AppColors.darkGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
      ),

      routes: AppRoutes.routes,
      initialRoute: initialRoute,
      navigatorObservers: [routeObserver],
      themeMode: ThemeMode.light,
    );
  }
}
