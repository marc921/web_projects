import 'dart:math';
import 'dart:ui';

import 'package:trademarket/entities/city.dart';
import 'package:trademarket/entities/human.dart';
import 'package:trademarket/entities/resource.dart';
import 'package:trademarket/world.model.dart';

class Worker extends Human {
  Worker({Offset position, String name}) : super(position, name, WorldModel.gameDeltaTime * 30);
  Resource producedResource = Resource.values[Random().nextInt(Resource.values.length)];
  Resource consumedResource = Resource.values[Random().nextInt(Resource.values.length)];

  static Worker immigrant(int number) {
    return Worker(
      name: number.toString(),
      position: Offset(0, 0),
    );
  }

  /// City where this worker will be the most needed.
  City dreamCity(List<City> cities) {
    double maxResourcePrice = double.negativeInfinity;
    City dreamCity;
    for (City city in cities) {
      double resourcePrice = city.unitPrice(producedResource);
      if (resourcePrice > maxResourcePrice) {
        maxResourcePrice = resourcePrice;
        dreamCity = city;
      }
    }
    return dreamCity;
  }
}
