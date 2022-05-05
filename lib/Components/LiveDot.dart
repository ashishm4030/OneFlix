import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:oneflix/Constants.dart';

class BlinkingPoint extends StatefulWidget {
  final double xCoor;
  final double yCoor;
  final Color pointColor;
  final double pointSize;

  BlinkingPoint({
    this.pointSize = 20,
    this.xCoor = 0.0,
    this.yCoor = 0.0,
    this.pointColor = kPrimaryColor,
  });

  @override
  BlinkingPointState createState() => new BlinkingPointState();
}

class BlinkingPointState extends State<BlinkingPoint> with SingleTickerProviderStateMixin {
  Animation? animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: widget.pointSize * 1).animate(animationController!);
    animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController!.reset();
      } else if (status == AnimationStatus.dismissed) {
        animationController!.forward();
      }
    });
    animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LogoAnimation(
      xCoor: widget.xCoor,
      yCoor: widget.yCoor,
      pointColor: widget.pointColor,
      pointSize: widget.pointSize,
      animation: animation,
    );
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }
}

class LogoAnimation extends AnimatedWidget {
  final double xCoor;
  final double yCoor;
  final Color pointColor;
  final double pointSize;

  LogoAnimation({
    this.pointColor = kPrimaryColor,
    Listenable? animation,
    this.pointSize = 20,
    this.xCoor = 2.0,
    this.yCoor = 2.0,
  }) : super(listenable: animation!);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable as Animation<dynamic>;
    return new CustomPaint(
      foregroundPainter: Circle(
        xCoor: xCoor,
        yCoor: yCoor,
        color: pointColor,
        pointSize: pointSize,
        blinkRadius: animation.value,
      ),
    );
  }
}

class Circle extends CustomPainter {
  final Color color;
  final double pointSize;
  final double xCoor;
  final double yCoor;
  final double blinkRadius;

  Circle({
    this.color = kPrimaryColor,
    this.pointSize = 8,
    this.xCoor = 2.0,
    this.yCoor = 2.0,
    this.blinkRadius = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the mid point
    Paint line = new Paint();
    line.strokeCap = StrokeCap.round;
    line.color = color;
    line.strokeWidth = pointSize / 5;
    Offset center = new Offset(xCoor, yCoor / 2);
    double pointRadius = pointSize / 2;

    line.style = PaintingStyle.fill;
    canvas.drawCircle(center, pointRadius, line);

    line.style = PaintingStyle.stroke;
    canvas.drawCircle(center, blinkRadius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
