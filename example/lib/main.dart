import 'dart:async';
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
  List<Map<String, dynamic>> flowCards = [];
  List<Map<String, dynamic>> blockCards = [];
  List<Map<String, dynamic>> columnCards = [];
  double visible = 0.0;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      //_controller.repeat();
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
    for (int i = 0; i < 5; i++) {
      flowCards.add({
        "color": Color.fromARGB(255, Colors.purple.red, Colors.purple.green, Colors.purple.blue),
        "id": UniqueKey().toString(),
        "width": 80.0,
        "height": 120.0,
      });

      blockCards.add({
        "color": Color.fromARGB(255, Colors.blue.red, Colors.blue.green, Colors.blue.blue),
        "id": UniqueKey().toString(),
        "width": 80.0,
        "height": 120.0,
      });

      columnCards.add({
        "color": Color.fromARGB(255, Colors.green.red, Colors.green.green, Colors.green.blue),
        "id": UniqueKey().toString(),
        "width": 80.0,
        "height": 120.0,
      });
    }

    List<Map<String, dynamic>> _cards = fanCards(flowCards, {
      "flow": "horizontal", // The layout direction (horizontal or vertical)
      "fanDirection": "N",
      "imagesUrl": "cards/",
      "spacing": 0.6,
      "radius": 200.0,
      "width": 80.0,
    });

    List<Map<String, dynamic>> _handCards = handCards(blockCards, {
      "flow": "horizontal",
      "spacing": -0.2,
      "width": 80.0,
    });

    List<Map<String, dynamic>> _columnCards = handCards(columnCards, {
      "flow": "vertical",
      "spacing": -0.2,
      "width": 80.0,
      "height": 120.0,
    });

    flowCards.clear();
    blockCards.clear();
    columnCards.clear();
    setState(() {
      flowCards = _cards;
      blockCards = _handCards;
      columnCards = _columnCards;
    });
  }

  List<Widget> getCards(List<Map<String, dynamic>> sourceCards, String mode) {
    List<Widget> cards = [];
    cards.add(Container());
    int counter = 0;
    for (var card in sourceCards) {
      double? angle = card["coords"]["angle"];
      if (angle != null) {
        angle = (angle - 90) * (pi / 180);
      }

      cards.add(
        Positioned(
          left: card["coords"]["x"].toDouble(),
          top: card["coords"]["y"].toDouble(),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details) => onTap(context, details, mode),
            child: AbsorbPointer(
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: Transform.rotate(
                  angle: angle ?? 0.0,
                  child: FadeTransition(
                    opacity: animateOpacity(counter),
                    child: Container(
                      height: card["card"]["height"],
                      width: card["card"]["width"],
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: card["card"]["color"],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.19),
                              spreadRadius: 4,
                              blurRadius: 6,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      counter += 1;
    }

    return cards;
  }

  void randomize() {
    generateCards();
  }

  void onTap(BuildContext context, TapDownDetails details, String mode) {
    // find the card
    var card = mode == "horizontal" ? blockCards : columnCards;
    double dx = details.globalPosition.dx - 100;
    double dy = details.globalPosition.dy;

    if (mode == "vertical") {
      dx = details.globalPosition.dx - 100;
      dy = details.globalPosition.dy - 600;
    }

    var cardWidth = card[0]["card"]["width"];
    var cardHeight = card[0]["card"]["height"];
    var offsetX = cardWidth * 0.2;
    var offsetY = cardHeight * 0.2;
    var indexX = (dx / (cardWidth - offsetX)).floor();
    var indexY = (dy / (cardHeight - offsetY)).floor();
    if (indexX >= card.length) {
      indexX = card.length - 1;
    }
    if (indexX < 0) {
      indexX = 0;
    }

    if (indexY >= card.length) {
      indexY = card.length - 1;
    }
    if (indexY < 0) {
      indexY = 0;
    }

    if (mode == "horizontal" || mode == "horizontal_rotated") {
      animateCard(indexX, () => {setState(() => {})}, mode);
    } else {
      animateCard(indexY, () => {setState(() => {})}, mode);
    }
  }

  Animation<double> animateOpacity(int index) {
    AnimationController controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    Animation<double> tween = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.1 * index,
        1.0,
        curve: Curves.ease,
      ),
    ));

    tween.addListener(() => {
          //setState(() => {}),
        });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _controller.forward();
    });

    return tween;
  }

  // animate the card
  void animateCard(int cardIndex, Function updateFn, String mode) {
    var card = mode == "horizontal" ? blockCards[cardIndex] : columnCards[cardIndex];
    if (mode == "horizontal_rotated") {
      card = flowCards[cardIndex];
    }
    var currentY = card["coords"]["y"];
    var currentX = card["coords"]["x"];
    var from = 0;
    var to = -10;

    if (mode == "horizontal" || mode == "horizontal_rotated") {
      from = 0;
      to = -10;
    }

    if (currentY < 0) {
      from = currentY;
      to = 0;
    }

    if (mode == "vertical") {
      from = 0;
      to = 10;

      if (currentX > 0) {
        from = currentX;
        to = 0;
      }
    }

    AnimationController controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    final Animation<double> curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    Animation<int> tween = IntTween(begin: from, end: to).animate(curve);

    tween.addListener(() => {
          if (mode == "horizontal" || mode == "horizontal_rotated")
            {
              card["coords"]["y"] = tween.value,
            }
          else
            {
              card["coords"]["x"] = tween.value,
            },
          updateFn(),
        });
    controller.forward();
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
              child: SizedBox(
                width: flowCards.length * 80,
                height: 300,
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  children: getCards(flowCards, "horizontal_rotated"),
                ),
              ),
              // Transform.translate(
              //     offset: const Offset(0, 0),
              //     child: CustomPaint(
              //       size: const ui.Size(200, 400),
              //       key: UniqueKey(),
              //       isComplex: true,
              //       painter: CardBuilder(
              //         controller: _controller,
              //         cards: flowCards,
              //         //solution: this.mazeSolution,
              //         // width: viewportConstraints.maxWidth,
              //         // height: viewportConstraints.maxHeight,
              //       ),
              //       child: Container(constraints: BoxConstraints(maxWidth: viewportConstraints.maxWidth, maxHeight: viewportConstraints.maxHeight)),
              //     )),
            ),
            Positioned(
              top: 400,
              left: 100,
              child: SizedBox(
                width: blockCards.length * 80,
                height: 120,
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  children: getCards(blockCards, "horizontal"),
                ),
              ),
            ),
            Positioned(
              top: 600,
              left: 100,
              child: SizedBox(
                width: 80,
                height: columnCards.length * 120,
                child: Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  children: getCards(columnCards, "vertical"),
                ),
              ),
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
