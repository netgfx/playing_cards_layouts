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
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
        /////////////////////////////////
        final double r = sqrt(80 * 80 + 120 * 120) / 2;
        final alpha = atan(120 / 80);
        final beta = alpha + card["coords"]["angle"] * (pi / 180);
        final shiftY = r * sin(beta);
        final shiftX = r * cos(beta);
        final translateX = 80 / 2 - shiftX;
        final translateY = 120 / 2 - shiftY;

        //
        updateCanvas(canvas!, card["coords"]["x"] + translateX, card["coords"]["y"] + translateY, card["coords"]["angle"] * (pi / 180), () {
          //path = Path();

          Rect rectS = Rect.fromLTWH(0, 0, card["card"]["width"], card["card"]["height"]);
          canvas!.drawRRect(RRect.fromRectAndRadius(rectS, Radius.circular(_radius)), shadowPaint);

          Rect rect = Rect.fromLTWH(0, 0, card["card"]["width"], card["card"]["height"]);
          path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(_radius)));
          canvas!.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(_radius)), _paint);
          //

          //canvas!.drawShadow(path, Color(0xff000000), 3, false);
        }, translate: true);
      }
    }
  }

  void updateCanvas(Canvas canvas, double? x, double? y, double? rotate, VoidCallback callback, {bool translate = false}) {
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
