import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as vectorMath;

class CardBuilder extends CustomPainter {
  List<Map<String, dynamic>> points = [];
  var index = 0;
  AnimationController? controller;
  Canvas? canvas;
  int currentTime = 0;
  int fps = 24;
  int timeDecay = 0;
  double width = 100;
  double height = 100;
  double _radius = 10;
  Color shadowColor = Color.fromRGBO(0, 0, 0, 0.3);
  Function? update;
  Paint _paint = Paint();
  ui.BlendMode? blendMode = ui.BlendMode.src;
  List<Map<String, dynamic>> cardCoords = [];
  List cards = [];
  BlendMode _blendMode = BlendMode.dstATop;
  //

  /// Constructor
  CardBuilder({
    /// <-- The animation controller
    required this.controller,

    /// <-- The delay until the animation starts
    required this.cards,
    radius,
    shadowColor,

    /// <-- The particles blend mode (default: BlendMode.src)
    blendMode,
  }) : super(repaint: controller) {
    /// the delay in ms based on desired fps
    timeDecay = (1 / fps * 1000).round();
    _paint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.yellow
      ..strokeWidth = 10.0
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.fill;

    _radius = radius ?? 10.0;
    _blendMode = blendMode ?? BlendMode.dstATop;
    this.shadowColor = shadowColor ?? Color.fromRGBO(0, 0, 0, 0.3);
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    paintImage(canvas, size);
  }

  void paintImage(Canvas canvas, Size size) async {
    draw(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void draw(Canvas canvas, Size size) {
    ///
    ////// draw cards
    drawCards();
  }

  void drawCards() {
    int i = 0;
    for (var card in cards) {
      drawRRect(card, i);
      i += 1;
    }
  }

  void drawRRect(Map<String, dynamic> card, int index) {
    if (canvas != null) {
      //print(card);
      if (card["coords"] != null) {
        var path = Path();

        _paint.color = card["card"]["color"];
        Paint shadowPaint = Paint()
          ..color = shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);
        /////////////////////////////////
        double angle = 0;
        double translateX = 0.0;
        double translateY = 0.0;
        double cardWidth = card["card"]["width"];
        double cardHeight = card["card"]["height"];
        if (card["coords"]["angle"] != null) {
          angle = card["coords"]["angle"].toDouble();
          final double r =
              sqrt(cardWidth * cardWidth + cardHeight * cardHeight) / 2;
          final alpha = atan(cardHeight / cardWidth);
          final beta = alpha + angle * (pi / 180);
          final shiftY = r * sin(beta);
          final shiftX = r * cos(beta);
          translateX = cardWidth / 2 - shiftX;
          translateY = cardHeight / 2 - shiftY;
        }
        //
        updateCanvas(canvas!, card["coords"]["x"] + translateX,
            card["coords"]["y"] + translateY, angle * (pi / 180), () {
          //path = Path();

          // add shadow
          Rect rectS = Rect.fromLTWH(0, 6, card["card"]["width"].toDouble(),
              card["card"]["height"].toDouble());
          canvas!.drawRRect(
              RRect.fromRectAndRadius(rectS, Radius.circular(_radius)),
              shadowPaint);

          Rect rect = Rect.fromLTWH(0, 0, card["card"]["width"].toDouble(),
              card["card"]["height"].toDouble());
          path.addRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(_radius)));
          canvas!.drawRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(_radius)), _paint);
          //
        }, translate: true);
      }
    }
  }

  void updateCanvas(Canvas canvas, double? x, double? y, double? rotate,
      VoidCallback callback,
      {bool translate = false}) {
    double _x = x ?? 0;
    double _y = y ?? 0;

    canvas.save();

    if (translate) {
      //canvas.translate(_x, _y);
    }

    if (rotate != null) {
      canvas.translate(_x, _y);
      canvas.rotate(rotate);
      //canvas.translate(-_x, -_y);
    }
    callback();
    canvas.restore();
  }
}
