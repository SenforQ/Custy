import 'dart:io';

import 'package:flutter/material.dart';

import 'services/trip_storage_service.dart';
import 'tab_two_page.dart';
import 'total_share_detail_page.dart';
import 'widgets/base_background.dart';

class TabThreePage extends StatefulWidget {
  const TabThreePage({super.key, this.onCreateTap});

  final VoidCallback? onCreateTap;

  @override
  TabThreePageState createState() => TabThreePageState();
}

class TabThreePageState extends State<TabThreePage> {
  final Map<int, List<TripData>> _yearGroups = {};
  bool _isLoading = true;

  static const _moodAssets = [
    'assets/img_post_joyful.webp',
    'assets/img_post_chill.webp',
    'assets/img_post_weary.webp',
  ];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> reloadTrips() async {
    await _loadTrips();
  }

  Future<void> _loadTrips() async {
    final trips = await TripStorageService.loadTrips();
    final sorted = List<TripData>.from(trips)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    final groups = <int, List<TripData>>{};
    for (final trip in sorted) {
      final year = trip.startTime.year;
      groups.putIfAbsent(year, () => []).add(trip);
    }
    if (!mounted) return;
    setState(() {
      _yearGroups
        ..clear()
        ..addAll(groups);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedYears = _yearGroups.keys.toList()..sort((a, b) => b.compareTo(a));

    return BaseBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : _yearGroups.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hinerany',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Come and write down your travel stories~',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          'No journeys yet.\nCreate a trip to see it here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            if (widget.onCreateTap != null) {
                              widget.onCreateTap!.call();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TabTwoPage(),
                                ),
                              );
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7CE3FF), Color(0xFFDD7BFF)],
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Center(
                              child: Text(
                                'CREATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Hinerany',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Come and write down your travel stories~',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ...sortedYears.map(
                            (year) => _YearSection(
                              year: year,
                              trips: _yearGroups[year]!,
                              moodAssets: _moodAssets,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class _YearSection extends StatelessWidget {
  const _YearSection({
    required this.year,
    required this.trips,
    required this.moodAssets,
  });

  final int year;
  final List<TripData> trips;
  final List<String> moodAssets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineColumn(count: trips.length),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7CE3FF), Color(0xFFDD7BFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    year.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...trips.asMap().entries.map((entry) {
                  final index = entry.key;
                  final trip = entry.value;
                  final isLast = index == trips.length - 1;
                  final moodAsset =
                      moodAssets[trip.selectedMoodIndex % moodAssets.length];
                  return _TripCard(
                    trip: trip,
                    moodAsset: moodAsset,
                    isLast: isLast,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineColumn extends StatelessWidget {
  const _TimelineColumn({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (index) {
        final isLast = index == count - 1;
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFE66EA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.pets,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 4,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.moodAsset,
    required this.isLast,
  });

  final TripData trip;
  final String moodAsset;
  final bool isLast;

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final card = GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TotalShareDetailPage(tripData: trip),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: trip.coverImagePath.isNotEmpty &&
                        File(trip.coverImagePath).existsSync()
                    ? Image.file(
                        File(trip.coverImagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.black26,
                      ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.travelName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${trip.destination} · ${_formatDate(trip.startTime)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.asset(
                    moodAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return card;
  }
}

