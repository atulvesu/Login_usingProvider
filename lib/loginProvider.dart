import 'dart:async';
import 'dart:convert';
import 'package:api_logic/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _message;

  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> login(
      String email, String password, BuildContext context) async {
    final Uri apiUrl =
        Uri.parse('http://172.232.189.142/mgentic2/api/v1/login');

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['message'] != null) {
          _message = responseBody['message'];
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_message!)),
          );

          if (responseBody["success"] == true &&
              responseBody['token'] != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', responseBody['token']);

            Timer(const Duration(seconds: 0), () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (Route<dynamic> route) => false);
            });
          }
        } else {
          throw Exception('Failed to log in: ${responseBody['message']}');
        }
      } else {
        throw Exception('Failed to log in: ${response.statusCode}');
      }
    } catch (e) {
      _message = 'Failed to log in: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_message!)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
