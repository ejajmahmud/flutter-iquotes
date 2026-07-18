import 'package:flutter/material.dart';
import '../../shared/components/components.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(width: 250,
                height: 250,
                child: Image.asset('images/logo_quote.png',fit: BoxFit.cover,)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'i',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Quotes',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.format_quote,
                  color: Colors.cyan,
                  size: 35.0,
                ),

                // Image(image: AssetImage('images/quote.png'),),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),

            defaultButton(
                text: 'Register',
                function: () {
                  Navigator.pushNamed(context, '/register');
            }),
            SizedBox(
              height: 5.0,
            ),
            defaultButton(text: 'Sign In', function: () {
                Navigator.pushNamed(context, '/signIn');
                       }),
          ],
        ),
      ),
    );
  }
}
