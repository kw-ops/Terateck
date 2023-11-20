import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'internet_provider.dart';
import 'otp.dart';
import 'sign_in_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => SignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => InternetProvider()),
        ),
      ],
      child: const MaterialApp(
        home: OTPpage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

