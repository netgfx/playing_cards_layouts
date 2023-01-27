<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A Dart package that given an array of sized objects can return a card layout between three variations `horizontal, vertical and fan (rotated horizontal)`.

Example includes solution to be used via Flutter and via CustomPainter. The package is only responsible for delivering a List of coordinates and angle for each card, the presentation is up to the developer using the package.


## Getting started

The result of the layouts can be used with either Flutter widgets or via customPainter. The `/example` includes both ways.

## Usage

The package can layout cards in a `fan`, `horizontal` and `vertical` way.


```dart
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
```

## Additional information

This package is a direct port of https://github.com/richardschneider/cardsJS 
