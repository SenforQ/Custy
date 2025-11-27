import 'package:flutter/material.dart';

class VideoDetailPage extends StatelessWidget {
  const VideoDetailPage({
    super.key,
    required this.videoPath,
    this.thumbnailPath,
  });

  final String videoPath;
  final String? thumbnailPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: thumbnailPath != null
                ? Image.asset(
                    thumbnailPath!,
                    fit: BoxFit.contain,
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Color(0xFF933996),
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

