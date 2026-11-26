import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Shows the app's circular brand reveal once for each cold app launch.
class LaunchReveal extends StatefulWidget {
  const LaunchReveal({
    super.key,
    required this.child,
    required this.isDark,
    required this.isReady,
  });

  final Widget child;
  final bool isDark;
  final bool isReady;

  @override
  State<LaunchReveal> createState() => _LaunchRevealState();
}

class _LaunchRevealState extends State<LaunchReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..addStatusListener(_handleStatus);
  bool _started = false;
  bool _finished = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startWhenReady();
  }

  @override
  void didUpdateWidget(covariant LaunchReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _startWhenReady();
  }

  void _startWhenReady() {
    if (_started || _finished || !widget.isReady) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _finished = true;
      return;
    }
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_finished) _controller.forward();
    });
  }

  void _handleStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _finished) return;
    setState(() => _finished = true);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return widget.child;

    final baseColor = widget.isDark ? Colors.black : Colors.white;
    final revealColor = widget.isDark ? Colors.white : Colors.black;
    final baseTextColor = widget.isDark ? Colors.white : Colors.black;
    final revealTextColor = widget.isDark ? Colors.black : Colors.white;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (MediaQuery.disableAnimationsOf(context))
          const SizedBox.shrink()
        else
          Positioned.fill(
            key: const Key('launch-reveal-overlay'),
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final revealProgress = Curves.easeInOutQuart.transform(
                      (_controller.value / 0.82).clamp(0.0, 1.0).toDouble(),
                    );
                    final fadeProgress = Curves.easeOut.transform(
                      ((_controller.value - 0.82) / 0.18)
                          .clamp(0.0, 1.0)
                          .toDouble(),
                    );
                    return Opacity(
                      opacity: 1 - fadeProgress,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(
                            key: const Key('launch-reveal-base'),
                            color: baseColor,
                          ),
                          ClipPath(
                            key: const Key('launch-reveal-circle'),
                            clipper: _CircularRevealClipper(revealProgress),
                            child: ColoredBox(
                              key: const Key('launch-reveal-circle-color'),
                              color: revealColor,
                            ),
                          ),
                          ClipPath(
                            clipper: _OutsideRevealClipper(revealProgress),
                            child: Center(child: _brandText(baseTextColor)),
                          ),
                          ClipPath(
                            clipper: _CircularRevealClipper(revealProgress),
                            child: Center(child: _brandText(revealTextColor)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _brandText(Color color) => Text(
    'FORZA',
    style: TextStyle(
      fontFamily: 'Barlow Condensed',
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.8,
      color: color,
      decoration: TextDecoration.none,
    ),
  );
}

class _CircularRevealClipper extends CustomClipper<Path> {
  const _CircularRevealClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.sqrt(center.dx * center.dx + center.dy * center.dy);
    return Path()..addOval(
      Rect.fromCircle(center: center, radius: radius * progress + 0.01),
    );
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) =>
      oldClipper.progress != progress;
}

class _OutsideRevealClipper extends CustomClipper<Path> {
  const _OutsideRevealClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final wholeScreen = Path()..addRect(Offset.zero & size);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.sqrt(center.dx * center.dx + center.dy * center.dy);
    final revealCircle = Path()
      ..addOval(
        Rect.fromCircle(center: center, radius: radius * progress + 0.01),
      );
    return Path.combine(PathOperation.difference, wholeScreen, revealCircle);
  }

  @override
  bool shouldReclip(_OutsideRevealClipper oldClipper) =>
      oldClipper.progress != progress;
}
