import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'services/coin_service.dart';
import 'services/trip_storage_service.dart';
import 'total_share_detail_page.dart';
import 'wallet_page.dart';
import 'widgets/base_background.dart';

class TabTwoPage extends StatefulWidget {
  const TabTwoPage({super.key, this.onTripCreated});

  final VoidCallback? onTripCreated;

  @override
  State<TabTwoPage> createState() => _TabTwoPageState();
}

class _TabTwoPageState extends State<TabTwoPage> {
  static const _gradient = LinearGradient(
    colors: [Color(0xFFBD3EEB), Color(0xFF933996)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final _moods = const [
    _MoodItem(label: 'Joyful', asset: 'assets/img_post_joyful.webp'),
    _MoodItem(label: 'Chill', asset: 'assets/img_post_chill.webp'),
    _MoodItem(label: 'Weary', asset: 'assets/img_post_weary.webp'),
  ];

  int _selectedMoodIndex = 0;
  final ImagePicker _picker = ImagePicker();
  String? _coverRelativePath;
  String? _documentsDirPath;
  
  final TextEditingController _travelNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _loadDocumentsDir();
  }

  @override
  void dispose() {
    _travelNameController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _loadDocumentsDir() async {
    final dir = await getApplicationDocumentsDirectory();
    if (!mounted) return;
    setState(() {
      _documentsDirPath = dir.path;
    });
  }

  Future<void> _pickCoverImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }
    final dirPath = _documentsDirPath ??
        (await getApplicationDocumentsDirectory()).path;
    final fileName =
        'cover_${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
    final targetFile = File('$dirPath/$fileName');
    await targetFile.writeAsBytes(await picked.readAsBytes());
    if (!mounted) return;
    setState(() {
      _documentsDirPath = dirPath;
      _coverRelativePath = fileName;
    });
  }

  String? get _coverImagePath {
    if (_documentsDirPath == null || _coverRelativePath == null) {
      return null;
    }
    return '${_documentsDirPath!}/$_coverRelativePath';
  }

