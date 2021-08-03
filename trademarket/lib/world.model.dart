import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trademarket/entities/city.dart';
import 'package:trademarket/entities/merchant.dart';
import 'package:trademarket/entities/resource.dart';
import 'package:trademarket/entities/worker.dart';

class WorldModel with ChangeNotifier {
  static const double deltaTime = 0.025;
  static const double gameSpeed = 7;
  static double gameDeltaTime = deltaTime * gameSpeed;
  int tickNumber = 0;

  /// constructor
  WorldModel({this.cities, this.merchants});

  Size size;
  Completer<Size> sizeWaiter = Completer<Size>();

  List<City> cities;
  List<Merchant> merchants;
  List<Worker> immigrantWorkers = [];
  int immigrationPeriod = 10;

  /// Called from the Painter to tell the model the size of the painting canvas.
  void setSize(Size _size) {
    size = _size;
    sizeWaiter.complete(_size);
  }

  /// Executed once at the start to set entities positions once the canvas size is determined.
  void placeEntities() async {
    await sizeWaiter.future;
    for (final city in cities) {
      city.position = Offset(size.width * (0.1 + 0.8 * Random().nextDouble()), size.height * (0.1 + 0.8 * Random().nextDouble()));
    }
    for (final merchant in merchants) {
      merchant.position = Offset(size.width * (0.1 + 0.8 * Random().nextDouble()), size.height * (0.1 + 0.8 * Random().nextDouble()));
    }
    notifyListeners();
  }

  /// Executed every `deltaTime` seconds.
  void tick(Timer t) {
    // Simulate immigration.
    if (tickNumber % immigrationPeriod == 0) immigrantWorkers.add(Worker.immigrant(tickNumber ~/ immigrationPeriod));

    // Move immigrant workers to their dream city.
    for (Worker worker in immigrantWorkers) {
      if (worker.destination == null) worker.updateDestination(worker.dreamCity(cities));
      worker.move();
      if (worker.hasReachedDestination()) {
        worker.destination.workers.add(worker);
        worker.destination.size++;
        immigrantWorkers.remove(worker);
      }
    }

    // Merchants travel and trade.
    for (Merchant merchant in merchants) {
      // Only at first tick
      if (merchant.destination == null) merchant.updateDestination(merchant.nearestCity(cities));

      merchant
        ..move()
        ..gold -= merchant.livingExpense();

      if (merchant.hasReachedDestination()) {
        // Discover the city
        City here = merchant.destination;
        merchant.knownCities[here.name] = City.ghost(here);
        // Choose strategy for next travel
        var maxExpectedProfit = double.negativeInfinity;
        var bestCity;
        var bestCargo;
        for (City city in cities) {
          if (city != here) {
            final stuff = merchant.maxProfitFromTo(here, city);
            final expectedProfit = stuff[0] as double;
            final travelCargo = stuff[1] as Map<Resource, int>;
            if (expectedProfit > maxExpectedProfit) {
              maxExpectedProfit = expectedProfit;
              bestCity = city;
              bestCargo = travelCargo;
            }
          }
        }
        // Adapt current cargo
        merchant.adaptCargo(bestCargo, here);
        merchant.updateDestination(bestCity);
      }
    }

    // Cities produce and pay their workers.
    for (City city in cities) {
      for (Worker worker in city.workers) {
        city.marketStock[worker.producedResource] += gameDeltaTime * 0.1;
        city.marketStock[worker.consumedResource] -= gameDeltaTime * 0.08;
      }
    }
    tickNumber++;
    notifyListeners();
  }

}
