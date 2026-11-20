import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';

class ProgressLineChart extends StatelessWidget {
  const ProgressLineChart({
    super.key,
    required this.values,
    required this.labels,
    required this.summary,
    this.lineColor = AppColors.textPrimary,
  });

  final List<double> values;
  final List<String> labels;
  final String summary;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: summary,
      child: ExcludeSemantics(
        child: SizedBox(
          width: double.infinity,
          height: 190,
          child: CustomPaint(
            painter: _ProgressChartPainter(
              values: values,
              labels: labels,
              lineColor: lineColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  const _ProgressChartPainter({
    required this.values,
    required this.labels,
    required this.lineColor,
  });

  final List<double> values;
  final List<String> labels;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.width <= 0 || size.height <= 0) return;

    const left = 12.0;
    const right = 12.0;
    const top = 12.0;
    const bottom = 30.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;
    if (chartWidth <= 0 || chartHeight <= 0) return;

    final plot = Rect.fromLTWH(left, top, chartWidth, chartHeight);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var row = 0; row <= 3; row++) {
      final y = plot.top + plot.height * row / 3;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    }

    final minimum = values.reduce((a, b) => a < b ? a : b);
    final maximum = values.reduce((a, b) => a > b ? a : b);
    final span = (maximum - minimum).abs() < 0.001 ? 1.0 : maximum - minimum;
    final points = <Offset>[];

    for (var index = 0; index < values.length; index++) {
      final x = values.length == 1
          ? plot.center.dx
          : plot.left + plot.width * index / (values.length - 1);
      final y = plot.bottom - (values[index] - minimum) / span * plot.height;
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      linePath.lineTo(points[index].dx, points[index].dy);
    }

    final areaPath = Path.from(linePath)
      ..lineTo(points.last.dx, plot.bottom)
      ..lineTo(points.first.dx, plot.bottom)
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..color = lineColor.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    final pointPaint = Paint()..color = lineColor;
    final innerPointPaint = Paint()..color = AppColors.surface;
    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 2.5, innerPointPaint);
    }

    if (labels.isNotEmpty) {
      _paintLabel(
        canvas,
        labels.first,
        Offset(plot.left, size.height - 18),
        TextAlign.left,
      );
      if (labels.length > 1) {
        _paintLabel(
          canvas,
          labels.last,
          Offset(plot.right, size.height - 18),
          TextAlign.right,
        );
      }
    }
  }

  void _paintLabel(
    Canvas canvas,
    String label,
    Offset position,
    TextAlign align,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    final offset = align == TextAlign.right
        ? Offset(position.dx - painter.width, position.dy)
        : position;
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ProgressChartPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.labels != labels ||
      oldDelegate.lineColor != lineColor;
}
