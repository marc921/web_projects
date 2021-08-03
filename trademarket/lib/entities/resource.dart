import 'dart:math';

enum Resource {
  Wood,
  Food,
  Stone,
  Iron,
}

Map<Resource, double> randomNormalizedResourceVector(double multiplier) {
  Map<Resource, double> vector = {};
  final random = Random();
  for (final resource in Resource.values) {
    vector[resource] = random.nextDouble();
  }
  double sum = vector.values.fold(0, (acc, item) => acc + item);
  for (final resource in Resource.values) {
    vector[resource] *= multiplier / sum;
  }
  return vector;
}

Map<Resource, double> equiNormalizedResourceVector(double multiplier) {
  Map<Resource, double> vector = {};
  for (final resource in Resource.values) {
    vector[resource] = (multiplier ?? 1) / Resource.values.length;
  }
  return vector;
}

Map<Resource, int> emptyCargo() {
  Map<Resource, int> cargo = {};
  for (final resource in Resource.values) {
    cargo[resource] = 0;
  }
  return cargo;
}

Map<Resource, double> emptyStock() {
  Map<Resource, double> stock = {};
  for (final resource in Resource.values) {
    stock[resource] = 0;
  }
  return stock;
}
