import 'package:flutter/material.dart';

class ToolTipCustomShape extends ShapeBorder {
  final GlobalKey bindWidgetKey;

  const ToolTipCustomShape({required this.bindWidgetKey});

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.only(bottom: 30, top: 10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 20));
    RenderBox renderBox = bindWidgetKey.currentContext?.findRenderObject() as RenderBox;
    double distToWidget = renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width/2 - 5;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 5)))
      ..moveTo(rect.topLeft.dx + distToWidget, rect.topLeft.dy)
      ..relativeLineTo(-10, -10)
      ..relativeLineTo(-10, 10)      
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}