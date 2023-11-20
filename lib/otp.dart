import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'internet_provider.dart';
import 'next_screen.dart';
import 'sign_in_provider.dart';

class OTPpage extends StatefulWidget {
  const OTPpage({super.key});

  @override
  State<OTPpage> createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            handleGoogleSignIn();
          },
          child: Container(
            height: size.height * 0.08,
            width: size.width * 0.5,
            alignment: Alignment.center,
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(BuildContext context, msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          elevation: 3.0,
          backgroundColor: Colors.black.withOpacity(0.8),
        ),
      );
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      //openSnackbar(context, "Check your Internet connection", Colors.red);
      //googleController.reset();
      showSnackBar(context, 'Check your Internet connection');
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          //openSnackbar(context, sp.errorCode.toString(), Colors.red);
          //googleController.reset();
          showSnackBar(context, sp.errorCode.toString());
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        //googleController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreen(context, const HomePage());
    });
  }
}
