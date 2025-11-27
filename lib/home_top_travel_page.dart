import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeTopTravelPage extends StatefulWidget {
  const HomeTopTravelPage({super.key, required this.city});

  final String city;

  @override
  State<HomeTopTravelPage> createState() => _HomeTopTravelPageState();
}

class _HomeTopTravelPageState extends State<HomeTopTravelPage> {
  TravelPlan? _plan;
  int _selectedDay = 1;
  bool _isLoading = true;
  bool _showAllPlans = false;

  @override
  void initState() {
    super.initState();
    _loadTravelPlan();
  }

  Future<void> _loadTravelPlan() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/travel_plans.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      final planData = jsonList.firstWhere(
        (item) => item['city'] == widget.city,
        orElse: () => null,
      );

      if (planData != null) {
        setState(() {
          _plan = TravelPlan.fromJson(planData);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  DayPlan? get _currentDayPlan {
    if (_plan == null) return null;
    try {
      return _plan!.days.firstWhere((day) => day.day == _selectedDay);
    } catch (e) {
      return _plan!.days.isNotEmpty ? _plan!.days.first : null;
    }
  }

  Widget _buildSingleDayView() {
    if (_currentDayPlan == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentDayPlan!.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        ..._currentDayPlan!.activities.map((activity) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(
                    top: 6,
                    right: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDD7BFF),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    activity,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAllPlansView() {
    if (_plan == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _plan!.days.map((day) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              ...day.activities.map((activity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(
                          top: 6,
                          right: 12,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDD7BFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          activity,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _plan == null
              ? const Center(
                  child: Text(
                    'Travel plan not found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Image.asset(
                        _plan!.baseImage,
                        width: screenSize.width,
                        height: screenSize.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Dark overlay gradient from bottom
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.7),
                              Colors.black,
                            ],
                            stops: const [0.0, 0.4, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Column(
                        children: [
                          // Navigation Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
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
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Travel Planning',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 48),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Bottom Sheet
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                // Day Selection Buttons
                                SizedBox(
                                  height: 42,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        _DayButton(
                                          label: 'All plans',
                                          isSelected: _showAllPlans,
                                          onTap: () {
                                            setState(() {
                                              _showAllPlans = true;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        ..._plan!.days.map((day) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 12),
                                            child: _DayButton(
                                              label: 'Day${day.day}',
                                              isSelected: !_showAllPlans && _selectedDay == day.day,
                                              onTap: () {
                                                setState(() {
                                                  _showAllPlans = false;
                                                  _selectedDay = day.day;
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Content Area with max height
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: screenSize.height / 2,
                                  ),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: _showAllPlans
                                        ? _buildAllPlansView()
                                        : _buildSingleDayView(),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).padding.bottom + 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF933996)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF933996),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class TravelPlan {
  TravelPlan({
    required this.city,
    required this.baseImage,
    required this.days,
  });

  final String city;
  final String baseImage;
  final List<DayPlan> days;

  factory TravelPlan.fromJson(Map<String, dynamic> json) {
    return TravelPlan(
      city: json['city'] as String,
      baseImage: json['baseImage'] as String,
      days: (json['days'] as List<dynamic>)
          .map((day) => DayPlan.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DayPlan {
  DayPlan({
    required this.day,
    required this.title,
    required this.activities,
  });

  final int day;
  final String title;
  final List<String> activities;

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'] as int,
      title: json['title'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((activity) => activity as String)
          .toList(),
    );
  }
}

