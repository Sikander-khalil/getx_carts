import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepper/theme_provider.dart';

import 'lotti.dart';
import 'second_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider<ThemeProvider>( create: (context) => ThemeProvider()),

      ],

      builder: (context, child) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.theme,
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentStep = 0;
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              _showCustomModalSheet(context);
            },
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stepper(
                steps: [
                  Step(
                    title: Text("Step 1"),
                    content: Text("Welcome to our App"),
                  ),
                  Step(
                    title: Text("Step 2"),
                    content: Text("Are you enjoying this app"),
                  ),
                  Step(
                    title: Text("Step 3"),
                    content: Text(
                      "You are in the final step. Do not want to cancel it",
                    ),
                  ),
                ],
                onStepTapped: (int newIndex) {
                  setState(() {
                    currentStep = newIndex;
                  });
                },
                currentStep: currentStep,
                onStepContinue: () {
                  if (currentStep != 2) {
                    setState(() {
                      currentStep += 1;
                    });
                  }
                },
                onStepCancel: () {
                  if (currentStep != 0) {
                    setState(() {
                      currentStep -= 1;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpinningWheel(),
                    ),
                  );
                },
                child: Text("Second Screen"),
              ),
           SizedBox(height: 10,),
           Row(

             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text("Awesome Article", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
               ),
             ],
           ),
           SizedBox(
             height: 17,
           ),
           Padding(
             padding: EdgeInsets.all(8.0),
             child: buildText(
                 "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."),
           ),
           SizedBox(height: 24,),

           Row(children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: buildButton(),
             ),
           ] )
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            final provider = Provider.of<ThemeProvider>(context, listen: false);

            return Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.amber,
              child: ListTile(
                title: provider.isDarkTheme
                    ? Text("Disable The Theme")
                    : Text("Enable The Theme"),
                trailing: SizedBox(
                  width: 50,
                  child: Switch(
                    value: provider.isDarkTheme,
                    activeColor: Colors.amber,
                    activeTrackColor: Colors.blue,
                    onChanged: (newValue) {
                      stateSetter(() {
                        provider.toggleTheme();
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildButton() => ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          textStyle: TextStyle(fontSize: 12)),
      onPressed: () {
        setState(() {
          isReadMore = !isReadMore;
        });
      },
      child: Text(isReadMore ? "Read Less" : "Read More"));

  Widget buildText(String text) {
    final maxLines = isReadMore ? null : 5;
    final overflow = isReadMore ? TextOverflow.visible : TextOverflow.ellipsis;
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(fontSize: 17),
    );
  }
}
