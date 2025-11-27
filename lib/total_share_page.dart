import 'dart:io';

import 'package:flutter/material.dart';

import 'services/trip_storage_service.dart';
import 'tab_two_page.dart';
import 'total_share_detail_page.dart';
import 'widgets/base_background.dart';

class TotalSharePage extends StatefulWidget {
  const TotalSharePage({super.key});

  @override
  State<TotalSharePage> createState() => _TotalSharePageState();
}

class _TotalSharePageState extends State<TotalSharePage> {
  static const _navHeight = 56.0;
  List<TripData> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final trips = await TripStorageService.loadTrips();
    if (mounted) {
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final bottomSpacing = mediaQuery.padding.bottom + 76;

    return BaseBackground(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight + _navHeight,
            child: Container(
              padding: EdgeInsets.only(top: statusBarHeight),
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Total Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
          Positioned(
            top: statusBarHeight + _navHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : _trips.isEmpty
                    ? Center(
                        child: Text(
                          'Your shared trips will appear here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _trips.length,
                        itemBuilder: (context, index) {
                          final trip = _trips[index];
                          return _TripCard(
                            trip: trip,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TotalShareDetailPage(tripData: trip),
                                ),
                              ).then((_) {
                                _loadTrips();
                              });
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip, this.onTap});

  final TripData trip;
  final VoidCallback? onTap;

  static const _gradient = LinearGradient(
    colors: [Color(0xFFBD3EEB), Color(0xFF933996)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: _gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: File(trip.coverImagePath).existsSync()
                    ? Image.file(
                        File(trip.coverImagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.white.withOpacity(0.1),
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.travelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trip.destination,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatDateTime(trip.startTime)} - ${_formatDateTime(trip.endTime)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

