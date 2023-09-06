import 'package:flutter/material.dart';

class DashedBorder extends StatefulWidget {
  final Color color;
  final double strokeWidth;
  final double dotsWidth;
  final double gap;
  final double radius;
  final Widget child;
  final EdgeInsets? padding;

  const DashedBorder({
    Key? key,
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dotsWidth = 5.0,
    this.gap = 3.0,
    this.radius = 0,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  State<DashedBorder> createState() => _DashedBorderState();
}

class _DashedBorderState extends State<DashedBorder> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedCustomPaint(
        color: widget.color,
        dottedLength: widget.dotsWidth,
        space: widget.gap,
        strokeWidth: widget.strokeWidth,
        radius: widget.radius,
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(2),
        child: widget.child,
      ),
    );
  }
}

class _DottedCustomPaint extends CustomPainter {
  final Color color;
  final double dottedLength;
  final double space;
  final double strokeWidth;
  final double radius;

  _DottedCustomPaint({
    required this.color,
    required this.dottedLength,
    required this.space,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Path path = Path();
    path.addRRect(RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(radius),
    ));

    // Calculate the dashed path manually
    double distance = 0;
    bool draw = true;
    while (distance < path.computeMetrics().single.length) {
      final double length = draw ? dottedLength : space;
      final double remainingLength = path.computeMetrics().single.length - distance;
      final double segmentLength = remainingLength < length ? remainingLength : length;
      final Path segmentPath = path.computeMetrics().single.extractPath(distance, distance + segmentLength);
      if (draw) {
        canvas.drawPath(segmentPath, paint);
      }
      distance += length;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
