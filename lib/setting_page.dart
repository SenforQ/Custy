import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'services/user_profile_service.dart';
import 'widgets/base_background.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const _continents = [
    'Africa',
    'Antarctica',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania',
  ];

  final Set<String> _selectedContinents = {};
  final TextEditingController _nicknameController =
      TextEditingController(text: 'Custy');
  final ImagePicker _picker = ImagePicker();
  String? _avatarRelativePath;
  String? _avatarAbsolutePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfileService.loadProfile();
    if (!mounted) return;
    String? absolutePath;
    if (profile.avatarPath != null) {
      absolutePath =
          await UserProfileService.absolutePathFromRelative(profile.avatarPath!);
    }
    setState(() {
      _nicknameController.text = profile.nickname;
      _avatarRelativePath = profile.avatarPath;
      _avatarAbsolutePath = absolutePath;
      _selectedContinents
        ..clear()
        ..addAll(profile.visitedContinents);
      _isLoading = false;
    });
  }

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
    final targetFile = File('${dir.path}/$fileName');
    await targetFile.writeAsBytes(await picked.readAsBytes());
    if (!mounted) return;
    setState(() {
      _avatarRelativePath = fileName;
      _avatarAbsolutePath = targetFile.path;
    });
  }

  Future<void> _handleSave() async {
    final nickname = _nicknameController.text.trim().isEmpty
        ? 'Custy'
        : _nicknameController.text.trim();
    final profile = UserProfile(
      nickname: nickname,
      avatarPath: _avatarRelativePath,
      visitedContinents: _selectedContinents.toList(),
    );
    await UserProfileService.saveProfile(profile);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved'),
        backgroundColor: Color(0xFF933996),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _pickAvatar,
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.white, width: 4),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: _avatarAbsolutePath != null &&
                                                File(_avatarAbsolutePath!)
                                                    .existsSync()
                                            ? Image.file(
                                                File(_avatarAbsolutePath!),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/user_default.webp',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _nicknameController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                    cursorColor: Colors.white,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Nickname',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Visited Continents',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: _continents.map((continent) {
                                final selected =
                                    _selectedContinents.contains(continent);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        _selectedContinents.remove(continent);
                                      } else {
                                        _selectedContinents.add(continent);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: selected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF7CE3FF),
                                                Color(0xFFDD7BFF)
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xFFBD3EEB),
                                                Color(0xFF933996)
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: selected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      continent,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
              ),
                GestureDetector(
                  onTap: _handleSave,
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
                        'SAVE',
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

