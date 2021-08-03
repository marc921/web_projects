import 'dart:math';
import 'dart:ui';

import 'package:trademarket/entities/resource.dart';
import 'package:trademarket/entities/worker.dart';

class City {
  City({this.position, this.name, this.size, this.workers, this.marketStock, this.gold});
  static const slavePrice = 10;

  /// Where the City is on the world map.
  Offset position;

  /// Name to show on tooltip
  final String name;
  /// Number of citizens in the city.
  /// Influences total production, consumption, and market prices (as the same amount in stock will be a lot or little depending on the city size).
  /// People can be bought or sold at an unimplemented slave market for gold.
  int size;
  List<Worker> workers;
  Map<Resource, double> marketStock;
  double unitPrice(Resource resource) => marketStock[resource] < 0 ? double.nan : size / marketStock[resource];
  /// Price merchant will pay to buy one unit of resource in this city.
  double unitBuyPrice(Resource resource) => marketStock[resource] < 0 ? double.infinity : size / (marketStock[resource] - 1);
  /// Price merchant will get to sell one unit of resource in this city.
  double unitSellPrice(Resource resource) => marketStock[resource] < 0 ? size.toDouble() : size / (marketStock[resource] + 1);
  double gold;


  static City named(name) {
    List<Worker> workers = List.generate(
      (Resource.values.length * (1 + Random().nextDouble())).toInt(),
      (int number) => Worker.immigrant(-number),
    );
    return City(
      name: name,
      position: Offset(0, 0),
      size: workers.length,
      workers: workers,
      gold: workers.length * 5 * Random().nextDouble(),
      marketStock: equiNormalizedResourceVector(10),
    );
  }

  static City ghost(City real) {
    return City(
      size: real?.size ?? 200,
      marketStock: real != null
        ? ({}..addAll(real.marketStock))
        : emptyStock(),
    );
  }
}