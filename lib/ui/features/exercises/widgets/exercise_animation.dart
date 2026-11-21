import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../app/theme/app_colors.dart';

class ExerciseAnimationView extends StatefulWidget {
  const ExerciseAnimationView({
    super.key,
    required this.animation,
    required this.label,
  });

  final ExerciseAnimation? animation;
  final String label;

  @override
  State<ExerciseAnimationView> createState() => _ExerciseAnimationViewState();
}

class _ExerciseAnimationViewState extends State<ExerciseAnimationView>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _sequenceIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPlayback();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _syncPlayback();
  }

  void _syncPlayback() {
    final animation = widget.animation;
    final shouldPlay =
        animation != null &&
        !MediaQuery.disableAnimationsOf(context) &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    if (!shouldPlay) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (_timer != null) return;
    _timer = Timer.periodic(animation.frameDuration, (_) {
      if (!mounted) return;
      setState(() {
        _sequenceIndex = (_sequenceIndex + 1) % animation.sequence.length;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation;
    if (animation == null || animation.frames.isEmpty) {
      return const Icon(
        Icons.fitness_center_outlined,
        size: 56,
        color: AppColors.textSecondary,
      );
    }

    final frameIndex = MediaQuery.disableAnimationsOf(context)
        ? animation.sequence.first
        : animation.sequence[_sequenceIndex % animation.sequence.length];
    if (frameIndex < 0 || frameIndex >= animation.frames.length) {
      return const Icon(
        Icons.fitness_center_outlined,
        size: 56,
        color: AppColors.textSecondary,
      );
    }

    return Semantics(
      image: true,
      label: 'Animación: ${widget.label}',
      child: ExcludeSemantics(
        child: SvgPicture.asset(
          animation.frames[frameIndex],
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(
            AppColors.textPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
