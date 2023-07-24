import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:genthis_test_task/theme/app_theme.dart';

class _CirclePointHelper {
  static List<Offset> generatePointsWithCircle(
      int count, double innerDiametr, double outDiametr, Size size) {
    final List<Offset> result = [];

    assert(innerDiametr <= outDiametr);

    for (int i = 0; i <= count; i++) {
      double randomAngle = math.Random().nextDouble() * math.pi * 2;
      double randomShift = math.Random().nextDouble() * (outDiametr / 2 - innerDiametr / 2);
      double axisX = (outDiametr / 2 - randomShift) * math.cos(randomAngle) + (size.width / 2);
      double axisY = (outDiametr / 2 - randomShift) * math.sin(randomAngle) + (size.height / 2);

      result.add(Offset(axisX, axisY));
    }

    return result;
  }
}

class AnimatedLoader extends StatelessWidget {
  final Size size = const Size(300, 300);
  const AnimatedLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(children: [
        const Align(alignment: Alignment.center, child: _LightsEffect(duration: 1000, frequency: 100)),
        Align(
            alignment: Alignment.center,
            child: _LuidBackground(size: size, innerDiametr: 200, outDiametr: 250)),
        const Align(alignment: Alignment.center, child: _RotationCircle()),
        const Align(
            alignment: Alignment.center,
            child: Text("85%", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))
      ]),
    );
  }
}

class _LightEffectAnimationContainer {
  final TickerProvider vsync;
  late AnimationController animationController;
  late Animation<double> animation;
  late Offset offset;
  final int duration;

  bool isComplete = false;

  _LightEffectAnimationContainer(this.vsync, {required this.duration}) {
    createLight();
  }

  void createLight() {
    offset = _CirclePointHelper.generatePointsWithCircle(1, 200, 250, const Size(200, 200)).first;

    animationController =
        AnimationController(vsync: vsync, duration: Duration(milliseconds: duration))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              dispose();
              isComplete = true;
            }
          })
          ..forward();

    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
  }

  void dispose() {
    animationController.dispose();
  }
}

class _LightsEffect extends StatefulWidget {
  final int frequency;
  final int duration;
  const _LightsEffect({Key? key, required this.frequency, required this.duration}) : super(key: key);

  @override
  State<_LightsEffect> createState() => __LightsEffectState();
}

class __LightsEffectState extends State<_LightsEffect> with TickerProviderStateMixin {
  final List<_LightEffectAnimationContainer?> elements = [];

  void addLight() {
    elements.add(_LightEffectAnimationContainer(this, duration: widget.duration));
  }

  void garbageClear() async {
    for (var element in elements) {
      if (element!.isComplete) {
        element = null;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    garbageClear();
  }

  void lightsFlow() async {
    await Future.delayed(Duration(milliseconds: widget.frequency));
    addLight();

    lightsFlow();
  }

  @override
  void initState() {
    super.initState();

    lightsFlow();
    garbageClear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(16.0),
              width: 240,
              height: 240,
              child: CustomPaint(
                painter: LightsPaint(elements),
              )),
        ],
      ),
    );
  }
}

class LightsPaint extends CustomPainter {
  final List<_LightEffectAnimationContainer?> elements;

