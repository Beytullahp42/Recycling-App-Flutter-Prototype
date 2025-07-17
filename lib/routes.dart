import 'package:flutter/material.dart';
import 'package:recycling_app/pages/create_profile.dart';
import 'package:recycling_app/pages/leaderboard_page.dart';
import 'package:recycling_app/pages/login.dart';
import 'package:recycling_app/pages/main_scaffold.dart';
import 'package:recycling_app/pages/profile_page.dart';
import 'package:recycling_app/pages/register.dart';
import 'package:recycling_app/pages/scan.dart';
import 'package:recycling_app/pages/scan_process.dart';
import 'package:recycling_app/pages/user_profile_page.dart';
import 'package:recycling_app/pages/welcome_page.dart';

class AppRoutes {
  static const String signUp = "/signup";
  static const String login = "/login";
  static const String home = "/home";
  static const String userProfile = "/userProfile";
  static const String scan = "/scan";
  static const String welcome = "/welcome";
  static const String createProfile = "/createProfile";
  static const String scanProcess = "/scanProcess";
  static const String leaderboard = "/leaderboard";
  static const String profile = "/profile";

  static Map<String, WidgetBuilder> routes = {
    signUp: (context) => const RegisterPage(),
    login: (context) => const LoginPage(),
    home: (context) => const MainScaffold(),
    userProfile: (context) => const UserProfilePage(),
    scan: (context) => const ScanPage(),
    welcome: (context) => const WelcomePage(),
    createProfile: (context) => const CreateProfilePage(),
    scanProcess: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return ScanProcess(qrCode: args);
    },
    leaderboard: (context) => const LeaderboardPage(),
    profile: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return ProfilePage(username: args);
    }
  };
}
