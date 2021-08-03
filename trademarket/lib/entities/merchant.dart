import 'dart:math';
import 'dart:ui';

import 'package:trademarket/entities/human.dart';
import 'package:trademarket/entities/city.dart';
import 'package:trademarket/entities/resource.dart';
import 'package:trademarket/world.model.dart';

class Merchant extends Human {
  Merchant({Offset position, String name, this.capacity, this.gold}) : super(position, name, null);
  
  /// His horse may be fast as the wind, or his caravan as slow as a snail. Between 10 and 100.
  final double capacity;
  /// Amounts carried of each Resource.
  Map<Resource, int> cargo = emptyCargo();
  int cargoSize() => cargo.values.fold(0, (acc, item) => acc + item);
  void updateSpeed() => speed = WorldModel.gameDeltaTime * 10 * (1 + 120 / (capacity * 0.5 + cargoSize()));
  /// Purse content, used to buy resources and filled by sales.
  double gold = 100;
  /// Gold consumption over time by merchant and caravan.
  double livingExpense() => WorldModel.gameDeltaTime * (1 + capacity * 0.01);

  /// Information about cities for trade estimations.
  Map<String, City> knownCities = {};

  static Merchant named(name) {
    return Merchant(
      name: name,
      position: Offset(0, 0),
      capacity: 10 + 90 * Random().nextDouble(),
      gold: 1000 * Random().nextDouble(),
    )..updateSpeed();
  }

  /// Returns the loss in living expenses due to the carrying of 1 more unit in cargo.
  double travelExpenseAddition(double travelDistance, int cargoSize) {
    final travelPerSecond = 2 * (1 + 120 / (capacity * 0.3 + cargoSize));
    final secondsInTravel = travelDistance / travelPerSecond;
    final travelPerSecondWithAddition = 2 * (1 + 120 / (capacity * 0.3 + cargoSize + 1));
    final secondsInTravelWithAddition = travelDistance / travelPerSecondWithAddition;
    final livingExpensePerSecond = (1 + capacity * 0.01);
    return (secondsInTravelWithAddition - secondsInTravel) * livingExpensePerSecond;
  }

  /// [0] is the expected sell profit, [1] is the cargo
  List maxProfitFromTo(City here, City there) {
    double travelDistance = sqrt(squareDist(position, there.position));
    // Clone to fake buy/sell in their stocks.
    City hereClone = City.ghost(here);
    City thereClone = City.ghost(there);  // should be known ghost

    double expectedProfit = 0;
    Map<Resource, int> _cargo = {}..addAll(cargo);
    var _cargoSize = cargoSize();
    
    // Choose what to sell in current cargo
    for (final resource in Resource.values) {
      // while it's better to sell here than travel there and sell it there
      while(_cargo[resource] > 0 && 
        hereClone.unitSellPrice(resource) > thereClone.unitSellPrice(resource) - travelExpenseAddition(travelDistance, _cargoSize - 1)
      ) {
        // sell it here
        gold += hereClone.unitSellPrice(resource);
        hereClone.marketStock[resource]++;
        _cargo[resource]--;
        _cargoSize--;
        expectedProfit += hereClone.unitSellPrice(resource);
      }
    }

    // Choose what to buy here
    while(_cargoSize <= capacity - 1) {
      // search best resource to buy and sell
      var maxGap = travelExpenseAddition(travelDistance, _cargoSize);  // buying threshold: worth carrying
      var maxResource;
      for (final resource in Resource.values) {
        final gap = thereClone.unitSellPrice(resource) - hereClone.unitBuyPrice(resource);
        if (gold > hereClone.unitBuyPrice(resource) && gap > maxGap) {
          maxGap = gap;
          maxResource = resource;
        }
      }
      if (maxResource != null) {  // some resource is worth trading: fake buy and sell
        gold -= hereClone.unitBuyPrice(maxResource);
        hereClone.marketStock[maxResource]--;
        _cargo[maxResource]++;
        _cargoSize++;
        thereClone.marketStock[maxResource]++;
        expectedProfit += maxGap;
      } else {  // no resource is worth trading: stop search
        break;
      }
    }
    return [expectedProfit, _cargo];
  }

  /// Sell and buy until `cargo` becomes like `newCargo`.
  /// This assumes that `newCargo` won't cost more than merchant has `gold` (after surplus sell).
  void adaptCargo(Map<Resource, int> newCargo, City city) {
    // sell surplus, get gold for buy
    for (Resource resource in Resource.values) {
      while (cargo[resource] > newCargo[resource]) {
        sellUnit(resource, city);
      }
    }
    // buy resources for travel
    for (Resource resource in Resource.values) {
      while (cargo[resource] < newCargo[resource]) {
        buyUnit(resource, city);
      }
    }
    // update speed now that cargo size has changed
    updateSpeed();
  }

  void buyUnit(Resource resource, City city) {
    final price = city.unitBuyPrice(resource);
    gold -= price;
    city.gold += price;
    city.marketStock[resource]--;
    cargo[resource]++;
  }
  void sellUnit(Resource resource, City city) {
    final price = city.unitSellPrice(resource);
    gold += price;
    city.gold -= price;
    city.marketStock[resource]++;
    cargo[resource]--;
  }
}