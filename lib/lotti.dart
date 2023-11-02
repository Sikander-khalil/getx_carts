import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Lotti extends StatefulWidget {
  const Lotti({super.key});

  @override
  State<Lotti> createState() => _LottiState();
}

class _LottiState extends State<Lotti> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  StreamController<int> stream = StreamController();
  var _color = Colors.black;
  var _value = 0.0;
  double percent = 0.0;
  @override
  void initState() {

    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 6),

        vsync: this);
    controller.addStatusListener((status) async{

      if(status == AnimationStatus.completed){

        Navigator.pop(context);
        controller.reset();
        loop();
      }
    });
    stream.stream.listen((element) {

      setState(() {
        _value = element / 100;

      });
      if (element < 5 && element > 0)
        _color = Colors.red;
      else if (element < 25 && element > 5)
        _color = Colors.cyan;
      else if (element < 50 && element > 25)
        _color = Colors.lightGreenAccent;
      else if (element < 75 && element > 50)
        _color = Colors.lightGreen;
      else if (element < 100 && element > 75)
        _color = Colors.green;
    });



  }


  Future<void> loop() async {
    for (int i = 0; i <= 100; i++) {

      if (!stream.isClosed) {

        stream.sink.addStream(

            Stream.value(i));
      }else{

        print("Error");
      }
      await Future.delayed(Duration(milliseconds: 100));
    }

  }

  @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  appBar: AppBar(
    title: Text("Lottie Animation"),
    centerTitle: true,
  ),
      body: Center(
        child: Column(
          children: [
            Lottie.network('https://assets1.lottiefiles.com/packages/lf20_jmejybvu.json'),
            SizedBox(height: 32,),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10),
                textStyle: TextStyle(fontSize: 28),
              ),
              onPressed: showDoneDialog, icon: Icon(Icons.delivery_dining, size: 42,),
            label: Text("Order Pizza"),

            ),


            SizedBox(height: 20,),

            Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  minHeight: 30,

                  value: _value,
                  color: _color,


                ),
                Text(
                  (_value * 100).toStringAsFixed(1),
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ],
            ),

            if(_value == 1)
              Text("Thanks for the Delievered, Wait 1 minute then after your order will be delivered", style: TextStyle(fontSize: 25),)











          ],


        ),


      ),

    );


  }
  void showDoneDialog () =>


        showDialog(
            barrierDismissible: false,
            context: context, builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Lottie.asset('assets/animation_lnvaaz6b.json', repeat: false,
                  controller: controller,
                  onLoaded: (composition){



                    controller.forward();
                  }
              ),
              Text("Enjoy your Order", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 16,),




            ],),

        ));



}
