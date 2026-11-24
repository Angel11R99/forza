import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class ExerciseFlipCard extends StatefulWidget {
  const ExerciseFlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.frontHint,
    required this.backHint,
  });

  final Widget front;
  final Widget back;
  final String frontHint;
  final String backHint;

  @override
  State<ExerciseFlipCard> createState() => _ExerciseFlipCardState();
}

class _ExerciseFlipCardState extends State<ExerciseFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  )..addStatusListener(_handleAnimationStatus);
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  Animation<double>? _angleAnimation;
  double _restingAngle = 0;
  double _targetAngle = 0;
  double _dragProgress = 0;
  double _dragDistance = 0;
  double _cardWidth = 220;
  bool _showingBack = false;
  bool _isDragging = false;
  bool _isAnimating = false;

  double get _visibleAngle {
    if (_isDragging) {
      return _showingBack
          ? math.pi * (1 - _dragProgress)
          : math.pi * _dragProgress;
    }
    return _angleAnimation?.value ?? _restingAngle;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) &&
        (_isAnimating || _isDragging)) {
      _controller.stop();
      _restingAngle = _showingBack ? math.pi : 0;
      _angleAnimation = null;
      _isAnimating = false;
      _isDragging = false;
      _dragProgress = 0;
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    setState(() {
      _restingAngle = _targetAngle;
      _angleAnimation = null;
      _isAnimating = false;
    });
  }

  void _flip() {
    if (_isAnimating || _isDragging) return;
    final showBack = !_showingBack;
    final angle = _visibleAngle;
    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() {
        _showingBack = showBack;
        _restingAngle = showBack ? math.pi : 0;
        _angleAnimation = null;
      });
      return;
    }
    _animateTo(showBack: showBack, fromAngle: angle);
  }

  void _animateTo({required bool showBack, required double fromAngle}) {
    final targetAngle = showBack ? math.pi : 0.0;
    setState(() {
      _showingBack = showBack;
      _targetAngle = targetAngle;
      _isAnimating = true;
      _angleAnimation = Tween<double>(
        begin: fromAngle,
        end: targetAngle,
      ).animate(_curve);
    });
    _controller.forward(from: 0);
  }

  void _handleHorizontalDragStart(DragStartDetails details) {
    if (_isAnimating) return;
    _isDragging = true;
    _dragProgress = 0;
    _dragDistance = 0;
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      _dragProgress = (_dragProgress + details.delta.dx.abs() / _cardWidth)
          .clamp(0.0, 1.0)
          .toDouble();
      _dragDistance += details.delta.dx.abs();
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    final fromAngle = _visibleAngle;
    final shouldFlip =
        _dragDistance >= 48 || (details.primaryVelocity?.abs() ?? 0) >= 250;
    final showBack = shouldFlip ? !_showingBack : _showingBack;
    _isDragging = false;
    _dragProgress = 0;
    _dragDistance = 0;

    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() {
        _showingBack = showBack;
        _restingAngle = showBack ? math.pi : 0;
      });
      return;
    }
    _animateTo(showBack: showBack, fromAngle: fromAngle);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    _curve.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      _cardWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
          ? constraints.maxWidth
          : 220;
      final reduceMotion = MediaQuery.disableAnimationsOf(context);

      return Semantics(
        key: const Key('exercise-flip-card-semantics'),
        container: true,
        button: true,
        onTap: _isAnimating ? null : _flip,
        hint: _showingBack ? widget.backHint : widget.frontHint,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            excludeFromSemantics: true,
            behavior: HitTestBehavior.opaque,
            onTap: _isAnimating ? null : _flip,
            onHorizontalDragStart: reduceMotion || _isAnimating
                ? null
                : _handleHorizontalDragStart,
            onHorizontalDragUpdate: reduceMotion || _isAnimating
                ? null
                : _handleHorizontalDragUpdate,
            onHorizontalDragEnd: reduceMotion || _isAnimating
                ? null
                : _handleHorizontalDragEnd,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final angle = _visibleAngle;
                final isBackFace = angle >= math.pi / 2;
                final face = reduceMotion
                    ? (_showingBack ? widget.back : widget.front)
                    : isBackFace
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: widget.back,
                      )
                    : widget.front;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(reduceMotion ? 0 : angle),
                  child: face,
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
