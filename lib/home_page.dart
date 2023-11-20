import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'next_screen.dart';
import 'otp.dart';
import 'sign_in_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                sp.userSignOut();
                nextScreen(context, const OTPpage());
              },
              child: const Text(
                'Sign Out',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Text(
                'Welcome ${sp.name}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
