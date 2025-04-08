import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/pages/ui/home_page_background_painter.dart';
import 'package:quail_57/shared/data/generate.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';

class HomePageBackground extends StatefulWidget {
  const HomePageBackground({super.key});

  @override
  State<StatefulWidget> createState() => HomePageBackgroundState();
}

class HomePageBackgroundState extends State<HomePageBackground>
    implements TickerProvider {
  Map<int, Map<int, Space>> background = {};

  late Animation<double> animation;
  late AnimationController controller;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 120),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 6.283).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
    controller.repeat();
  }

  Space getSpace((int, int) where) {
    return (background[where.x] ??= {})[where.y] ??= Generate.space(where.y);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: HomePageBackgroundPainter(
          getSpace: getSpace,
          screen: MediaQuery.of(context).size,
          animation: animation,
        ),
      ),
    );
  }
}
