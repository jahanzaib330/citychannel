import 'package:citychannel/User/Firebase_Firestore/Order_Booking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UserLogin() ,
      ),
    );
  }
}
