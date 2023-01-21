import 'dart:math';

import 'package:example/card_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui;

import 'package:playing_cards_layouts/playing_cards_layouts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  BoxConstraints? viewportConstraints;
  List<Map<String, dynamic>> cards = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.repeat();
      generateCards();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Generate the maze
  void generateCards() {
    //print('generate maze executed in ${stopwatch.elapsed}');
    for (int i = 0; i < 5; i++) {
      cards.add({
        "color": Color.fromARGB(255, Colors.purple.red, Colors.purple.green, Colors.purple.blue),
        "id": UniqueKey().toString(),
        "width": 80,
        "height": 120,
      });
    }

    var _cards = fanCards(cards, {
      "flow": "horizontal", // The layout direction (horizontal or vertical)
      "fanDirection": "N",
      "imagesUrl": "cards/",
      "spacing": 0.6,
      "radius": 200,
      "width": 80,
    });

    print(_cards);
    cards.clear();
    cards = _cards;
  }

  void randomize() {
    generateCards();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: const ui.Color.fromARGB(255, 0, 0, 0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[],
                    ),
                  ],
                ),
              )),
        ),
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
          this.viewportConstraints = viewportConstraints;
          return Stack(children: [
            Positioned(
              top: 100,
              left: 100,
              child: Transform.translate(
                  offset: const Offset(0, 0),
                  child: RepaintBoundary(
                      child: CustomPaint(
                    size: const ui.Size(200, 400),
                    key: UniqueKey(),
                    isComplex: true,
                    painter: CardBuilder(
                      controller: _controller,
                      cards: cards,
                      //solution: this.mazeSolution,
                      // width: viewportConstraints.maxWidth,
                      // height: viewportConstraints.maxHeight,
                    ),
                    child: Container(constraints: BoxConstraints(maxWidth: viewportConstraints.maxWidth, maxHeight: viewportConstraints.maxHeight)),
                  ))),
            ),
            Positioned(
              top: viewportConstraints.maxHeight - 100,
              left: viewportConstraints.maxWidth - 100,
              child: FloatingActionButton(
                onPressed: randomize,
                backgroundColor: Colors.green,
                child: const Icon(Icons.refresh),
              ),
            ),
          ]);

          //);
        }));
  }
}