  LightsPaint(this.elements);

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in elements) {
      if (element!.isComplete) continue;

      final Paint paint = Paint();
      paint
        ..color = DesignColors.mainColor.withAlpha(255 - (element.animation.value * 255).toInt())
        ..style = PaintingStyle.fill;

      canvas.drawCircle(element.offset, element.animation.value * 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _LuidBackground extends StatefulWidget {
  final double innerDiametr;
  final double outDiametr;
  final Size size;
  const _LuidBackground(
      {Key? key, required this.innerDiametr, required this.outDiametr, required this.size})
      : super(key: key);

  @override
  State<_LuidBackground> createState() => __LuidBackgroundState();
}

class __LuidBackgroundState extends State<_LuidBackground> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationControllerRotation;
  late Animation<double> animation;
  late Animation<double> animationRotation;
  late List<double> shiftRandoms;
  late List<double> shiftRandoms2;

  final int countPoints = 26;

  @override
  void initState() {
    super.initState();

    shiftRandoms = List.generate(countPoints, (index) => math.Random().nextDouble());
    shiftRandoms2 = List.generate(countPoints, (index) => math.Random().nextDouble());

    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              regenerateShifts();
              animationController.forward(from: 0);
              //setState(() {});
            }
          })
          ..forward();

    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationControllerRotation =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();

    animationRotation = Tween<double>(begin: 0, end: 1).animate(animationControllerRotation);
  }

  @override
  void dispose() {
    super.dispose();

    animationController.dispose();
    animationControllerRotation.dispose();
  }

  void regenerateShifts() {
    shiftRandoms = List.from(shiftRandoms2);
    shiftRandoms2 = List.generate(countPoints, (index) => math.Random().nextDouble());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            width: 240,
            height: 240,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animationRotation.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size.square(300),
                    painter: BackgroundAnimation(shiftRandoms, shiftRandoms2, animation.value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RotationCircle extends StatefulWidget {
  const _RotationCircle({Key? key}) : super(key: key);

  @override
  State<_RotationCircle> createState() => _RotationCircleState();
}

class _RotationCircleState extends State<_RotationCircle> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.repeat();
        }
      })
      ..forward();

    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animation.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size.square(100),
                    painter: LoadingCircle(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DistanceVariator {
  List<double> variants = [-1, 0, 1];
  int _current = 0;

  double getDist() {
    if (_current == (variants.length - 1)) {
      variants = List.from(variants.reversed);
      _current = 0;
    }

    var result = variants[_current];

    _current++;

    return result;
  }
}

class BackgroundAnimation extends CustomPainter {
  late final List<double> shiftRandoms;
  late final List<double> shiftRandoms2;
  late final double animationValue;

  BackgroundAnimation(this.shiftRandoms, this.shiftRandoms2, this.animationValue);

  final distanceVariator = DistanceVariator();

  @override
  void paint(Canvas canvas, Size size) {
    double innerDiametr = 180;
    double outDiametr = 200;

    final paint = Paint()
      ..color = const Color(0xff46153b)
      ..style = PaintingStyle.fill;


    final List<Offset> points = [];

    double anglePice = (2 * math.pi) / shiftRandoms.length;
    double angle = 0;

    shiftRandoms.asMap().forEach((key, random) {
      double randomAngle = angle;
      double distVar = distanceVariator.getDist();
      double randomShift = shiftRandoms[key] * (outDiametr / 2 - innerDiametr / 2) * distVar;
      double randomShift2 = shiftRandoms2[key] * (outDiametr / 2 - innerDiametr / 2) * distVar;

      randomShift += (randomShift2 - randomShift) * animationValue;

      double axisX = (outDiametr / 2 + randomShift) * math.cos(randomAngle) + (size.width / 2);
      double axisY = (outDiametr / 2 + randomShift) * math.sin(randomAngle) + (size.height / 2);

      angle += anglePice;

      points.add(Offset(axisX, axisY));
    });

    final path = Path();

    points.removeRange(points.length - (points.length % 2), points.length);

    int stopControl = 0;
    final firstPoint = Offset(points.first.dx, points.first.dy);
    path.moveTo(firstPoint.dx, firstPoint.dy);
    while (points.isNotEmpty) {
      stopControl++;
      if (stopControl > 100) break;

      var point1 = points[0];
      var point2 = points[1];
      path.conicTo(point1.dx, point1.dy, point2.dx, point2.dy, 2);
      points.removeRange(0, 2);
    }

    path.quadraticBezierTo(firstPoint.dx, firstPoint.dy, firstPoint.dx, firstPoint.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LoadingCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = 25;
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    const gradient = SweepGradient(
      startAngle: 3 * math.pi / 2,
      endAngle: 7 * math.pi / 2,
      tileMode: TileMode.repeated,
      colors: [Colors.transparent, DesignColors.mainColor],
    );

    final paint1 = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;
    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xffa10a70)
      ..strokeWidth = width;

    final paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withAlpha(50)
      ..strokeWidth = width / 2;

    final paint4 = Paint()
      ..style = PaintingStyle.fill
      ..color = DesignColors.backgroundColor;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (width / 2);
    const startAngle = -math.pi / 3;
    const sweepAngle = 2 * math.pi * 0.89;
    canvas.drawCircle(center, radius, paint4);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, 2 * math.pi, false, paint2);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - (width / 4)), 0, 2 * math.pi,
        false, paint3);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
