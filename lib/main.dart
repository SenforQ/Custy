import 'package:flutter/material.dart';

import 'services/trip_storage_service.dart';
import 'services/user_metrics_service.dart';
import 'tab_four_page.dart';
import 'tab_one_page.dart';
import 'tab_three_page.dart';
import 'tab_two_page.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'custy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF333333),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF333333),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF333333),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: WelcomePage(
        onEnter: (context) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'custy'),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  int _totalShare = 0;
  int _recordingDays = 1;
  DateTime? _appStartDate;
  final GlobalKey<TabThreePageState> _tabThreeKey =
      GlobalKey<TabThreePageState>();

  @override
  void initState() {
    super.initState();
    _initAppData();
  }

  Future<void> _initAppData() async {
    final tripsFuture = TripStorageService.loadTrips();
    final startDateFuture = UserMetricsService.getOrCreateAppStartDate();

    final trips = await tripsFuture;
    final startDate = await startDateFuture;

    if (!mounted) return;
    setState(() {
      _totalShare = trips.length;
      _appStartDate = startDate;
      _recordingDays = _calculateRecordingDays(startDate);
    });
  }

  int _calculateRecordingDays(DateTime startDate) {
    final diff = DateTime.now().difference(startDate).inDays;
    return diff < 0 ? 1 : diff + 1;
  }

  static const _tabItems = [
    _TabItem(
      label: '首页',
      normalAsset: 'assets/btn_tab_home_pre.webp',
      selectedAsset: 'assets/btn_tab_home_nor.webp',
    ),
    _TabItem(
      label: '发布',
      normalAsset: 'assets/btn_tab_post_pre.webp',
      selectedAsset: 'assets/btn_tab_post_nor.webp',
    ),
    _TabItem(
      label: '足迹',
      normalAsset: 'assets/btn_tab_footprint_pre.webp',
      selectedAsset: 'assets/btn_tab_footprint_nor.webp',
    ),
    _TabItem(
      label: '我的',
      normalAsset: 'assets/btn_tab_me_pre.webp',
      selectedAsset: 'assets/btn_tab_me_nor.webp',
    ),
  ];

  List<Widget> get _tabPages => [
        TabOnePage(
          onBannerTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
        TabTwoPage(
          onTripCreated: () {
            setState(() {
              _totalShare++;
              _recordingDays =
                  _calculateRecordingDays(_appStartDate ?? DateTime.now());
            });
            _tabThreeKey.currentState?.reloadTrips();
          },
        ),
        TabThreePage(
          key: _tabThreeKey,
          onCreateTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
        TabFourPage(
          totalShare: _totalShare,
          recordingDurationDays: _recordingDays,
          appStartDate: _appStartDate,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _tabPages,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _FloatingTabBar(
                  items: _tabItems,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingTabBar extends StatelessWidget {
  const _FloatingTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_TabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = (screenWidth - 80).clamp(0.0, screenWidth);
    return Container(
      width: barWidth,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(29),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          return _TabButton(
            item: item,
            isSelected: isSelected,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _TabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isSelected ? item.selectedAsset : item.normalAsset,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.normalAsset,
    required this.selectedAsset,
  });

  final String label;
  final String normalAsset;
  final String selectedAsset;
}
