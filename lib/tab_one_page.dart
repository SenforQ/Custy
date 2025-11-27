import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_top_travel_page.dart';
import 'report_page.dart';
import 'services/blocked_users_service.dart';
import 'travel_detail_page.dart';
import 'widgets/base_background.dart';

class TabOnePage extends StatefulWidget {
  const TabOnePage({super.key, this.onBannerTap});

  final VoidCallback? onBannerTap;

  @override
  State<TabOnePage> createState() => _TabOnePageState();
}

class _TabOnePageState extends State<TabOnePage> {
  List<Character> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/custy_characters.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      // Get blocked and muted users
      final blockedUsers = await BlockedUsersService.getBlockedUsers();
      final mutedUsers = await BlockedUsersService.getMutedUsers();
      final allBlocked = {...blockedUsers, ...mutedUsers};

      if (!mounted) return;
      setState(() {
        _characters = jsonList
            .map((json) => Character.fromJson(json))
            .where((character) => !allBlocked.contains(character.nickName))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showActionSheet(BuildContext context, Character character) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReportPage(character: character),
                ),
              );
            },
            child: const Text(
              'Report',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await BlockedUsersService.blockUser(character.nickName);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User blocked successfully'),
                  backgroundColor: Color(0xFF933996),
                ),
              );
              _loadCharacters();
            },
            child: const Text(
              'Block',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await BlockedUsersService.muteUser(character.nickName);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User muted successfully'),
                  backgroundColor: Color(0xFF933996),
                ),
              );
              _loadCharacters();
            },
            child: const Text(
              'Mute',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF007AFF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'assets/img_home_recommended.webp',
                    width: 182,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _RecommendedCard(
                        asset: 'assets/img_home_paris.webp',
                        city: 'Paris',
                      ),
                      const SizedBox(width: 4),
                      _RecommendedCard(
                        asset: 'assets/img_home_barcelona.webp',
                        city: 'Barcelona',
                      ),
                      const SizedBox(width: 4),
                      _RecommendedCard(
                        asset: 'assets/img_home_london.webp',
                        city: 'London',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: widget.onBannerTap,
                    behavior: HitTestBehavior.opaque,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 93,
                        child: Image.asset(
                          'assets/img_home_banner.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'assets/img_home_popular.webp',
                    width: 230,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  ..._characters.map((character) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => TravelDetailPage(
                                      character: character,
                                    ),
                                  ),
                                )
                                .then((value) {
                              if (value == true) {
                                _loadCharacters();
                              }
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 192,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    character.travelBG,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0),
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showActionSheet(context, character);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          character.coverTitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          character.coverContent,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            decoration: TextDecoration.none,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 76),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.asset,
    required this.city,
  });

  final String asset;
  final String city;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HomeTopTravelPage(city: city),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          width: 162,
          height: 220,
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class Character {
  final String nickName;
  final String userIcon;
  final List<String> showPhotoArray;
  final List<String> showVideoArray;
  final List<String> showThumbnailArray;
  final String showMotto;
  final int showFollowNum;
  final int showLike;
  final String showSayhi;
  final String travelBG;
  final String coverTitle;
  final String coverContent;

  Character({
    required this.nickName,
    required this.userIcon,
    required this.showPhotoArray,
    required this.showVideoArray,
    required this.showThumbnailArray,
    required this.showMotto,
    required this.showFollowNum,
    required this.showLike,
    required this.showSayhi,
    required this.travelBG,
    required this.coverTitle,
    required this.coverContent,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      nickName: json['CustyNickName'] ?? '',
      userIcon: json['CustyUserIcon'] ?? '',
      showPhotoArray: List<String>.from(json['CustyShowPhotoArray'] ?? []),
      showVideoArray: List<String>.from(json['CustyShowVideoArray'] ?? []),
      showThumbnailArray:
          List<String>.from(json['CustyShowThumbnailArray'] ?? []),
      showMotto: json['CustyShowMotto'] ?? '',
      showFollowNum: json['CustyShowFollowNum'] ?? 0,
      showLike: json['CustyShowLike'] ?? 0,
      showSayhi: json['CustyShowSayhi'] ?? '',
      travelBG: json['CustyTravelBG'] ?? '',
      coverTitle: json['CustyCoverTitle'] ?? '',
      coverContent: json['CustyCoverContent'] ?? '',
    );
  }
}

