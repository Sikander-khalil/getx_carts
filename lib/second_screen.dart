import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SpinningWheel extends StatefulWidget {

  @override
  State<SpinningWheel> createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel> with TickerProviderStateMixin{
  int reward = 0;
  List<String> itemValues = ["100\$", "200\$", "300\$", "400\$", "500\$", "600\$", "700\$", "800\$"];
  final selected = BehaviorSubject<int>();
  List<FortuneItem> getFortuneItems() {
    return itemValues.asMap().entries.map((entry) {
      int index = entry.key;
      String value = entry.value;

      late TextStyle color;

     late FortuneItemStyle style;

      if (index == 0) {
        color = TextStyle(color: Colors.white);
        style = FortuneItemStyle(color: Colors.red);
      } else if (index == 1) {
        color = TextStyle(color: Colors.white);
        style = FortuneItemStyle(color: Colors.green);
      } else if (index == 2) {
        color = TextStyle(color: Colors.black);
        style = FortuneItemStyle(color: Colors.white);
      } else if (index == 3) {
        color = TextStyle(color: Colors.white);
        style = FortuneItemStyle(color: Colors.blue);
      } else if (index == 4) {
        color = TextStyle(color: Colors.white);
        style = FortuneItemStyle(color: Colors.orange);
      } else if (index == 5) {
        color = TextStyle(color: Colors.black);
        style = FortuneItemStyle(color: Colors.yellow);
      } else if (index == 6) {
        color = TextStyle(color: Colors.white);
        style = FortuneItemStyle(color: Colors.black);
      } else if (index == 7) {
        color = TextStyle(color: Colors.white);
        style = FortuneItemStyle(color: Colors.purple);
      }

      return FortuneItem(
        child: Text(value, style: color),
        style: style,
      );
    }).toList();
  }

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Animation duration
      vsync: this, // Use the TickerProvider from SingleTickerProviderStateMixin
    )..repeat(); // Repeat the animation indefinitely
  }
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spinning Wheel"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FortuneWheel(
                      styleStrategy: AlternatingStyleStrategy(),
                      indicators: [
                        FortuneIndicator(

                          child: Container(
                           margin: EdgeInsets.only(bottom: 350),
                            width: 60,
                            height: 60,
                            child: TriangleIndicator(

                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                      selected: selected.stream,
                      animateFirst: false,


                      items: getFortuneItems(),
                      onAnimationEnd: (){
                        setState(() {
                          reward = selected.value ?? 0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("You Just Won " + itemValues[reward] + " Points"))
                        );

                      },

                    ),
                  ),
                  Image(
                      height: 100,
                      width: 100,
                      image: AssetImage(

                      "assets/images/roulette-center-300.png"))
                ],
              ),
            ),
            ElevatedButton(onPressed: (){


              selected.add(Fortune.randomInt(0, itemValues.length));

            }, child: Text("Spin"))
          ],
        ),
      ),
    );
  }
}