  Future<void> _pickStartTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFBD3EEB),
              onPrimary: Colors.white,
              surface: Color(0xFF333333),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFBD3EEB),
                onPrimary: Colors.white,
                surface: Color(0xFF333333),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
      if (time != null && mounted) {
        setState(() {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endTime ?? (_startTime ?? DateTime.now()),
      firstDate: _startTime ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFBD3EEB),
              onPrimary: Colors.white,
              surface: Color(0xFF333333),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFBD3EEB),
                onPrimary: Colors.white,
                surface: Color(0xFF333333),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
      if (time != null && mounted) {
        setState(() {
          _endTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleConfirm() async {
    final travelName = _travelNameController.text.trim();
    final destination = _destinationController.text.trim();
    
    if (travelName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the travel name'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    if (_coverRelativePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add travel cover'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    if (_startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start time'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    if (_endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select end time'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    if (_endTime!.isBefore(_startTime!) || _endTime!.isAtSameMomentAs(_startTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be greater than start time'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter travel destinations'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    // Check coins before creating trip
    const requiredCoins = 120;
    final currentCoins = await CoinService.getCurrentCoins();
    
    if (currentCoins < requiredCoins) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Insufficient Coins',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Create New Trip requires $requiredCoins Coins. You currently have $currentCoins Coins. Please purchase more coins.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF999999),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WalletPage(),
                  ),
                );
              },
              child: const Text(
                'Go to Wallet',
                style: TextStyle(
                  color: Color(0xFFDD7BFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }
    
    // Show confirmation dialog
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFDD7BFF)),
            SizedBox(width: 8),
            Text(
              'Confirm Purchase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Create New Trip will consume $requiredCoins Coins. You currently have $currentCoins Coins. Do you want to continue?',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF999999),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF933996),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed != true) {
      return;
    }
    
    // Deduct coins
    final success = await CoinService.deductCoins(requiredCoins);
    if (!success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to deduct coins. Please try again.'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    
    // All validations passed, handle confirm action
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trip created successfully! $requiredCoins Coins deducted.'),
        backgroundColor: const Color(0xFF933996),
      ),
    );
    
    // Increment total share count
    widget.onTripCreated?.call();
    
    // Save data before clearing
    final tripData = TripData(
      travelName: travelName,
      destination: destination,
      startTime: _startTime!,
      endTime: _endTime!,
      coverImagePath: _coverImagePath!,
      selectedMoodIndex: _selectedMoodIndex,
    );
    
    // Save to local storage
    await TripStorageService.saveTrip(tripData);
    
    // Clear all form data
    setState(() {
      _travelNameController.clear();
      _destinationController.clear();
      _startTime = null;
      _endTime = null;
      _coverRelativePath = null;
      _selectedMoodIndex = 0;
    });
    
    // Navigate to total share detail page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TotalShareDetailPage(tripData: tripData),
      ),
    );

    widget.onTripCreated?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpacing = MediaQuery.of(context).padding.bottom + 76;
    return BaseBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Create New Trip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _SectionHeader(label: 'Enter the travel name'),
                _GradientBox(
                  child: TextField(
                    controller: _travelNameController,
                    decoration: _inputDecoration(''),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _SectionHeader(label: 'Add travel cover'),
                _buildCoverPicker(),
                const SizedBox(height: 24),
                _SectionHeader(label: 'Travel time'),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickStartTime,
                        behavior: HitTestBehavior.opaque,
                        child: _GradientBox(
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _startTime == null
                                      ? 'Start'
                                      : _formatDateTime(_startTime),
                                  style: TextStyle(
                                    color: _startTime == null
                                        ? Colors.white54
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                      child: GestureDetector(
                        onTap: _pickEndTime,
                        behavior: HitTestBehavior.opaque,
                        child: _GradientBox(
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _endTime == null
                                      ? 'End'
                                      : _formatDateTime(_endTime),
                                  style: TextStyle(
                                    color: _endTime == null
                                        ? Colors.white54
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionHeader(label: 'travel destinations'),
                _GradientBox(
                  child: TextField(
                    controller: _destinationController,
                    decoration: _inputDecoration('Destination'),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Add mood tags',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'After adding, mood stickers will appear in your personal footprint.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _moods.length,
                    itemBuilder: (context, index) {
                      final item = _moods[index];
                      return _MoodTag(
                        label: item.label,
                        asset: item.asset,
                        selected: index == _selectedMoodIndex,
                        onTap: () {
                          setState(() {
                            _selectedMoodIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: _handleConfirm,
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
                        'CONFIRM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildCoverPicker() {
    final coverPath = _coverImagePath;
    return GestureDetector(
      onTap: _pickCoverImage,
      behavior: HitTestBehavior.opaque,
      child: _GradientBox(
        height: 200,
        padding: EdgeInsets.zero,
        child: coverPath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image_outlined, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Upload cover',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox.expand(
                  child: Image.file(
                    File(coverPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      hintStyle: const TextStyle(color: Colors.white54),
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
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
        gradient: _TabTwoPageState._gradient,
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
    this.onTap,
  });

  final String label;
  final String asset;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFFDD7BFF) : Colors.white.withOpacity(0.7);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 16),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodItem {
  const _MoodItem({required this.label, required this.asset});

  final String label;
  final String asset;
}

class TripData {
  const TripData({
    required this.travelName,
    required this.destination,
    required this.startTime,
    required this.endTime,
    required this.coverImagePath,
    required this.selectedMoodIndex,
  });

  final String travelName;
  final String destination;
  final DateTime startTime;
  final DateTime endTime;
  final String coverImagePath;
  final int selectedMoodIndex;

  Map<String, dynamic> toJson() {
    // Extract relative path from absolute path
    final relativePath = coverImagePath.contains('Documents') 
        ? coverImagePath.split('Documents/').last
        : coverImagePath.split('/').last;
    
    return {
      'travelName': travelName,
      'destination': destination,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'coverImagePath': relativePath,
      'selectedMoodIndex': selectedMoodIndex,
    };
  }

  factory TripData.fromJson(Map<String, dynamic> json, String documentsPath) {
    // Reconstruct absolute path from relative path
    final coverImagePath = '${documentsPath}/${json['coverImagePath']}';
    
    return TripData(
      travelName: json['travelName'] as String,
      destination: json['destination'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      coverImagePath: coverImagePath,
      selectedMoodIndex: json['selectedMoodIndex'] as int,
    );
  }
}

