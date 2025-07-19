import 'dart:convert';

import 'package:recycling_app/models/leaderboard.dart';
import 'package:recycling_app/models/product.dart';
import 'package:recycling_app/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transactions.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import 'http_service.dart';

class ApiCalls {

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) return false;

    final response = await HttpService.get("user");

    if (response.statusCode == 200) {
      return true;
    } else {
      await prefs.remove('token');
      return false;
    }
  }



  static Future<bool> login(String email, String password) async {
    final body = {"email": email, "password": password};
    final response = await HttpService.post("login", body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      final token = data['token'];
      await prefs.setString('token', token);
      return true;
    } else {
      return false;
    }
  }

  static Future<String> register(
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final body = {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
    final response = await HttpService.post("register", body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      final token = data['token'];
      await prefs.setString('token', token);
      return "success";
    } else {
      final data = jsonDecode(response.body);
      return data['message'];
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await HttpService.post("logout", null);
  }

  static Future<String> createProfile(Map<String, dynamic> data) async {
    final response = await HttpService.post("profile", data);
    if (response.statusCode == 200) {
      return "success";
    } else {
      final res = jsonDecode(response.body);
      return res['message'] ?? "Unknown error";
    }
  }

  static Future<User> getUser() async {
    final response = await HttpService.get("user");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data["user"]);
    } else {
      throw Exception("Failed to load user");
    }
  }

  static Future<String> scanQr(String qrCode) async {
    final body = {"qr_code": qrCode};
    final response = await HttpService.post("scan-qr", body);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded['message'] as String;
    } else {
      final errorMsg = decoded['message'] ?? 'Unknown error';
      throw Exception(errorMsg);
    }
  }

  static Future<UserProfile> getUserProfile() async {
    final response = await HttpService.get("profile");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data["profile"]);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  static Future<Profile> getProfileByUsername(String username) async {
    final response = await HttpService.get("profile/$username");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Profile.fromJson(data["profile"]);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  static Future<Leaderboard> getLeaderboard() async {
    final response = await HttpService.get("leaderboard");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Leaderboard.fromJson(data);
    } else {
      throw Exception("Failed to load leaderboard");
    }
  }

  static Future<List<Product>> getProducts() async {
    final response = await HttpService.get("products");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["products"] as List)
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<Map<String, dynamic>> redeemProduct(int productId) async {
    final response = await HttpService.post("redeem", {"product_id": productId});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'message': data['message'] as String,
      };
    } else {
      String errorMessage = "Purchase failed";
      try {
        final data = jsonDecode(response.body);
        if (data['message'] != null) {
          errorMessage = data['message'];
        }
      } catch (_) {}
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  static Future<List<TransactionModel>> getTransactions() async {
    final response = await HttpService.get("transactions");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["transactions"] as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to load transactions");
    }
  }

}
