import 'package:flutter/material.dart';
import 'package:path_maker/rect.painter.dart';
import 'package:path_maker/tile.dart';
import 'package:path_maker/traveler.dart';
import 'package:path_maker/world.model.dart';
import 'package:provider/provider.dart';

class TravelersPathStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelers = context.watch<WorldModel>().travelers;
    return Stack(
      children: [
        for (final traveller in travelers) ...[
          // Travellers' paths
          if (traveller.path != null)
            for (final tile in traveller.path)
              Positioned(
                left: tile.x + (Tile.size - Traveler.pathLandmarkSize) * 0.5,
                top: tile.y + (Tile.size - Traveler.pathLandmarkSize) * 0.5,
                child: CustomPaint(
                  painter: RectPainter(
                    Traveler.pathLandmarkSize,
                    Traveler.pathLandmarkColor,
                  ),
                ),
              ),
          // Travellers
          Positioned(
            left: traveller.position.dx - Traveler.size * 0.5,
            top: traveller.position.dy - Traveler.size * 0.5,
            child: CustomPaint(
              painter: RectPainter(
                Traveler.size,
                Traveler.color,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
