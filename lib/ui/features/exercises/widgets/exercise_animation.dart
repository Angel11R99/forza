import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../app/theme/app_colors.dart';

class ExerciseAnimationView extends StatefulWidget {
  const ExerciseAnimationView({
    super.key,
    required this.exerciseId,
    required this.animation,
    required this.label,
    this.fallbackIcon = Icons.fitness_center_outlined,
    this.showControls = false,
  });

  final String exerciseId;
  final ExerciseAnimation? animation;
  final String label;
  final IconData fallbackIcon;
  final bool showControls;

  @override
  State<ExerciseAnimationView> createState() => _ExerciseAnimationViewState();
}

class _ExerciseAnimationViewState extends State<ExerciseAnimationView>
    with WidgetsBindingObserver {
  static const _noAnimationIds = <String>{
    '1383',
    '1384',
    '0558',
    '1420',
    '0675',
    '0678',
    '2208',
    '2209',
    '0818',
    '1466',
    '2802',
    '2801',
    '3231',
    '1365',
    '1366',
    '3420',
    '0826',
    '2141',
    '3655',
    '1460',
    '3666',
    '2311',
    '0830',
    '2987',
    '3643',
    '0832',
    '3670',
    '0833',
    '1310',
    '2135',
    '0834',
    '0866',
    '0835',
    '3641',
    '3644',
    '3286',
    '3312',
    '3290',
    '0840',
    '0841',
    '0844',
    '0846',
    '0845',
    '2371',
    '0847',
    '0849',
    '0850',
    '0851',
    '0852',
    '0853',
    '0854',
    '3313',
    '3642',
    '0856',
    '1754',
    '1755',
    '1767',
    '0857',
    '3637',
    '1429',
    '1367',
    '1311',
    '2363',
    '0858',
    '1604',
    '1428',
    '0859',
  };

  Timer? _timer;
  int _sequenceIndex = 0;
  bool _paused = false;

  ExerciseAnimation? get _playback =>
      widget.animation ??
      (_noAnimationIds.contains(widget.exerciseId)
          ? null
          : ExerciseAnimation(
              frames: List.generate(
                3,
                (index) =>
                    'assets/exercise_animations/${widget.exerciseId}_frame-${index.toString().padLeft(2, '0')}.svg',
              ),
              sequence: const [0, 1, 2, 1],
              frameDuration: const Duration(milliseconds: 180),
            ));

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
    final animation = _playback;
    final shouldPlay =
        animation != null &&
        !_paused &&
        !MediaQuery.disableAnimationsOf(context) &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    if (!shouldPlay) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (_timer != null) return;
    final frameDuration = Duration(
      milliseconds: (animation.frameDuration.inMilliseconds / 0.75).round(),
    );
    _timer = Timer.periodic(frameDuration, (_) {
      if (!mounted) return;
      setState(() {
        _sequenceIndex = (_sequenceIndex + 1) % animation.sequence.length;
      });
    });
  }

  void _togglePlayback() {
    setState(() => _paused = !_paused);
    _syncPlayback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = _playback;
    if (animation == null || animation.frames.isEmpty) {
      return Icon(
        widget.fallbackIcon,
        size: 56,
        color: AppColors.textSecondary,
      );
    }

    final frameIndex = MediaQuery.disableAnimationsOf(context)
        ? animation.sequence.first
        : animation.sequence[_sequenceIndex % animation.sequence.length];
    if (frameIndex < 0 || frameIndex >= animation.frames.length) {
      return Icon(
        widget.fallbackIcon,
        size: 56,
        color: AppColors.textSecondary,
      );
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      image: true,
      label: 'Animación: ${widget.label}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExcludeSemantics(
            child: SvgPicture.asset(
              animation.frames[frameIndex],
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
              errorBuilder: (context, error, stackTrace) => Icon(
                widget.fallbackIcon,
                size: 56,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (widget.showControls && !reduceMotion)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton.filledTonal(
                onPressed: _togglePlayback,
                tooltip: _paused ? 'Reproducir animación' : 'Pausar animación',
                icon: Icon(
                  _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
