import 'package:flutter/material.dart';
import '../Components/background_circular.dart';
import 'start.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _currentIndex = 0;
  int _clickCount = 0;
  final List<String> _images = [
    'lib/Images/mobile1.png',
    'lib/Images/mobile2.png',
    'lib/Images/mobile3.png',
  ];
  final List<String> _titles = [
    'קבלי/י עזרה',
    'יכולת שליטה על הבקשות ',
    'מקרו התנדבות',
  ];
  final List<String> _texts = [
    'בקשו מה שאתם צריכים מהאנשים הרלוונטים שרוצים לעזור',
    'עזרו לך? כדאי לסגור את הבקשה כדי שלא יפנו אילך יותר',
    ' רוצה לעזור בקטנה?  אתם בוחרים למי ומתי איך וכיצד ',
  ];

  void _nextImageText() {
    setState(() {
      _clickCount++;
      if (_clickCount == 3 && _currentIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCustomScreen()),
        );
        _clickCount = 0;
      } else {
        _currentIndex = (_currentIndex + 1) % _images.length;
        if (_currentIndex == 0) {
          _clickCount = 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      painter: BackgroundPainter(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Image.asset(
              _images[_currentIndex],
              width: 300,
              height: 300,
              fit: BoxFit.fitWidth,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                    color: _currentIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Text(
                      _titles[_currentIndex],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _texts[_currentIndex],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCustomScreen()),
                  ),
                  child: Text('דלג'),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: _nextImageText,
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
