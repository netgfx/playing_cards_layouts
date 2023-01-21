import 'dart:math';

degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

radiansToDegrees(double radians) {
  return radians * (180 / pi);
}

List<double> getRotatedDimensions(
  double angle_in_degrees,
  double width,
  double height,
) {
  double angle = angle_in_degrees * pi / 180;
  double _sin = sin(angle);
  double _cos = cos(angle);
  double x1 = _cos * width;
  double y1 = _sin * width;
  double x2 = -_sin * height;
  double y2 = _cos * height;
  double x3 = _cos * width - _sin * height;
  double y3 = _sin * width + _cos * height;
  List<double> sortX = <double>[0.0, x1, x2, x3];
  sortX.sort();
  List<double> sortY = <double>[0.0, y1, y2, y3];
  sortY.sort();
  double minX = sortX.first;
  double maxX = sortX.last;
  double minY = sortY.first;
  double maxY = sortY.last;

  return [((maxX - minX)).floorToDouble(), ((maxY - minY)).floorToDouble()];
}

List<double> rotatePointInBox(
  double x,
  double y,
  double angle,
  double width,
  double height,
) {
  double _angle = degreesToRadians(angle);
  double centerX = width / 2.0;
  double centerY = height / 2.0;
  double dx = x - centerX;
  double dy = y - centerY;
  double dist = sqrt(dx * dx + dy * dy);
  double a = atan2(dy, dx) + _angle;
  double dx2 = cos(a) * dist;
  double dy2 = sin(a) * dist;

  return [dx2 + centerX, dy2 + centerY];
}

List<Map<String, dynamic>> calculateCoords(
    int numCards, double arcRadius, double cardWidth, double cardHeight, String direction, double cardSpacing, Map<String, dynamic> box) {
  // The separation between the cards, in terms of rotation around the circle's origin
  var anglePerCard = radiansToDegrees(atan((cardWidth * cardSpacing) / arcRadius));

  int angleOffset = {"N": 270, "S": 90, "E": 0, "W": 180}[direction]!;

  var startAngle = angleOffset - 0.5 * anglePerCard * (numCards - 1);

  List<Map<String, dynamic>> coords = [];
  int i = 0;
  double minX = 99999.0;
  double minY = 99999.0;
  double maxX = -minX;
  double maxY = -minY;
  for (i = 0; i < numCards; i++) {
    var degrees = startAngle + anglePerCard * i;

    var radians = degreesToRadians(degrees);
    var x = cardWidth / 2 + cos(radians) * arcRadius;
    var y = cardHeight / 2 + sin(radians) * arcRadius;

    minX = min(minX, x);
    minY = min(minY, y);
    maxX = max(maxX, x);
    maxY = max(maxY, y);

    print("$minX $minY $maxX $maxY ${degrees + 90}");
    coords.add({"x": x, "y": y, "angle": degrees + 90});
  }

  List<double> rotatedDimensions = getRotatedDimensions(coords[0]["angle"], cardWidth, cardHeight);

  double offsetX = 0.0;
  double offsetY = 0.0;

  if (direction == "N") {
    offsetX = minX * -1;
    offsetX += (rotatedDimensions[0] - cardWidth) / 2;

    offsetY = minY * -1;
  } else if (direction == "S") {
    offsetX = minX * -1;
    offsetX += (rotatedDimensions[0] - cardWidth) / 2;

    offsetY = (minY + (maxY - minY)) * -1;
  } else if (direction == "W") {
    offsetY = minY * -1;
    offsetY += (rotatedDimensions[1] - cardHeight) / 2;

    offsetX = minX * -1;
    offsetX += cardHeight - rotatePointInBox(0, 0, 270, cardWidth, cardHeight)[1];
  } else if (direction == "E") {
    offsetY = minY * -1;
    offsetY += (rotatedDimensions[1] - cardHeight) / 2;

    offsetX = arcRadius * -1;
    offsetX -= cardHeight - rotatePointInBox(0, 0, 270, cardWidth, cardHeight)[1];
    //offsetX -= ?????;    // HELP! Needs to line up with yellow line!
  }

  for (int i = 0; i < coords.length; i++) {
    coords[i]["x"] += offsetX;
    coords[i]["x"] = (coords[i]["x"]).round();

    coords[i]["y"] += offsetY;
    coords[i]["y"] = (coords[i]["y"]).round();

    coords[i]["angle"] = (coords[i]["angle"]).round();
  }

  box["width"] = coords[numCards - 1]["x"] + cardWidth;
  box["height"] = coords[numCards - 1]["y"] + cardHeight;

  return coords;
}
