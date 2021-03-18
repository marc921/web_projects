import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_maker/traveler.dart';
import 'package:path_maker/tile.dart';
import 'package:fast_noise/fast_noise.dart' as noise;

class WorldModel with ChangeNotifier {
  static const double deltaTime = 0.025;
  static const double gameSpeed = 10;
  static double gameDeltaTime = deltaTime * gameSpeed;
  int tickNumber = 0;

  List<List<Tile>> tiles;
  List<Traveler> travelers = [];

  void initTiles(Size size, double tileSize) {
    Tile.worldModel = this;
    Tile.size = tileSize;
    final w = size.width ~/ Tile.size;
    final h = size.height ~/ Tile.size;
    final perlinNoise = noise.PerlinNoise(seed: Random().nextInt(1000));
    tiles = List<List<Tile>>.generate(
      w,
      (i) => List<Tile>.generate(h, (j) {
        final noiseRawHeight = perlinNoise.getPerlin2((i * Tile.size * 0.5).toDouble(), (j * Tile.size * 0.5).toDouble());
        final terrainIndex = ((noiseRawHeight + 1) * 5 * 0.5).toInt();
        return Tile(i, j, Terrain.values[terrainIndex]);
      }),
    );
  }

  Tile randomTile() => tiles[Random().nextInt(tiles.length)][Random().nextInt(tiles[0].length)];

  void initTraveller() {
    Traveler.worldModel = this;
  }

  void addTraveller(int n) {
    for (var i = 0; i < n; i++) {
      final startTile = randomTile();
      travelers.add(
        Traveler(
          Offset(
            (startTile.i + 0.5) * Tile.size,
            (startTile.j + 0.5) * Tile.size,
          ),
        )..findPath(randomTile()),
      );
    }
  }

  /// Executed every `deltaTime` seconds.
  void tick(_) {
    for (final traveler in travelers) {
      if (traveler.path == null || traveler.path.isEmpty) {
        traveler.findPath(randomTile());
      } else {
        traveler.followPath();
      }
    }
    notifyListeners();
  }
}
