import 'dart:math';

double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

double radiansToDegrees(double radians) {
  return radians * (180 / pi);
}

List<double> getRotatedDimensions(
  double angleInDegrees,
  double width,
  double height,
) {
  double angle = angleInDegrees * pi / 180;
  double sinValue = sin(angle);
  double cosValue = cos(angle);
  double x1 = cosValue * width;
  double y1 = sinValue * width;
  double x2 = -sinValue * height;
  double y2 = cosValue * height;
  double x3 = cosValue * width - sinValue * height;
  double y3 = sinValue * width + cosValue * height;
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
  double angleValue = degreesToRadians(angle);
  double centerX = width / 2.0;
  double centerY = height / 2.0;
  double dx = x - centerX;
  double dy = y - centerY;
  double dist = sqrt(dx * dx + dy * dy);
  double a = atan2(dy, dx) + angleValue;
  double dx2 = cos(a) * dist;
  double dy2 = sin(a) * dist;

  return [dx2 + centerX, dy2 + centerY];
}

List<Map<String, dynamic>> calculateCoords(
    int numCards,
    double arcRadius,
    double cardWidth,
    double cardHeight,
    String direction,
    double cardSpacing,
    Map<String, dynamic> box) {
  // The separation between the cards, in terms of rotation around the circle's origin
  var anglePerCard =
      radiansToDegrees(atan((cardWidth * cardSpacing) / arcRadius));
  String directionOption = direction.toUpperCase();
  int angleOffset = {"N": 270, "S": 90, "E": 0, "W": 180}[directionOption]!;

  var startAngle = angleOffset - 0.5 * anglePerCard * (numCards - 1);

  List<Map<String, dynamic>> coords = [];
  int i = 0;
  double minX = 99999.0;
  double minY = 99999.0;
  double maxX = -minX;
  double maxY = -minY;
  for (i = 0; i < numCards; i++) {
    double degrees = startAngle + anglePerCard * i;

    double radians = degreesToRadians(degrees);
    var x = cardWidth / 2 + cos(radians) * arcRadius;
    var y = cardHeight / 2 + sin(radians) * arcRadius;

    minX = min(minX, x);
    minY = min(minY, y);
    maxX = max(maxX, x);
    maxY = max(maxY, y);

    coords.add({"x": x, "y": y, "angle": degrees});
  }

  List<double> rotatedDimensions =
      getRotatedDimensions(coords[0]["angle"], cardWidth, cardHeight);

  double offsetX = 0.0;
  double offsetY = 0.0;

  if (directionOption == "N") {
    offsetX = minX * -1;
    offsetX += (rotatedDimensions[0] - cardWidth) / 2;

    offsetY = minY * -1;
  } else if (directionOption == "S") {
    offsetX = minX * -1;
    offsetX += (rotatedDimensions[0] - cardWidth) / 2;

    offsetY = (minY + (maxY - minY)) * -1;
  } else if (directionOption == "W") {
    offsetY = minY * -1;
    offsetY += (rotatedDimensions[1] - cardHeight) / 2;

    offsetX = minX * -1;
    offsetX +=
        cardHeight - rotatePointInBox(0, 0, 270, cardWidth, cardHeight)[1];
  } else if (directionOption == "E") {
    offsetY = minY * -1;
    offsetY += (rotatedDimensions[1] - cardHeight) / 2;

    offsetX = arcRadius * -1;
    offsetX -=
        cardHeight - rotatePointInBox(0, 0, 270, cardWidth, cardHeight)[1];
    //offsetX -= ?????;    // HELP! Needs to line up with yellow line!
  }

  for (int i = 0; i < coords.length; i++) {
    coords[i]["x"] += offsetX;
    coords[i]["x"] = (coords[i]["x"]);

    coords[i]["y"] += offsetY;
    coords[i]["y"] = (coords[i]["y"]);

    coords[i]["angle"] = coords[i]["angle"];
  }

  box["width"] = coords[numCards - 1]["x"] + cardWidth;
  box["height"] = coords[numCards - 1]["y"] + cardHeight;

  return coords;
}
