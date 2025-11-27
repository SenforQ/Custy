import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'figure_message_page.dart';
import 'photo_detail_page.dart';
import 'report_page.dart';
import 'services/blocked_users_service.dart';
import 'tab_one_page.dart';
import 'video_call_page.dart';
import 'video_detail_page.dart';

class FigureDetailPage extends StatelessWidget {
  const FigureDetailPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final backgroundImage = character.showPhotoArray.isNotEmpty
        ? character.showPhotoArray[0]
        : character.travelBG;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Navigation bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      GestureDetector(
                        onTap: () {
                          _showActionSheet(context);
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0x33FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Profile section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // User avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              character.userIcon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              character.nickName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF933996),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Motto
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            character.showMotto,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Action buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => VideoCallPage(
                                          character: character,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF933996),
                                          Color(0xFFDD7BFF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.videocam,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Video Call',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => FigureMessagePage(
                                          character: character,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7CE3FF),
                                          Color(0xFF4DD0E1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.message,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Message',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Travel Journal section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Row(
                                children: [
                                  const Text(
                                    'Travel Journal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 60,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF933996),
                                          Color(0xFFDD7BFF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Timeline
                              _buildTimeline(context),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final allItems = <_TimelineItem>[];

    // Add photos
    for (var i = 0; i < character.showPhotoArray.length; i++) {
      allItems.add(_TimelineItem(
        type: _TimelineItemType.photo,
        asset: character.showPhotoArray[i],
        date: DateTime.now().subtract(Duration(days: i * 2)),
      ));
    }

    // Add videos
    for (var i = 0; i < character.showVideoArray.length; i++) {
      final thumbnail = i < character.showThumbnailArray.length
          ? character.showThumbnailArray[i]
          : null;
      allItems.add(_TimelineItem(
        type: _TimelineItemType.video,
        asset: character.showVideoArray[i],
        thumbnail: thumbnail,
        date: DateTime.now()
            .subtract(Duration(days: character.showPhotoArray.length * 2 + i * 2)),
      ));
    }

    // Sort by date (newest first)
    allItems.sort((a, b) => b.date.compareTo(a.date));

    if (allItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'No content yet',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < allItems.length; i++)
          _buildTimelineEntry(context, allItems[i], i == allItems.length - 1),
      ],
    );
  }

  Widget _buildTimelineEntry(
      BuildContext context, _TimelineItem item, bool isLast) {
    final dateStr =
        '${item.date.year}-${item.date.month.toString().padLeft(2, '0')}-${item.date.day.toString().padLeft(2, '0')}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and marker
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFDD7BFF),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 200,
                color: const Color(0xFFDD7BFF),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (item.type == _TimelineItemType.video) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoDetailPage(
                          videoPath: item.asset,
                          thumbnailPath: item.thumbnail,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PhotoDetailPage(
                          imagePath: item.asset,
                        ),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: item.type == _TimelineItemType.video &&
                                item.thumbnail != null
                            ? Image.asset(
                                item.thumbnail!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                item.asset,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (item.type == _TimelineItemType.video)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Color(0xFF933996),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  void _showActionSheet(BuildContext context) {
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
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User blocked successfully'),
                  backgroundColor: Color(0xFF933996),
                ),
              );
              Navigator.of(context).pop(true);
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
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User muted successfully'),
                  backgroundColor: Color(0xFF933996),
                ),
              );
              Navigator.of(context).pop(true);
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
}

enum _TimelineItemType { photo, video }

class _TimelineItem {
  final _TimelineItemType type;
  final String asset;
  final String? thumbnail;
  final DateTime date;

  _TimelineItem({
    required this.type,
    required this.asset,
    this.thumbnail,
    required this.date,
  });
}

