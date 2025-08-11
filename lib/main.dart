import 'package:flutter/material.dart';
import './dashboard.dart';
import 'package:frontend/loginpage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? savedToken = prefs.getString('token');

  runApp(MyApp(token: savedToken));
}

class MyApp extends StatelessWidget {
  final String? token; 
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    bool isTokenValid =
        token != null && JwtDecoder.isExpired(token!) == false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isTokenValid ? Dashboard(token: token!) : const LoginPage(),
    );
  }
}
