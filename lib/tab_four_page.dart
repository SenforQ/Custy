import 'dart:io';

import 'package:flutter/material.dart';

import 'privacy_policy_custy_page.dart';
import 'about_us_custy_page.dart';
import 'services/user_profile_service.dart';
import 'setting_page.dart';
import 'terms_custy_page.dart';
import 'total_share_page.dart';
import 'wallet_page.dart';
import 'vip_page.dart';
import 'widgets/base_background.dart';

class TabFourPage extends StatefulWidget {
  const TabFourPage({
    super.key,
    this.totalShare = 0,
    this.recordingDurationDays = 1,
    this.appStartDate,
  });

  final int totalShare;
  final int recordingDurationDays;
  final DateTime? appStartDate;

  @override
  State<TabFourPage> createState() => _TabFourPageState();
}

class _TabFourPageState extends State<TabFourPage> {
  String _nickname = 'Custy';
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfileService.loadProfile();
    String? absolute;
    if (profile.avatarPath != null) {
      absolute =
          await UserProfileService.absolutePathFromRelative(profile.avatarPath!);
    }
    if (!mounted) return;
    setState(() {
      _nickname = profile.nickname;
      _avatarPath = absolute;
    });
  }

  static const _actionItems = [
    _ActionItem(
      title: 'Setting',
      assetPath: 'assets/icon_me_setting.webp',
      openSettingPage: true,
    ),
    _ActionItem(
      title: 'Privacy Policy',
      assetPath: 'assets/icon_me_privacy_policy.webp',
      openPrivacyPage: true,
    ),
    _ActionItem(
      title: 'User Agreement',
      assetPath: 'assets/icon_me_user_agreement.webp',
      openTermsPage: true,
    ),
    _ActionItem(
      title: 'About us',
      assetPath: 'assets/icon_me_about_us.webp',
      openAboutPage: true,
    ),
  ];

  void _handleRecordingDurationTap() {
    if (widget.appStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No registration date available'),
          backgroundColor: Color(0xFF933996),
        ),
      );
      return;
    }
    final dateText = _formatDate(widget.appStartDate!);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text(
          'Registration Date',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          dateText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFDD7BFF)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpacing = MediaQuery.of(context).padding.bottom + 76;
    return BaseBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 78),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 6),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _avatarPath != null && File(_avatarPath!).existsSync()
                        ? Image.file(
                            File(_avatarPath!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/user_default.webp',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _nickname,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _handleRecordingDurationTap,
                        behavior: HitTestBehavior.opaque,
                        child: _InfoCard(
                          title: 'Recording duration',
                          value: widget.recordingDurationDays.toString(),
                          unit: 'Days',
                          assetPath: 'assets/icon_me_duration.webp',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TotalSharePage(),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: _InfoCard(
                          title: 'Total Share',
                          value: widget.totalShare.toString(),
                          unit: 'Article',
                          assetPath: 'assets/icon_me_post.webp',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _CapsuleButton(
                        title: 'Wallet',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WalletPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CapsuleButton(
                        title: 'VIP',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const VipPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(
                    _actionItems.length,
                    (index) {
                      final item = _actionItems[index];
                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                        child: _ActionCell(
                          item: item,
                          onTap: () => _handleActionTap(item),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }

  void _handleActionTap(_ActionItem item) {
    if (item.openTermsPage) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const TermsCustyPage(),
        ),
      );
      return;
    }
    if (item.openPrivacyPage) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PrivacyPolicyCustyPage(),
        ),
      );
      return;
    }
    if (item.openAboutPage) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AboutUsCustyPage(),
        ),
      );
      return;
    }
    if (item.openSettingPage) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => const SettingPage(),
            ),
          )
          .then((value) {
        if (value == true) {
          _loadProfile();
        }
      });
    }
  }
}

class _ActionCell extends StatelessWidget {
  const _ActionCell({required this.item, this.onTap});

  final _ActionItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0x80333333),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFFE66EA),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              item.assetPath,
              width: 26,
              height: 26,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.title,
    required this.assetPath,
    this.openTermsPage = false,
    this.openPrivacyPage = false,
    this.openAboutPage = false,
    this.openSettingPage = false,
  });

  final String title;
  final String assetPath;
  final bool openTermsPage;
  final bool openPrivacyPage;
  final bool openAboutPage;
  final bool openSettingPage;
}

class _CapsuleButton extends StatelessWidget {
  const _CapsuleButton({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7CE3FF), Color(0xFFDD7BFF)],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.assetPath,
  });

  final String title;
  final String value;
  final String unit;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF933996),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$value ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: unit,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white30,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

