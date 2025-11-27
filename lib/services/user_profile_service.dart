import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class UserProfile {
  const UserProfile({
    required this.nickname,
    this.avatarPath,
    required this.visitedContinents,
  });

  final String nickname;
  final String? avatarPath; // relative path inside Documents
  final List<String> visitedContinents;

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'avatarPath': avatarPath,
      'visitedContinents': visitedContinents,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String? ?? 'Custy',
      avatarPath: json['avatarPath'] as String?,
      visitedContinents: (json['visitedContinents'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  factory UserProfile.empty() =>
      const UserProfile(nickname: 'Custy', avatarPath: null, visitedContinents: []);
}

class UserProfileService {
  static const _fileName = 'user_profile.json';

  static Future<File> _localFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  static Future<String> _documentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<UserProfile> loadProfile() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) {
        return UserProfile.empty();
      }
      final contents = await file.readAsString();
      final jsonMap = json.decode(contents) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (_) {
      return UserProfile.empty();
    }
  }

  static Future<void> saveProfile(UserProfile profile) async {
    try {
      final file = await _localFile();
      await file.writeAsString(json.encode(profile.toJson()));
    } catch (_) {
      // ignore write errors for now
    }
  }

  static Future<String?> absolutePathFromRelative(String relativePath) async {
    final path = await _documentsPath();
    return '$path/$relativePath';
  }
}
 