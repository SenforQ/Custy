import 'package:flutter/material.dart';

class BaseBackground extends StatelessWidget {
  const BaseBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: Image.asset(
              'assets/base_bg.webp',
              fit: BoxFit.cover,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

