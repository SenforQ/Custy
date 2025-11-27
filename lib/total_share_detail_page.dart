import 'dart:io';

import 'package:flutter/material.dart';

import 'tab_two_page.dart';
import 'widgets/base_background.dart';

class TotalShareDetailPage extends StatelessWidget {
  const TotalShareDetailPage({super.key, required this.tripData});

  final TripData tripData;

  static const _gradient = LinearGradient(
    colors: [Color(0xFFBD3EEB), Color(0xFF933996)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _navHeight = 56.0;

  static const _moods = [
    _MoodItem(label: 'Joyful', asset: 'assets/img_post_joyful.webp'),
    _MoodItem(label: 'Chill', asset: 'assets/img_post_chill.webp'),
    _MoodItem(label: 'Weary', asset: 'assets/img_post_weary.webp'),
  ];

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final bottomSpacing = mediaQuery.padding.bottom + 76;

    return BaseBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
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
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Trip Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 32),
                _SectionHeader(label: 'Travel name'),
                _GradientBox(
                  child: Text(
                    tripData.travelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _SectionHeader(label: 'Travel cover'),
                _GradientBox(
                  height: 200,
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox.expand(
                      child: Image.file(
                        File(tripData.coverImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _SectionHeader(label: 'Travel time'),
                Row(
                  children: [
                    Expanded(
                      child: _GradientBox(
                        height: 56,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _formatDateTime(tripData.startTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 32,
                      height: 2,
                      color: const Color(0x55FFFFFF),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GradientBox(
                        height: 56,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _formatDateTime(tripData.endTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionHeader(label: 'Travel destinations'),
                _GradientBox(
                  child: Text(
                    tripData.destination,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Mood tags',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'After adding, mood stickers will appear in your personal footprint.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 140,
                  child: Center(
                    child: _MoodTag(
                      label: _moods[tripData.selectedMoodIndex].label,
                      asset: _moods[tripData.selectedMoodIndex].asset,
                      selected: true,
                    ),
                  ),
                ),
                SizedBox(height: bottomSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.none,
      ),
    );
  }
}

class _GradientBox extends StatelessWidget {
  const _GradientBox({
    required this.child,
    this.height,
    this.padding,
  });

  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.only(top: 8),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: TotalShareDetailPage._gradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _MoodTag extends StatelessWidget {
  const _MoodTag({
    required this.label,
    required this.asset,
    this.selected = false,
  });

  final String label;
  final String asset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFFDD7BFF) : Colors.white.withOpacity(0.7);
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: const Color(0x802B0037),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodItem {
  const _MoodItem({required this.label, required this.asset});

  final String label;
  final String asset;
}

