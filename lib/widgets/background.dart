import 'package:flutter/material.dart';

class NadaCilikBackground extends StatelessWidget {
  final Widget child;
  final String footerType; // 'music', 'sleep', 'book'

  const NadaCilikBackground({
    super.key,
    required this.child,
    this.footerType = 'music',
  });

  String _getAssetPath() {
    switch (footerType) {
      case 'book':
        return 'assets/images/bg_book.jpg';
      case 'sleep':
        return 'assets/images/bg_sleep.jpg';
      case 'music':
      default:
        return 'assets/images/bg_music.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen Background Image
        Positioned.fill(
          child: Image.asset(
            _getAssetPath(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback gradient in case assets are missing or loading fails
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE3F2FD),
                      Color(0xFFBBDEFB),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.blueAccent,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ),

        // Optional very subtle overlay for contrast if needed
        Positioned.fill(
          child: Container(
            color: Colors.black.withAlpha(5),
          ),
        ),

        // The actual page content
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}
