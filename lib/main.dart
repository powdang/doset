import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Firebase 추가
import 'package:provider/provider.dart';

import 'providers/clothing_provider.dart';
import 'providers/styling_provider.dart';
import 'providers/daily_record_provider.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();        // ✅ 비동기 초기화 준비
  await Firebase.initializeApp();                   // ✅ Firebase 초기화

  runApp(const DosetApp());
}

class DosetApp extends StatelessWidget {
  const DosetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClothingProvider()),
        ChangeNotifierProvider(create: (_) => StylingProvider()),
        ChangeNotifierProvider(create: (_) => DailyRecordProvider()),
      ],
      child: MaterialApp(
        title: 'doset',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(uid: 'temp-uid'),
        },
      ),
    );
  }
}
