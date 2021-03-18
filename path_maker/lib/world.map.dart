import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_maker/rect.painter.dart';
import 'package:path_maker/tile.dart';
import 'package:path_maker/travelers.path.stack.dart';
import 'package:provider/provider.dart';
import 'package:path_maker/world.model.dart';

class WorldMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WorldMapState();
}

class WorldMapState extends State<WorldMap> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final worldModel = context.read<WorldModel>()
      ..initTiles(Size(1680, 1040), 10)
      ..initTraveller()
      ..addTraveller(2);
    Timer.periodic(Duration(milliseconds: (1000 * WorldModel.deltaTime).toInt()), worldModel.tick);
  }

  @override
  Widget build(BuildContext context) {
    final tiles = context.select<WorldModel, List<List<Tile>>>((model) => model.tiles);
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent e) {
        /*if (e.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          setState(() => camera = camera.translate(0, -10));
        }*/
      },
      child: Stack(
        children: [
          // Terrain - Tiles
          for (final column in tiles)
            for (final tile in column)
              Positioned(
                left: tile.x,
                top: tile.y,
                child: CustomPaint(
                  painter: RectPainter(
                    Tile.size,
                    tile.terrain.color,
                  ),
                ),
              ),
          TravelersPathStack(),
        ],
      ),
    );
  }
}
