import 'package:citychannel/User/Firebase_Firestore/Order_Booking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Providers/user_provider.dart';
import 'User/Firebase_Auth/User_Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Default to false if null
      });
    } catch (e) {
      print("Error checking login status: $e");
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const OrderBooking() : const UserLogin(),
      ),
    );
  }
}
