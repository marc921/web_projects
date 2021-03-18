import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_maker/world.model.dart';

enum Terrain {
  deepWater,
  shallowWater,
  land,
  sparseForest,
  denseForest,
}

extension TerrainExt on Terrain {
  Color get color => {
        Terrain.deepWater: Colors.blue[800],
        Terrain.shallowWater: Colors.blue[400],
        Terrain.land: Colors.yellow[100],
        Terrain.sparseForest: Colors.green[400],
        Terrain.denseForest: Colors.green[800],
      }[this];

  double get crossingDifficulty => {
        Terrain.deepWater: 24.0,
        Terrain.shallowWater: 12.0,
        Terrain.land: 1.0,
        Terrain.sparseForest: 8.0,
        Terrain.denseForest: 16.0,
      }[this];
}

class Tile {
  static WorldModel worldModel;
  static double size;
  static Offset centerOffset = Offset(size * 0.5, size * 0.5);
  static get tilesMaxI => worldModel.tiles.length - 1;
  static get tilesMaxJ => worldModel.tiles[0].length - 1;

  Tile(this.i, this.j, this.terrain);
  // (i, j) position in WorldModel.tiles matrix
  int i;
  int j;
  double get x => i * size;
  double get y => j * size;
  Offset get position => Offset(x, y);
  Offset get center => Offset(x, y) + centerOffset;
  Terrain terrain;

  List<Tile> straightLinePeers = [];

  Iterable<Tile> get neighbors => [
        i == 0 || j == 0 ? null : worldModel.tiles[i - 1][j - 1],
        i == 0 ? null : worldModel.tiles[i - 1][j],
        i == 0 || j == tilesMaxJ ? null : worldModel.tiles[i - 1][j + 1],
        j == 0 ? null : worldModel.tiles[i][j - 1],
        j == tilesMaxJ ? null : worldModel.tiles[i][j + 1],
        i == tilesMaxI || j == 0 ? null : worldModel.tiles[i + 1][j - 1],
        i == tilesMaxI ? null : worldModel.tiles[i + 1][j],
        i == tilesMaxI || j == tilesMaxJ ? null : worldModel.tiles[i + 1][j + 1],
      ].where((_) => _ != null);

  double crossingDifficulty(Tile neighbor) {
    // Straight or diagonal neighbors
    final distanceMultiplier = this.i == neighbor.i || this.j == neighbor.j ? 1 : 1.41;
    return distanceMultiplier * Tile.size * 0.5 * (this.terrain.crossingDifficulty + neighbor.terrain.crossingDifficulty);
  }

  double birdPathHeuristic(Tile destination) => (destination.position - this.position).distance * Terrain.land.crossingDifficulty;

  double diagonalPathHeuristic(Tile destination) {
    final di = (destination.i - i).abs();
    final dj = (destination.j - j).abs();
    final diagonal = min(di, dj);
    final straight = max(di, dj) - diagonal;
    return (straight + diagonal * 1.41) * Tile.size * Terrain.land.crossingDifficulty;
  }
}
