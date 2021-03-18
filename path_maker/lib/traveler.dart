import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:path_maker/tile.dart';
import 'package:path_maker/world.model.dart';

// TODO: make this class a ChangeNotifier
class Traveler {
  static WorldModel worldModel;

  /// ==== DISPLAY ====
  static final double size = Tile.size * 0.5;
  static const color = Colors.orange;
  static final double pathLandmarkSize = Tile.size * 0.4;
  static const pathLandmarkColor = Colors.purple;

  static const speed = 20;

  Traveler(this.position);
  Offset position;
  List<Tile> path;

  Tile get tile => worldModel.tiles[position.dx ~/ Tile.size][position.dy ~/ Tile.size];

  /// ========= MOVING ================

  void followPath() {
    if (path == null || path.isEmpty) return;
    var allowedMovement = speed * WorldModel.gameDeltaTime / tile.terrain.crossingDifficulty;
    while ((path.first.center - position).distance < allowedMovement) {
      allowedMovement -= (path.first.center - position).distance;
      position = path.first.center;
      path.removeAt(0);
      if (path.isEmpty) return;
    }
    position += (path.first.center - position) * allowedMovement / (path.first.center - position).distance;
  }

  /// ========= PATH-FINDING ==========
  /// Recognize straight lines and make a network of nodes in Tiles,
  /// with slightly reduced heuristic (* 0.9?) to encourage navigating through nodes.
  void reconstructPath(Map<Tile, Tile> cameFrom, Tile current) {
    final _path = [current];
    Tile straightLineEnd;
    Tile straightLineBeginning;
    int straightLineLength = 0;
    Offset straightLineDirection;
    while (cameFrom[current] != null) {
      final direction = Offset((current.i - cameFrom[current].i).toDouble(), (current.j - cameFrom[current].j).toDouble());
      // Good conditions for straight line
      if (current.terrain == Terrain.land && cameFrom[current].terrain == Terrain.land) {
        if (straightLineDirection == null) {
          // Can start a new straight line
          straightLineDirection = direction;
          straightLineLength = 1;
          straightLineEnd = current;
          straightLineBeginning = cameFrom[current];
        } else if (straightLineDirection == direction) {
          // Continue existing straight line
          straightLineLength++;
          straightLineBeginning = cameFrom[current];
        }
      }
      // Bad conditions for straight line
      if (cameFrom[current].terrain != Terrain.land || straightLineDirection != direction) {
        if (straightLineLength >= 3) {
          // Straight line is worth something: save it
          straightLineBeginning.straightLinePeers.add(straightLineEnd);
          straightLineEnd.straightLinePeers.add(straightLineBeginning);
        }

        straightLineDirection = null;
        straightLineLength = 0;
        straightLineEnd = null;
        straightLineBeginning = null;
      }

      current = cameFrom[current];
      _path.add(current);
    }
    path = _path.reversed.toList();
  }

  // A* finds a path from start to goal.
  void findPath(Tile destination) {
    var sw = new Stopwatch()..start();

    // For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start
    // to n currently known.
    Map<Tile, Tile> cameFrom = {};

    // For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
    Map<Tile, double> gScore = {}; // default = infinity
    final _gScore = (Tile t) => gScore[t] ?? double.infinity;
    gScore[tile] = 0;

    // For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
    // how short a path from start to finish can be if it goes through n.
    Map<Tile, double> fScore = {}; // default = infinity
    final _fScore = (Tile t) => fScore[t] ?? double.infinity;
    fScore[tile] = tile.diagonalPathHeuristic(destination);

    // The set of discovered nodes that may need to be (re-)expanded.
    // Initially, only the start node is known.
    // This is usually implemented as a min-heap or priority queue rather than a hash-set.
    HeapPriorityQueue<Tile> discoveredTiles = HeapPriorityQueue(
      (Tile a, Tile b) => (_fScore(a) - _fScore(b)).toInt(),
    );
    discoveredTiles.add(tile);
    var k = 0;
    while (discoveredTiles.isNotEmpty) {
      k++;
      // This operation can occur in O(1) time if openSet is a min-heap or a priority queue
      final current = discoveredTiles.first;
      if (current == destination) {
        reconstructPath(cameFrom, current);
        print('ms: ${sw.elapsed.inMilliseconds} ${k ~/ (sw.elapsed.inMilliseconds+1)}');
        return;
      }

      discoveredTiles.removeFirst();
      for (final peer in current.straightLinePeers) {
        final gScoreAttempt = _gScore(current) + current.diagonalPathHeuristic(peer) * 0.9;
        if (gScoreAttempt < _gScore(peer)) {
          // This path to peer is better than any previous one. Record it!
          cameFrom[peer] = current;
          gScore[peer] = gScoreAttempt;
          fScore[peer] = _gScore(peer) + peer.diagonalPathHeuristic(destination);
          if (!discoveredTiles.contains(peer)) {
            discoveredTiles.add(peer);
          }
        }
      }
      for (final neighbor in current.neighbors) {
        // current.crossingDifficulty(neighbor) is the weight of the edge from current to neighbor
        // gScoreAttempt is the distance from start to the neighbor through current
        final gScoreAttempt = _gScore(current) + current.crossingDifficulty(neighbor);
        if (gScoreAttempt < _gScore(neighbor)) {
          // This path to neighbor is better than any previous one. Record it!
          cameFrom[neighbor] = current;
          gScore[neighbor] = gScoreAttempt;
          fScore[neighbor] = _gScore(neighbor) + neighbor.diagonalPathHeuristic(destination);
          if (!discoveredTiles.contains(neighbor)) {
            discoveredTiles.add(neighbor);
          }
        }
      }
    }
    // Open set is empty but goal was never reached
    return null;
  }
}
