import 'dart:math';
import 'dart:ui';

import 'package:trademarket/entities/city.dart';

double squareDist(Offset a, Offset b) => pow(b.dx - a.dx, 2) + pow(b.dy - a.dy, 2);

class Human {
  Human(this.position, this.name, this.speed);
  /// Where the Human is on the world map.
  Offset position;
  City destination;
  Offset toDest1;
  double speed;
  
  /// Everyone has a name, to be written in the Book of Eternity.
  final String name;

  City nearestCity(List<City> cities) {
    var minDist = double.infinity;
    var nearestCity;
    for (final city in cities) {
      final dist = squareDist(city.position, position);
      if (dist < minDist) {
        nearestCity = city;
        minDist = dist;
      }
    }
    return nearestCity;
  }

  void updateDestination(City dest) {
    destination = dest;
    var toDest = Offset(destination.position.dx - position.dx, destination.position.dy - position.dy);
    toDest1 = toDest / toDest.distance;
  }

  void move() {
    position += toDest1 * speed;
  }

  bool hasReachedDestination() => (destination.position.dx - position.dx) * toDest1.dx < 0;
}
