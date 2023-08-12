import 'dart:math';
import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  final randomNumbers = <int>[];
  for (var i = 0; i <= 11; i++) {
    randomNumbers.add(random.nextInt(50) + 1);
  }

  var newRandomNumbers = randomNumbers
      .mapIndexed((index, element) =>
          PricePoint(x: index.toDouble(), y: element.toDouble()))
      .toList();

  return newRandomNumbers;
}
