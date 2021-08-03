import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trademarket/entities/city.dart';
import 'package:trademarket/entities/merchant.dart';
import 'package:trademarket/entities/resource.dart';
import 'package:trademarket/entities/worker.dart';
import 'package:trademarket/world.model.dart';


// TODO: add informators who bring info on prices of cities in other cities
// TODO: Rendre stable : aucune ville n'est constamment en stock/gold négatif,
// TODO: Rendre cohérent : pas de transaction si pas de gold/stock

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Market',
      home: ChangeNotifierProvider<WorldModel>(
        create: (_) => WorldModel(
          cities: [
            City.named('Paris'),
            City.named('Berlin'),
            City.named('Rome'),
            City.named('Varsovie'),
            City.named('Budapest'),
          ],
          merchants: [
            Merchant.named('Jack Silver'),
            Merchant.named('Glasgow Mitt'),
            Merchant.named('Richard Rotschild'),
            Merchant.named('Eoan Mac Eacháin'),
            Merchant.named('Roland Folcard'),
            Merchant.named('Godefray Eudon'),
            Merchant.named('Heinrich Von Postich'),
            /*Merchant.named('Brigandin'),
            Merchant.named('El Loco'),
            Merchant.named('Birjandi'),
            Merchant.named('Huan Xi'),
            Merchant.named('Trouduk'),
            Merchant.named('Louis'),
            Merchant.named('Chloe Rodriguez'),
            Merchant.named('Megan Williams'),
            Merchant.named('Lucy Smith'),
            Merchant.named('Sophie Davis'),
            Merchant.named('Charlotte Wilson'),
            Merchant.named('Jessica Miller'),
            Merchant.named('Emily Garcia'),
            Merchant.named('Olivia Brown'),
            Merchant.named('Amelia Jones'),
            Merchant.named('Holly Johnson'),
            Merchant.named('Louis I'),
            Merchant.named('Louis II'),
            Merchant.named('Louis III'),
            Merchant.named('Louis IV'),
            Merchant.named('Louis V'),
            Merchant.named('Louis VI'),*/
          ],
        ),
        child: Builder(
          // Need a builder to access the context below
          builder: (BuildContext ctx) {
            return WorldMap(ctx.watch<WorldModel>());
          },
        ),
      ),
    );
  }
}

class WorldMap extends StatefulWidget {
  const WorldMap(this.worldModel);
  final WorldModel worldModel;

  @override
  State<StatefulWidget> createState() => WorldMapState();
}

class WorldMapState extends State<WorldMap> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    widget.worldModel.placeEntities();
    Timer.periodic(Duration(milliseconds: (WorldModel.deltaTime * 1000).toInt()), widget.worldModel.tick);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShapePainter(widget.worldModel),
      child: Container(),
    );
  }
  
}

class ShapePainter extends CustomPainter {
  const ShapePainter(this.worldModel);
  final WorldModel worldModel;

  @override
  void paint(Canvas canvas, Size size) {
    if (worldModel.size == null)
      worldModel.setSize(size);

    var workerPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (Worker worker in worldModel.immigrantWorkers) {
      canvas.drawCircle(worker.position, 2, workerPaint);
    }

    // Drawing cities
    var cityPaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final city in worldModel.cities) {
      canvas.drawCircle(city.position, city.size * 0.1, cityPaint);
      final namePainter = TextPainter(
        text: TextSpan(
          text: city.name,
          style: TextStyle(color: Colors.blue),
        ),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr
      )..layout();
      namePainter.paint(canvas, Offset(city.position.dx - namePainter.width * 0.5, city.position.dy - namePainter.height * 1.5));

      final pricesPainter = TextPainter(
        text: TextSpan(
          text: Resource.values.map((r) => city.unitPrice(r).toStringAsFixed(2)).join('\n'),
          style: TextStyle(color: Colors.blue),
        ),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr
      )..layout();
      pricesPainter.paint(canvas, Offset(city.position.dx - pricesPainter.width * 0.5, city.position.dy + pricesPainter.height * 0.5));
    }

    // Drawing merchants
    var merchantPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final merchant in worldModel.merchants) {
      canvas.drawRect(
        Rect.fromCenter(
          center: merchant.position,
          width: math.sqrt(merchant.capacity),
          height: math.sqrt(merchant.capacity),
        ),
        merchantPaint,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${merchant.name}: ${merchant.gold.toInt()}',
          style: TextStyle(color: Colors.orange),
        ),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr
      )..layout();
      textPainter.paint(canvas, Offset(merchant.position.dx - textPainter.width * 0.5, merchant.position.dy - textPainter.height * 1.5));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}