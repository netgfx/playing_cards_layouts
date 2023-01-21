import 'package:playing_cards_layouts/utils/math.dart';

/// fan cards layout
List<Map<String, dynamic>> fanCards(List<Map<String, dynamic>> cards, Map<String, dynamic> options) {
  var n = cards.length;
  if (n == 0) {
    return [];
  }

  var width = options["width"] ?? 90; // hack: for a hidden hand
  var height = cards[0]["height"] ?? (width * 1.4).floor(); // hack: for a hidden hand
  print("height: $height");
  Map<String, dynamic> box = {};
  List<Map<String, dynamic>> finalCards = [];
  var coords = calculateCoords(n, options["radius"], width, height, options["fanDirection"], options["spacing"], box);

  //var hand = (cards[0])["parentElement"];
  //hand.style.width = box.width + "px";
  //hand.style.height = box.height + "px";
  //hand.width(box.width);
  //hand.height(box.height);

  var i = 0;
  for (var coord in coords) {
    var card = cards[i];
    finalCards.add({"card": card, "coords": coord});

    //card.style.left = coord.x + "px";
    //card.style.top = coord.y + "px";
    //gsap.to(card, {left: coord.x+"px", top: coord.y+"px", duration: 0.5})
    //card.onmouseenter = function () {
    //cardSetTop(card, coord.y - 20, true);
    //gsap.to(card, {top: (coord.y - 20)+"px", zIndex: 99, duration: 0.15})
    //};
    //card.onmouseleave = function () {
    //gsap.to(card, {top: (coord.y)+"px", zIndex: 0, duration: 0.10, delay: 0.15})
    //cardSetTop(card, coord.y, false);
    //};

    int rotationAngle = (coord["angle"]).round();
    var prefixes = ["Webkit", "Moz", "O", "ms"];
    prefixes.forEach((prefix) => {
          //card.style[prefix + "Transform"] = "rotate(" + rotationAngle + "deg)" + " translateZ(0)";
          //gsap.to(card, {rotation: rotationAngle+"_short", z: 0, duration: 0.8})
        });

    i += 1;
  }

  return finalCards;
}
