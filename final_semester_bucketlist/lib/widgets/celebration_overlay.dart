import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CelebrationOverlay extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const CelebrationOverlay({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();

    // 애니메이션이 끝나면 콜백 호출
    Future.delayed(const Duration(seconds: 3), () {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 반투명 오버레이
        Container(color: Colors.black54),
        
        // 축하 메시지
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_box,
                size: 50,
                color: Colors.lightBlue,
              ),
              const SizedBox(height: 16),
              Text(
                '버킷리스트 달성! 🎉',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // 폭죽 효과
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: -1.5708, // 아래쪽으로
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            maxBlastForce: 100,
            minBlastForce: 50,
            gravity: 0.3,
          ),
        ),
      ],
    );
  }
} 