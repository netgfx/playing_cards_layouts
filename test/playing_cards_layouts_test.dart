import 'package:flutter_test/flutter_test.dart';

import 'package:playing_cards_layouts/playing_cards_layouts.dart';

void main() {
  test('adds one to input values', () {
    final cards = fanCards([], {});
    expect(cards.length, 0);
  });
}
