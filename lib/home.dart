import 'package:flutter/material.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "GUESZY",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                  ),
                ),
                Image.asset(
                  'assets/logo2.png',
                  height: 75,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(height: 36,),

            ElevatedButton(
                onPressed: () {

                  Navigator.push( context,
                      MaterialPageRoute(builder: (context) => Gueszy()));
                },
                child: Text(
                    "Guess Word",
                style: TextStyle(
                  color: Colors.black,
                ),
                )),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReverseGueszy()));
            }, child: Text(
                "Set Word",
                style: TextStyle(
                  color: Colors.black,
                ),
            )
            )
          ],
        ),
      ),
    );
  }
}
