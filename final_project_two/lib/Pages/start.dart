import 'package:final_project_two/Pages/login_page.dart';
import 'package:flutter/material.dart';
import '../Components/background_circular.dart';
import 'terms_of_service_page.dart';

class MyCustomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom( 
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: EdgeInsets.symmetric(horizontal: 110.0, vertical: 20.0), 
                      ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    
                    child: Text('המשך לרישום',style: TextStyle(color: Theme.of(context).colorScheme.background),),
                    
                  ),
                  SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfServicePage(),
                        ),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'בכלחיצה על "המשך לרישום" אני מאשר/ת כי קראתי את ',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'תנאי השימוש',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' והמדיניות של Willing והם מוסכמים עלי.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
