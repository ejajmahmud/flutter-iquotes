import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,

          children: [
           SizedBox(width:300,
        height: 200,
        child: Image.asset('images/logo_quote.png')),
            SizedBox(
              height: 25.0,
            ),
            CircularProgressIndicator(
              color: Colors.cyan,
              // backgroundColor: Colors.cyan,

            ),
          ],
        ),
      ),
    );
  }
}
