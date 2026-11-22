import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';

class ForzaMark extends StatelessWidget {
  const ForzaMark({super.key, this.size = 20, this.color = AppColors.accent});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ForzaMarkPainter(color),
    );
  }
}

class _ForzaMarkPainter extends CustomPainter {
  const _ForzaMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final left = size.width * 0.2;
    canvas
      ..drawLine(
        Offset(left, size.height * 0.14),
        Offset(left, size.height * 0.84),
        paint,
      )
      ..drawLine(
        Offset(left, size.height * 0.17),
        Offset(size.width * 0.82, size.height * 0.17),
        paint,
      )
      ..drawLine(
        Offset(left, size.height * 0.48),
        Offset(size.width * 0.82, size.height * 0.48),
        paint,
      );
  }

  @override
  bool shouldRepaint(_ForzaMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

class ForzaWordmark extends StatelessWidget {
  const ForzaWordmark({super.key, this.color = AppColors.textPrimary});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'FORZA',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontFamily: 'Barlow Condensed',
        color: color,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.8,
      ),
    );
  }
}

class ForzaEyebrow extends StatelessWidget {
  const ForzaEyebrow({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge
          ?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
    );
  }
}
