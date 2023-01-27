import 'package:playing_cards_layouts/utils/math.dart';

/// fan cards layout
List<Map<String, dynamic>> fanCards(
    List<Map<String, dynamic>> cards, Map<String, dynamic> options) {
  var n = cards.length;
  if (n == 0) {
    return [];
  }

  double width = options["width"] ?? 90.0; // hack: for a hidden hand
  double height =
      cards[0]["height"].toDouble() ?? (width * 1.4); // hack: for a hidden hand

  Map<String, dynamic> box = {};
  List<Map<String, dynamic>> finalCards = [];
  var coords = calculateCoords(n, options["radius"], width, height,
      options["fanDirection"], options["spacing"], box);

  var i = 0;
  for (var coord in coords) {
    var card = cards[i];
    finalCards.add({"card": card, "coords": coord});

    i += 1;
  }

  return finalCards;
}

/// hand cards layout (horizontal, vertical)
List<Map<String, dynamic>> handCards(
    List<Map<String, dynamic>> cards, Map<String, dynamic> options) {
  var n = cards.length;
  if (n == 0) {
    return [];
  }

  List<Map<String, dynamic>> finalCards = [];

  var width =
      options["width"] ?? cards[0]["width"] ?? 70; // hack: for a hidden hand
  var height =
      cards[0]["height"] ?? (width * 1.4).floor(); // hack: for a hidden hand
  int counter = 0;
  for (var card in cards) {
    if (options["flow"] == 'vertical') {
      finalCards.add({
        "card": card,
        "coords": {
          "x": 0.0,
          "y": ((height * counter) + ((options["spacing"] * height) * counter)),
        },
      });
    } else if (options["flow"] == 'horizontal') {
      finalCards.add({
        "card": card,
        "coords": {
          "x": ((width * counter) + ((options["spacing"] * width) * counter)),
          "y": 0.0,
        },
      });
    }

    counter += 1;
  }
  return finalCards;
}
